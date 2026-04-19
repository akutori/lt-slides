import sys
import os
from project.tasks.common import main as common
from project.tasks.asterisk import main as asterisk
from project.tasks.postgres import main as postgres

# このスクリプトが含まれるディレクトリをPythonのパスに追加します。
# これにより、`tasks.asterisk` のような相対インポートが機能するようになります。
# sys.path.insert(0, os.path.dirname(__file__))

common.deploy()
asterisk.deploy()
postgres.deploy()