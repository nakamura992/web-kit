#!/bin/bash

while true
do
    # バックアップ先ディレクトリ
    BACKUP_DIR="/backup"

    # バックアップファイル名（日付を含む）
    BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).sql.gz"

    # バックアップの実行
    mysqldump -h mysql -u root -p$MYSQL_PWD --all-databases | gzip > $BACKUP_FILE

    # 古いバックアップの削除（BACKUP_RETENTION日より古いものを削除）
    find $BACKUP_DIR -name "backup_*.sql.gz" -type f -mtime +$BACKUP_RETENTION -delete

    echo "Backup completed: $BACKUP_FILE"

    # 次のバックアップまで待機（デフォルトは1日）
    sleep ${BACKUP_INTERVAL}
done