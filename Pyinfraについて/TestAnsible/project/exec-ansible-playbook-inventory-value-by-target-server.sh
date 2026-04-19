#!/bin/bash

# 指定したターゲットサーバーに対応するインベントリ情報を表示する
# これは ホスト target-serverに対応するインベントリ情報を取得する
ansible-inventory -i inventory.yml --host target-server
