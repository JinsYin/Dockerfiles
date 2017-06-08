#!/bin/sh
# Author: Jins Yin <yrqiang@163.com>

if [ \( "$2" == "namenode" \) -a \( ! -f ${DFS_NAMENODE_NAME_DIR}/current/VERSION \) ] || [ "${NAMENODE_FORMAT_FORCED}" == "true" ]; then
	sed -i "s|HADOOP_TMP_DIR|${HADOOP_TMP_DIR}|g" ${HADOOP_CONF_DIR}/core-site.xml
	${HADOOP_PREFIX}/bin/hdfs namenode -format -D hadoop.tmp.dir=${HADOOP_TMP_DIR} # -D: not working
fi

exec "$@"