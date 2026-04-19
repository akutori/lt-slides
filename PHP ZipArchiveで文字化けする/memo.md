# 日本語ファイル名でテキスト作成
"テストです" | Out-File -Encoding utf8 "ふがふが.txt"

# Windows標準のzip圧縮でZIP作成（CP932になる）
Compress-Archive -Path "ふがふが.txt" -DestinationPath "ふがふが.txt.zip"


```bash
unzip -Z1 ホゲホゲ.txt.zip
ホゲホゲ.txt
__MACOSX/._ホゲホゲ.txt
```


```bash
unzip -Z1 ふがふが.txt.zip
уБ╡уБМуБ╡уБМ.txt
```