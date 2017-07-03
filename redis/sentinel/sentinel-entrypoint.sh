#!/bin/sh

# Modify configuration
sed -i "s/\$REDIS_MASTER_PORT/$REDIS_MASTER_PORT/" /etc/redis/sentinel.conf
sed -i "s/\$REDIS_MASTER/$REDIS_MASTER/" /etc/redis/sentinel.conf
sed -i "s/\$SENTINEL_NAME/$SENTINEL_NAME/" /etc/redis/sentinel.conf
sed -i "s/\$SENTINEL_PORT/$SENTINEL_PORT/" /etc/redis/sentinel.conf
sed -i "s/\$SENTINEL_QUORUM/$SENTINEL_QUORUM/" /etc/redis/sentinel.conf
sed -i "s/\$SENTINEL_DOWN_AFTER/$SENTINEL_DOWN_AFTER/" /etc/redis/sentinel.conf
sed -i "s/\$SENTINEL_FAILOVER/$SENTINEL_FAILOVER/" /etc/redis/sentinel.conf

# Start redis sentinel (or: redis-sentinel /etc/redis/sentinel.conf)
exec docker-entrypoint.sh redis-server /etc/redis/sentinel.conf --sentinel