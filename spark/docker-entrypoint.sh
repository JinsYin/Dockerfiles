#!/bin/sh
# Author: Jins Yin <yrqiang@163.com>

case "$1" in
	"master"|"start-master")
		shift
		exec ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.master.Master "$@"
	;;
	"worker"|"start-worker")
		shift
		exec ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.worker.Worker "$@"
	;;
	*)
		exec "$@"
	;;
esac