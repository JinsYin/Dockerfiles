#!/bin/bash
# Author: Jins Yin <jinsyin@gmail.com>

: ${NAMENODE_FORMAT_FORCED:=false}
: ${DFS_NAMENODE_NAME_DIR:="/tmp/hadoop-root/dfs/name"}

for x in $@
do
  case $x in
    "-Dhadoop.tmp.dir="*|"hadoop.tmp.dir="*) 
      IFS='=' read -ra PROP <<< "$x";
      DFS_NAMENODE_NAME_DIR=${PROP[1]}/dfs/name;
      continue;
    ;;
    "-Ddfs.namenode.name.dir="*|"dfs.namenode.name.dir="*)
      IFS='=' read -ra PROP <<< "$x";
      DFS_NAMENODE_NAME_DIR=${PROP[1]};
      break;
    ;;
  esac
done

# Format namenode
if [ "$2" == "namenode" ] && [ \( ! -f ${DFS_NAMENODE_NAME_DIR}/current/VERSION \) -o \(  "${NAMENODE_FORMAT_FORCED}" == "true" \) ]; then
  echo -e "Y\n\n\n" | ${HADOOP_HOME}/bin/hdfs namenode -Ddfs.namenode.name.dir=${DFS_NAMENODE_NAME_DIR} -format;
fi

exec "$@"
