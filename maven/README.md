# Maven ˽��

sonatype/nexus3:3.2.1

�û���/����: admin / admin123

## Deployment

`-Xms1200m -Xmx1200m` Ĭ��ֵ�� `-Xms1200m -Xmx1200m`��Ĭ�ϵ��û����������� `admin/admin123`����¼֮������޸ġ�

```bash
$ docker run -d -p 8081:8081 --name nexus \
 -e INSTALL4J_ADD_VM_PARAMS="-Xms1g -Xmx1g"
 -v maven_data:/nexus-data sonatype/nexus3:3.2.1
```

## Test

```bash
$ curl -u admin:admin123 http://localhost:8081/service/metrics/ping
```
