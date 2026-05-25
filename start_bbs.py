#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
One-click launcher for BBS project on Windows.

What it does:
1) Ensure MySQL is running (local custom config).
2) Ensure Redis is running (Windows service).
3) Optionally build WAR (Maven + JDK8).
4) Deploy WAR to both contexts: /bbs and /leek_bbs.
5) Ensure Tomcat is running.
6) Health-check endpoints.
"""

from __future__ import annotations

import argparse
import os
import shutil
import socket
import subprocess
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path


ROOT = Path(__file__).resolve().parent
PROJECT_MAIN = ROOT / "项目代码" / "main"
TARGET_WAR = PROJECT_MAIN / "target" / "bbs.war"

TOOLS = ROOT / ".tools"
TOMCAT_HOME = TOOLS / "apache-tomcat-9.0.105"
TOMCAT_WEBAPPS = TOMCAT_HOME / "webapps"
TOMCAT_BIN = TOMCAT_HOME / "bin"
TOMCAT_STARTUP = TOMCAT_BIN / "startup.bat"

MAVEN_CMD = TOOLS / "apache-maven-3.9.9" / "bin" / "mvn.cmd"
JDK8_HOME = Path(r"C:\Program Files\Eclipse Adoptium\jdk-8.0.492.9-hotspot")

MYSQLD = Path(r"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe")
MYSQL_CONF = ROOT / ".tools" / "mysql" / "mysql-bbs.ini"

REDIS_CONF = Path(r"C:\Program Files\Redis\redis.windows-service.conf")
REDIS_SERVER = Path(r"C:\Program Files\Redis\redis-server.exe")
REDIS_CLI = Path(r"C:\Program Files\Redis\redis-cli.exe")
MYSQL_CLI = Path(r"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe")
SCHEMA_PATCH = ROOT / "schema_patch.sql"


def run(cmd: list[str], cwd: Path | None = None, env: dict[str, str] | None = None, check: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(
        cmd,
        cwd=str(cwd) if cwd else None,
        env=env,
        check=check,
        text=True,
        encoding="utf-8",
        errors="replace",
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )


def is_port_open(host: str, port: int, timeout: float = 1.0) -> bool:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        sock.settimeout(timeout)
        return sock.connect_ex((host, port)) == 0


def wait_port(host: str, port: int, timeout_sec: int = 60) -> bool:
    end = time.time() + timeout_sec
    while time.time() < end:
        if is_port_open(host, port):
            return True
        time.sleep(1)
    return False


def http_status(url: str, timeout_sec: int = 8) -> int | None:
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "bbs-launcher/1.0"})
        with urllib.request.urlopen(req, timeout=timeout_sec) as resp:
            return int(resp.status)
    except (urllib.error.URLError, TimeoutError, ValueError):
        return None


def ensure_mysql() -> None:
    print("[1/7] Checking MySQL...")
    if is_port_open("127.0.0.1", 3306):
        print("  - MySQL already running on 3306")
        return
    if not MYSQLD.exists():
        raise FileNotFoundError(f"MySQL not found: {MYSQLD}")
    if not MYSQL_CONF.exists():
        raise FileNotFoundError(f"MySQL config not found: {MYSQL_CONF}")
    subprocess.Popen(
        [str(MYSQLD), f"--defaults-file={MYSQL_CONF}"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
    )
    if not wait_port("127.0.0.1", 3306, timeout_sec=50):
        raise RuntimeError("MySQL failed to start on 3306")
    print("  - MySQL started")


def ensure_redis() -> None:
    print("[2/7] Checking Redis...")
    if is_port_open("127.0.0.1", 6379):
        print("  - Redis already running on 6379")
        return
    # Try service first
    try:
        run(["sc", "start", "Redis"], check=False)
    except Exception:
        pass
    if wait_port("127.0.0.1", 6379, timeout_sec=12):
        print("  - Redis service started")
        return
    # Fallback to process
    if REDIS_SERVER.exists() and REDIS_CONF.exists():
        subprocess.Popen(
            [str(REDIS_SERVER), str(REDIS_CONF)],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
        )
    if not wait_port("127.0.0.1", 6379, timeout_sec=20):
        raise RuntimeError("Redis failed to start on 6379")
    print("  - Redis started")


def apply_schema_patch() -> None:
    print("[3/7] Applying DB schema patch...")
    if not MYSQL_CLI.exists():
        raise FileNotFoundError(f"MySQL client not found: {MYSQL_CLI}")
    if not SCHEMA_PATCH.exists():
        raise FileNotFoundError(f"Schema patch file not found: {SCHEMA_PATCH}")
    sql = SCHEMA_PATCH.read_text(encoding="utf-8")
    p = subprocess.run(
        [str(MYSQL_CLI), "--default-character-set=utf8mb4", "-h", "127.0.0.1", "-P", "3306", "-u", "root", "-p123456"],
        input=sql,
        text=True,
        encoding="utf-8",
        errors="replace",
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    if p.returncode != 0:
        print(p.stdout)
        raise RuntimeError("Schema patch apply failed")
    print("  - Schema patch applied")


def clear_stale_cache() -> None:
    print("[5.5/7] Clearing stale cache...")
    if not REDIS_CLI.exists():
        print("  - redis-cli not found, skip cache clear")
        return
    try:
        run([str(REDIS_CLI), "-h", "127.0.0.1", "-p", "6379", "-a", "123456", "DEL", "plate:all"], check=False)
        print("  - Cleared key: plate:all")
    except Exception:
        print("  - Cache clear skipped (non-fatal)")


def build_war(rebuild: bool) -> None:
    print("[4/7] Checking WAR...")
    if TARGET_WAR.exists() and not rebuild:
        print(f"  - WAR exists: {TARGET_WAR}")
        return
    if not MAVEN_CMD.exists():
        raise FileNotFoundError(f"Maven not found: {MAVEN_CMD}")
    if not JDK8_HOME.exists():
        raise FileNotFoundError(f"JDK8 not found: {JDK8_HOME}")
    env = os.environ.copy()
    env["JAVA_HOME"] = str(JDK8_HOME)
    env["JRE_HOME"] = str(JDK8_HOME / "jre")
    env["Path"] = str(JDK8_HOME / "bin") + os.pathsep + env.get("Path", "")
    print("  - Building WAR with Maven, please wait...")
    result = run([str(MAVEN_CMD), "clean", "package", "-DskipTests"], cwd=PROJECT_MAIN, env=env, check=False)
    if result.returncode != 0:
        print(result.stdout)
        raise RuntimeError("Maven build failed")
    if not TARGET_WAR.exists():
        raise RuntimeError(f"WAR not found after build: {TARGET_WAR}")
    print("  - WAR build success")


def deploy_wars() -> None:
    print("[5/7] Deploying WARs...")
    if not TOMCAT_WEBAPPS.exists():
        raise FileNotFoundError(f"Tomcat webapps not found: {TOMCAT_WEBAPPS}")
    if not TARGET_WAR.exists():
        raise FileNotFoundError(f"WAR not found: {TARGET_WAR}")
    bbs_war = TOMCAT_WEBAPPS / "bbs.war"
    leek_war = TOMCAT_WEBAPPS / "leek_bbs.war"
    shutil.copy2(TARGET_WAR, bbs_war)
    shutil.copy2(TARGET_WAR, leek_war)
    print("  - Deployed bbs.war and leek_bbs.war")


def ensure_tomcat() -> None:
    print("[6/7] Checking Tomcat...")
    if not TOMCAT_STARTUP.exists():
        raise FileNotFoundError(f"Tomcat startup not found: {TOMCAT_STARTUP}")
    if is_port_open("127.0.0.1", 8080):
        print("  - Tomcat already running on 8080")
        return
    env = os.environ.copy()
    env["JAVA_HOME"] = str(JDK8_HOME)
    env["JRE_HOME"] = str(JDK8_HOME / "jre")
    env["Path"] = str(JDK8_HOME / "bin") + os.pathsep + env.get("Path", "")
    subprocess.Popen(
        [str(TOMCAT_STARTUP)],
        cwd=str(TOMCAT_BIN),
        env=env,
        shell=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
    )
    if not wait_port("127.0.0.1", 8080, timeout_sec=80):
        raise RuntimeError("Tomcat failed to start on 8080")
    print("  - Tomcat started")


def health_check() -> None:
    print("[7/7] Health checking...")
    urls = [
        "http://localhost:8080/leek_bbs/index",
        "http://localhost:8080/leek_bbs/statics/component/common_import.js",
        "http://localhost:8080/leek_bbs/bbs/plate/findAll",
        "http://localhost:8080/bbs/index",
    ]
    # Let hot deploy finish. Print progress so it doesn't look frozen in IDE console.
    ready = False
    for i in range(90):
        s1 = http_status(urls[1])
        s2 = http_status(urls[2])
        if s1 == 200 and s2 == 200:
            ready = True
            print(f"  - warmup ready after {i + 1}s")
            break
        if i % 5 == 0:
            print(f"  - waiting deploy... {i + 1}s (assets={s1}, api={s2})")
        time.sleep(1)
    if not ready:
        print("  - warmup timeout after 90s, continue with direct checks")
    for u in urls:
        s = http_status(u)
        print(f"  - {u} => {s if s is not None else 'ERR'}")
    print("\nRecommended URL:")
    print("  http://localhost:8080/leek_bbs/index")


def main() -> int:
    parser = argparse.ArgumentParser(description="Start BBS stack (MySQL + Redis + Tomcat).")
    parser.add_argument("--rebuild", action="store_true", help="Force Maven rebuild before deploy.")
    args = parser.parse_args()

    try:
        ensure_mysql()
        ensure_redis()
        apply_schema_patch()
        build_war(rebuild=args.rebuild)
        deploy_wars()
        clear_stale_cache()
        ensure_tomcat()
        health_check()
        print("\nAll done.")
        return 0
    except Exception as e:
        print(f"\nFAILED: {e}")
        return 1


if __name__ == "__main__":
    sys.exit(main())
