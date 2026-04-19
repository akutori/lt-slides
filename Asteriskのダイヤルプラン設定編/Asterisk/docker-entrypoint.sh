#!/bin/bash
set -e

CONFIG_DIR="/etc/asterisk"
DIST_DIR="/etc/asterisk.dist"

echo "Checking configuration in $CONFIG_DIR ..."
ls -la $CONFIG_DIR

# asterisk.conf が無ければコピー実行
if [ ! -f "$CONFIG_DIR/asterisk.conf" ]; then
    echo "Config file not found. Copying defaults from $DIST_DIR ..."
    
    # 念のためディレクトリが存在するか確認し、なければ作る
    if [ -d "$DIST_DIR" ]; then
        cp -r $DIST_DIR/* $CONFIG_DIR/
        echo "Copy finished."
        ls -la $CONFIG_DIR
    else
        echo "ERROR: Backup directory $DIST_DIR does not exist!"
    fi
else
    echo "Config file exists. Skipping copy."
fi

echo "Starting Asterisk..."
exec "$@"