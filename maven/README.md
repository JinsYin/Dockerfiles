# Maven 私库

sonatype/nexus3:3.2.1

用户名/密码: admin / admin123

## Deployment

`-Xms1200m -Xmx1200m` 默认值是 `-Xms1200m -Xmx1200m`。默认的用户名和密码是 `admin/admin123`，登录之后可以修改。

```bash
$ docker run -d -p 8081:8081 --name nexus \
 -e INSTALL4J_ADD_VM_PARAMS="-Xms1g -Xmx1g"
 -v maven_data:/nexus-data sonatype/nexus3:3.2.1
```

## Test

```bash
$ curl -u admin:admin123 http://localhost:8081/service/metrics/ping
```
