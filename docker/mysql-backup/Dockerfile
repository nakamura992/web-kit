FROM mysql:8.4

COPY ./docker/mysql-backup/backup.sh /backup.sh
RUN chmod +x /backup.sh

CMD ["/backup.sh"]