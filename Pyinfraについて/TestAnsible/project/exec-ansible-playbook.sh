#!/bin/bash

# verboseモードでAnsible Playbookを実行
# -vvv オプションを付与すると詳細なログが出力される
# -vv オプションを増やすごとに冗長度が上がる（最大 -vvvv）
ansible-playbook -i inventory.yml playbook.yml -vvvv