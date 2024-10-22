FROM node:20.18

ENV TZ=Asia/Tokyo

RUN apt update && \
    apt install -y \
    git \
    zip \
    unzip \
    vim \
    nano \
    make

COPY ./docker/next/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER node

ENTRYPOINT ["/entrypoint.sh"]