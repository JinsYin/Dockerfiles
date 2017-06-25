#!/bin/sh
# Author: Jins Yin <jinsyin@gmail.com>

rm -f ${SPARK_HOME}/NOTICE
rm -f ${SPARK_HOME}/README.md
rm -f ${SPARK_HOME}/bin/*.cmd
rm -rf ${SPARK_HOME}/yarn
rm -rf ${SPARK_HOME}/data
rm -rf ${SPARK_HOME}/examples
rm -rf ${SPARK_HOME}/R/lib/sparkr.zip
rm -rf ${SPARK_HOME}/python/docs
rm -rf ${SPARK_HOME}/python/test_support
rm -rf $(find ${SPARK_HOME}/jars -name "*test*.jar")
rm -rf $(find ${SPARK_HOME}/jars -name "*example*.jar")