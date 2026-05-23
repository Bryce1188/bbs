# BBS

这是一个基于 Spring MVC、MyBatis、Shiro、MySQL 和 Redis 的 Java Web 论坛项目，使用 Maven 构建并部署到 Tomcat。

## 快速开始

详细的软件安装、数据库导入、Redis 配置、Maven 构建和 Tomcat 部署步骤请查看：

[ENVIRONMENT.md](ENVIRONMENT.md)

## 项目结构

```text
.
├── bbs.sql
├── ENVIRONMENT.md
├── README.md
└── 项目代码/
    └── main/
        ├── java/
        ├── resources/
        ├── webapp/
        └── pom.xml
```

## 构建

```bash
cd 项目代码/main
mvn clean package
```

构建完成后，WAR 包会生成在：

```text
项目代码/main/target/bbs.war
```
