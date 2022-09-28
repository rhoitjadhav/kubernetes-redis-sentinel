#!/bin/bash

redis-server /usr/local/etc/redis/redis.conf \
    --replica-announce-ip $REPLICA_ANNOUNCE_IP \
    --replica-announce-port $REPLICA_ANNOUNCE_PORT \
    --bind "0.0.0.0" \
    --port $REPLICA_ANNOUNCE_PORT \
    --masterauth $REDIS_MASTER_PASSWORD \
    --dbfilename $DB_FILENAME \
    --replicaof $REDIS_MASTER_SERVICE_HOST $REDIS_MASTER_SERVICE_PORT \
    --requirepass $REDIS_MASTER_PASSWORD &> /var/log/redis-server.log &

redis-server /usr/local/etc/redis/sentinel.conf \
    --sentinel announce-ip $REPLICA_ANNOUNCE_IP \
    --sentinel announce-port $SENTINEL_ANNOUNCE_PORT \
    --port $SENTINEL_ANNOUNCE_PORT \
    --bind "0.0.0.0" \
    --sentinel auth-pass $MASTER_GROUP_NAME $REDIS_MASTER_PASSWORD \
    --sentinel monitor $MASTER_GROUP_NAME $REDIS_MASTER_SERVICE_HOST $REDIS_MASTER_SERVICE_PORT $REDIS_SENTINEL_QUORUM \
    --sentinel down-after-milliseconds $MASTER_GROUP_NAME $DOWN_AFTER_MILLISECONDS \
    --sentinel parallel-syncs $MASTER_GROUP_NAME 1 \
    --sentinel failover-timeout $MASTER_GROUP_NAME $FAILOVER_TIMEOUT &> /var/log/redis-sentinel.log &

sleep infinity
