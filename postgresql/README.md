# PostgresSQL

## Dockerfile

> https://github.com/docker-library/postgres/blob/master/9.4/alpine/Dockerfile

## Deployment

默认 postgres 用户和数据库会被创建, 端口为 5432.
```bash
$ docker run -it --name postgresql -p 5432:5432 \
-e POSTGRES_USER=root \
-e POSTGRES_PASSWORD=root123456 \
-v pg_data:/var/lib/postgresql/data \
-d postgres:9.4.12-alpine
```

连接服务端
```bash
$ psql -h 127.0.0.1 -U postgres -p 5432
```
