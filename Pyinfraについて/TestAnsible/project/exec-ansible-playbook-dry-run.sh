#!/bin/bash

# 実行した場合に何が変わるかをシミュレーションするモード
# --check オプションを付与するとドライランが実行される
# --diff オプションを付与すると変更点の差分も表示される
# 変更は加えられないが、何が変更されるかのレポートが出力される
# すべてのモジュールが check mode に完全対応しているわけではない
# 例えば command モジュールや shell モジュールは対応していない
ansible-playbook -i inventory.yml playbook.yml --check --diff