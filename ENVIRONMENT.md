# 环境配置说明

本文档用于说明本项目的本地开发、构建和部署环境。

## 1. 必要软件

请先安装以下软件：

| 软件 | 建议版本 | 用途 |
| --- | --- | --- |
| JDK | 8 | 编译和运行 Java Web 项目 |
| Maven | 3.6+ | 下载依赖、打包 WAR |
| IntelliJ IDEA | 2021.2.2 或更高版本 | 开发和导入 Maven 项目 |
| Apache Tomcat | 9.0.x | 部署运行 `bbs.war` |
| MySQL | 8.0.x | 业务数据库 |
| Redis | 5.0.x | 缓存和会话相关功能 |
| Git | 2.x | 克隆和管理代码 |

说明：`pom.xml` 中配置的 Java 编译版本是 1.8，因此建议使用 JDK 8 构建。项目依赖 `javax.servlet`，适配 Tomcat 9，不建议直接使用 Tomcat 10。

## 2. 获取代码

```bash
git clone <仓库地址>
cd <仓库目录>/项目代码/main
```

## 3. 数据库配置

1. 启动 MySQL。
2. 创建数据库：

```sql
CREATE DATABASE bbs DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```

3. 导入项目根目录下的 SQL 文件：

```bash
mysql -u root -p bbs < ../../bbs.sql
```

4. 根据本机 MySQL 信息修改：

```text
项目代码/main/resources/db.properties
```

默认配置如下：

```properties
jdbc.url=jdbc:mysql://127.0.0.1:3306/bbs?useUnicode=true&characterEncoding=utf8&useSSL=false&useLegacyDatetimeCode=false&serverTimezone=GMT%2B8
jdbc.username=root
jdbc.password=123456
```

如果本机数据库用户名、密码或端口不同，请同步修改。

## 4. Redis 配置

1. 启动 Redis 服务。
2. 根据本机 Redis 信息修改：

```text
项目代码/main/resources/redis.properties
```

默认配置如下：

```properties
redis.host=127.0.0.1
redis.port=6379
redis.password=123456
```

如果 Redis 未设置密码，需要同时调整 Redis 服务配置和项目配置，避免认证失败。

## 5. 构建项目

进入 Maven 项目目录：

```bash
cd 项目代码/main
```

执行打包：

```bash
mvn clean package
```

构建成功后会生成：

```text
项目代码/main/target/bbs.war
```

## 6. Tomcat 部署

1. 将 `项目代码/main/target/bbs.war` 复制到 Tomcat 的 `webapps` 目录。
2. 启动 Tomcat：

```bash
# Windows
%CATALINA_HOME%\bin\startup.bat

# macOS / Linux
$CATALINA_HOME/bin/startup.sh
```

3. 浏览器访问：

```text
http://localhost:8080/bbs
```

## 7. IDEA 导入方式

1. 使用 IntelliJ IDEA 打开 `项目代码/main/pom.xml`。
2. 等待 Maven 自动下载依赖。
3. 配置本地 JDK 为 JDK 8。
4. 配置 Tomcat 9，本地部署 artifact 选择 `bbs:war exploded` 或打包后的 `bbs.war`。
5. 确认 MySQL 和 Redis 已启动，再运行 Tomcat。

## 8. 常见问题

### Maven 依赖下载失败

检查网络和 Maven 镜像源配置。国内网络环境可在 Maven `settings.xml` 中配置阿里云等镜像源。

### 数据库连接失败

检查 `db.properties` 中的地址、端口、数据库名、用户名和密码，并确认已导入 `bbs.sql`。

### Redis 连接失败

检查 Redis 是否已启动，端口是否为 `6379`，密码是否与 `redis.properties` 一致。

### Tomcat 启动后 404

确认 WAR 文件名为 `bbs.war`，访问地址应为 `http://localhost:8080/bbs`。
