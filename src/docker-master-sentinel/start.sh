#!/bin/bash

redis-server /usr/local/etc/redis/redis.conf \
    --cluster-announce-ip $MASTER_ANNOUNCE_IP \
    --cluster-announce-port $MASTER_ANNOUNCE_PORT \
    --replica-announce-ip $MASTER_ANNOUNCE_IP \
    --replica-announce-port $MASTER_ANNOUNCE_PORT \
    --port $MASTER_ANNOUNCE_PORT \
    --bind "0.0.0.0" \
    --masterauth $REDIS_MASTER_PASSWORD \
    --dbfilename $DB_FILENAME \
    --requirepass $REDIS_MASTER_PASSWORD &> /var/log/redis-server.log &

redis-server /usr/local/etc/redis/sentinel.conf \
    --sentinel announce-ip $MASTER_ANNOUNCE_IP \
    --sentinel announce-port $SENTINEL_ANNOUNCE_PORT \
    --port $SENTINEL_ANNOUNCE_PORT \
    --bind "0.0.0.0" \
    --sentinel auth-pass $MASTER_GROUP_NAME $REDIS_MASTER_PASSWORD \
    --sentinel monitor $MASTER_GROUP_NAME $MASTER_ANNOUNCE_IP $MASTER_ANNOUNCE_PORT $REDIS_SENTINEL_QUORUM \
    --sentinel down-after-milliseconds $MASTER_GROUP_NAME $DOWN_AFTER_MILLISECONDS \
    --sentinel parallel-syncs $MASTER_GROUP_NAME 1 \
    --sentinel failover-timeout $MASTER_GROUP_NAME $FAILOVER_TIMEOUT &> /var/log/redis-sentinel.log &

sleep infinity
