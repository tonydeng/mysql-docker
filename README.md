# MySQL(MariaDB) Alpine Docker
[![Docker Stars](https://img.shields.io/docker/stars/wolfdeng/mysql.svg)](https://hub.docker.com/r/wolfdeng/mysql/)
[![Docker Pulls](https://img.shields.io/docker/pulls/wolfdeng/mysql.svg)](https://hub.docker.com/r/wolfdeng/mysql/)
[![Image Size](https://img.shields.io/imagelayers/image-size/wolfdeng/mysql/latest.svg)](https://imagelayers.io/?images=wolfdeng/mysql:latest)
[![Image Layers](https://img.shields.io/imagelayers/layers/wolfdeng/mysql/latest.svg)](https://imagelayers.io/?images=wolfdeng/mysql:latest)

基于Alpine系统的Docker镜像，用于提供MySQL(MariaDB)服务。

## 目录

```
/mysql/run      # MySQL运行PID文件，位于子目录mysql中
/mysql/data     # MySQL数据文件，位于子目录mysql中
/mysql/conf     # Mysql配置文件，位于子目录mysql中
```

## 参数

```
MYSQL_DATABASE  # 启动时创建新的数据库
MYSQL_USER      # 新数据库的管理员账号
MYSQL_PASSWORD  # 新数据库的管理员密码
MYSQL_ROOT_PASSWORD # root用户密码，如果不提供系统将随机生成
```

## 创建Docker容器

```
docker run --name mysql \
    -p 3306:3306 \
    -v /opt/mysql/data:/mysql/data \
    -e MYSQL_DATABASE=my_data_base \
    -e MYSQL_USER=user \
    -e MYSQL_PASSWORD=mysql \
    -e MYSQL_ROOT_PASSWORD=Passw0rd \
    -it -d wolfdeng/mysql
```
