# 项目启动说明

本文档记录本项目在当前 Windows 本地环境中的启动方式。

## 访问地址

项目启动成功后，浏览器访问：

```text
http://localhost:8080/bbs/index
```

注意：`http://localhost:8080/bbs/` 会返回 404，本项目首页路由是 `/bbs/index`。

## 环境位置

项目根目录：

```text
F:\0000 job\0000 软件工程设计
```

Java Web 项目目录：

```text
F:\0000 job\0000 软件工程设计\项目代码\main
```

本地工具目录：

```text
F:\0000 job\0000 软件工程设计\.tools
```

已配置工具：

- JDK 8
- Maven：`.tools\apache-maven-3.9.9`
- Tomcat：`.tools\apache-tomcat-9.0.105`
- MySQL 8.4
- Redis

## 1. 启动 MySQL

在 PowerShell 中运行：

```powershell
Start-Process -FilePath "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" -ArgumentList "--defaults-file=C:\Users\epiph\.codex\memories\mysql-bbs.ini --console" -WindowStyle Hidden
```

检查 MySQL 是否启动：

```powershell
Test-NetConnection 127.0.0.1 -Port 3306
```

如果 `TcpTestSucceeded` 为 `True`，说明 MySQL 已经可用。

## 2. 检查 Redis

检查 Redis 是否已经运行：

```powershell
Get-Process redis-server
```

如果能看到 `redis-server` 进程，说明 Redis 已经启动。

项目 Redis 配置文件：

```text
项目代码\main\resources\redis.properties
```

默认配置：

```properties
redis.host=127.0.0.1
redis.port=6379
redis.password=123456
```

## 3. 启动 Tomcat

在 PowerShell 中运行：

```powershell
Start-Process -FilePath "F:\0000 job\0000 软件工程设计\.tools\apache-tomcat-9.0.105\bin\startup.bat" -WorkingDirectory "F:\0000 job\0000 软件工程设计\.tools\apache-tomcat-9.0.105\bin" -WindowStyle Hidden
```

检查 Tomcat 是否启动：

```powershell
Test-NetConnection 127.0.0.1 -Port 8080
```

如果 `TcpTestSucceeded` 为 `True`，说明 Tomcat 已经可用。

## 4. 打开网站

浏览器访问：

```text
http://localhost:8080/bbs/index
```

## 5. 修改代码后重新打包部署

进入项目目录：

```powershell
cd "F:\0000 job\0000 软件工程设计\项目代码\main"
```

使用本地 Maven 打包：

```powershell
"F:\0000 job\0000 软件工程设计\.tools\apache-maven-3.9.9\bin\mvn.cmd" clean package
```

打包成功后会生成：

```text
F:\0000 job\0000 软件工程设计\项目代码\main\target\bbs.war
```

把新的 `bbs.war` 复制到 Tomcat：

```powershell
Copy-Item -LiteralPath "F:\0000 job\0000 软件工程设计\项目代码\main\target\bbs.war" -Destination "F:\0000 job\0000 软件工程设计\.tools\apache-tomcat-9.0.105\webapps\bbs.war" -Force
```

然后重启 Tomcat，重新访问：

```text
http://localhost:8080/bbs/index
```

## 常见问题

### 访问 `/bbs/` 是 404

这是正常现象。请访问：

```text
http://localhost:8080/bbs/index
```

### Tomcat 8080 无法访问

检查 Tomcat 是否启动：

```powershell
Test-NetConnection 127.0.0.1 -Port 8080
```

也可以查看 Tomcat 日志：

```text
F:\0000 job\0000 软件工程设计\.tools\apache-tomcat-9.0.105\logs
```

### 数据库连接失败

检查 MySQL 是否启动：

```powershell
Test-NetConnection 127.0.0.1 -Port 3306
```

项目数据库配置文件：

```text
项目代码\main\resources\db.properties
```

默认配置：

```properties
jdbc.url=jdbc:mysql://127.0.0.1:3306/bbs?useUnicode=true&characterEncoding=utf8&useSSL=false&useLegacyDatetimeCode=false&serverTimezone=GMT%2B8
jdbc.username=root
jdbc.password=123456
```

