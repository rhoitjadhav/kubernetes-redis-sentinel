FROM redis:6.2.7
COPY redis-6.2.7.conf /usr/local/etc/redis/redis.conf
COPY sentinel-6.2.7.conf /usr/local/etc/redis/sentinel.conf
COPY start.sh /usr/bin/start.sh
RUN apt update && apt install -y procps vim
CMD /usr/bin/start.sh
