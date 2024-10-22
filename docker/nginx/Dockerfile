FROM nginx:1.27

ENV TZ=Asia/Tokyo

RUN apt update && \
    apt install -y \
    inotify-tools \
    nano \
    vim

COPY ./docker/nginx/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]