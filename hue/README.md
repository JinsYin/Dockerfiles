# Hue

## Dockerfile

> https://github.com/cloudera/hue/blob/master/tools/docker/hue-base/Dockerfile


## Building

```bash
$ docker build -f Dockerfile -t gethue/hue:latest
```

## Running

```bash
$ docker run -itd -p 8888:8888 --name hue gethue/hue:latest
```