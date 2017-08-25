#!/bin/sh
# Author: Jins Yin <jinsyin@gmail.com>

rm -f ${HADOOP_HOME}/*.txt
rm -f ${HADOOP_HOME}/bin/*.cmd
rm -f ${HADOOP_HOME}/sbin/*.cmd
rm -f ${HADOOP_HOME}/libexec/*.cmd
rm -rf ${HADOOP_HOME}/share/doc
rm -rf ${HADOOP_HOME}/share/hadoop/kms
rm -rf ${HADOOP_HOME}/share/hadoop/tools
rm -rf ${HADOOP_HOME}/share/hadoop/common/jdiff
rm -rf $(find ${HADOOP_HOME}/share/hadoop -name "*test*.jar")
rm -rf $(find ${HADOOP_HOME}/share/hadoop -name "*example*.jar")