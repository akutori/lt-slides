---
marp: true
paginate: true
---

# ZipArchive で解凍したら文字化けした

---

# ZipArchive とは

`ZipArchive`はPHPのクラスで、zipファイルを操作するためのもの

5.2.0から利用可能

https://www.php.net/manual/ja/class.ziparchive.php

同名のクラス他の言語でも確認されているが､名前が一緒なだけで特に関連はない模様

```php
$zip = new ZipArchive();
if ($zip->open('example.zip') === TRUE) { // ZIP開けなくても例外出ない
    $zip->extractTo('/dest/');
    $zip->close();
} else {
    echo "ZIP を開けませんでした";
}
```

---

# 何があったのか

---

`ZipArchive`使ってwindowsで作成されたzipファイルを解凍(今は展開っていうか？)したときに**日本語のファイル名が文字化けした**

例
```
ホゲホゲ.txt.zip
↓
πâ¢πé▒πéÖπâ¢πé▒πéÖ.txt
```

中身は文字化けせず､ファイル名のみ

---

原因

Windowsの機能でzipにしたファイルはCP932でエンコードされているため、PHPの`ZipArchive`が**文字エンコード未指定の場合UTF-8で解釈**してしまい文字化けが発生する


MAC

```bash
unzip -Z1 ホゲホゲ.txt.zip
ホゲホゲ.txt
__MACOSX/._ホゲホゲ.txt
```

Windows

```bash
unzip -Z1 ふがふが.txt.zip
уБ╡уБМуБ╡уБМ.txt
```

---

また､Windowsは*7zip*,*Lhaplus*,などのソフトウェアでzipファイル作成した場合､文字コードがそれぞれ異なるためそれも対応する必要があった

| #   | 圧縮手段              | 文字エンコーディング |
| --- | ----------------- | ------------------- |
| 1   | `windows標準のzip圧縮` | `CP932`             |
| 2   | `Lhaplus`         | `CP932`             |
| 3   | `7zip`            | `UTF-8`             |


---

# 解決方法

---

```php
$zip = new ZipArchive();
if ($zip->open('example.zip') !== TRUE) { exit('failed'); }

for ($i = 0; $i < $zip->numFiles; $i++) {
    $raw = $zip->getNameIndex($i, ZipArchive::FL_ENC_RAW);

	if(mb_check_encoding($$raw, 'CP932') && !mb_check_encoding($$raw, 'UTF-8')){
		$raw = mb_convert_encoding($$raw, 'UTF-8', 'CP932');
	}

    $zip->renameIndex($i, mb_convert_encoding($raw, 'UTF-8', 'CP932'));
}

$zip->close();
$zip->open('example.zip');
$zip->extractTo('/dest/');
$zip->close();
```