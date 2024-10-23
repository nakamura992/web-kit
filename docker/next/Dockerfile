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

WORKDIR /app

COPY ./next/package*.json ./
RUN npm install
