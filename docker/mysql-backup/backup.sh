#!/bin/sh

wait_for_mysql() {
    echo "Waiting for MySQL to be ready..."
    while ! mysqladmin ping -h mysql -u root -p$MYSQL_PWD --silent; do
        sleep 3
    done
    echo "MySQL is ready"
}

while true
do
    wait_for_mysql

    # バックアップ先ディレクトリ
    BACKUP_DIR="/backup"

    # バックアップファイル名（日付を含む）
    BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).sql"

    # バックアップの実行
    mysqldump -h mysql -u root -p$MYSQL_PWD --all-databases > $BACKUP_FILE

    # 古いバックアップの削除（BACKUP_RETENTION日より古いものを削除）
    find $BACKUP_DIR -name "backup_*.sql.gz" -type f -mtime +$BACKUP_RETENTION -delete

    echo "Backup completed: $BACKUP_FILE"

    # 次のバックアップまで待機（デフォルトは1日）
    sleep ${BACKUP_INTERVAL}
done
