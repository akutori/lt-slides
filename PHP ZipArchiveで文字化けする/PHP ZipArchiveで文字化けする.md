---
marp: true
paginate: true
---

# ZipArchive で解凍したら文字化けした

<!-- 今日は PHP の ZipArchive を使ったときに日本語ファイル名が文字化けした話をします。 -->

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

<!-- まず ZipArchive の説明を簡単に。PHP 5.2 から使えるクラスで、zip ファイルを開いたり展開したりできます。
コードはこんな感じで、open して extractTo するだけです。
ただし注意点として、open が失敗しても例外は投げてくれないので、戻り値のチェックが必要です。
余談ですが、他の言語にも同名のクラスがあります。名前が一緒なだけで特に関係はないみたいです。 -->

---

# 何があったのか

<!-- では実際に何が起きたのかを説明します。 -->

---

`ZipArchive`使ってwindowsで作成されたzipファイルを解凍(今は展開っていうか？)したときに**日本語のファイル名が文字化けした**

例
```
ホゲホゲ.txt.zip
↓
πâ¢πé▒πéÖπâ¢πé▒πéÖ.txt
```

中身は文字化けせず､ファイル名のみ

<!-- Windows で作成された zip ファイルを ZipArchive で展開したところ、日本語のファイル名が文字化けしました。
中身のテキストは問題なく、ファイル名だけが化けるという状況です。
こんな感じで『ホゲホゲ.txt』が完全に読めない文字列になってしまいます。 -->

---

原因

Windowsの機能でzipにしたファイルはCP932でエンコードされているため、PHPの`ZipArchive`が**文字エンコード未指定の場合UTF-8で解釈**してしまい文字化けが発生する


MAC

```bash
unzip -Z1 ホゲホゲ.txt.zip
ホゲホゲ.txt
__MACOSX/._ホゲホゲ.txt
```

Windows

```bash
unzip -Z1 ふがふが.txt.zip
уБ╡уБМуБ╡уБМ.txt
```

<!-- 原因はエンコーディングのズレです。
Windows の標準 zip 機能で作成したファイルはファイル名が CP932 でエンコードされています。
一方 PHP の ZipArchive はエンコード指定がないと UTF-8 として解釈するため、化けてしまいます。
unzip コマンドで確認するとよくわかって、Mac で作った zip はそのまま読めますが、Windows で作った zip はすでにターミナル上でも化けています。 -->

---

また､Windowsは*7zip*,*Lhaplus*,などのソフトウェアでzipファイル作成した場合､文字コードがそれぞれ異なるためそれも対応する必要があった

| #   | 圧縮手段              | 文字エンコーディング |
| --- | ----------------- | ------------------- |
| 1   | `windows標準のzip圧縮` | `CP932`             |
| 2   | `Lhaplus`         | `CP932`             |
| 3   | `7zip`            | `UTF-8`             |

<!-- さらにやっかいなことに、Windows でも zip を作るソフトウェアによってエンコードが変わります。
Windows 標準と Lhaplus は CP932、7zip は UTF-8 です。
なので単純に『CP932 に変換すればいい』ではなく、どのエンコードで作られた zip かを判定する必要があります。 -->

---

# 解決方法

<!-- ということで解決方法です。 -->

---

```php
$zip = new ZipArchive();
if ($zip->open('example.zip') !== TRUE) { exit('failed'); }

for ($i = 0; $i < $zip->numFiles; $i++) {
    $raw = $zip->getNameIndex($i, ZipArchive::FL_ENC_RAW);

    if (mb_check_encoding($raw, 'CP932') && !mb_check_encoding($raw, 'UTF-8')) {
        $zip->renameIndex($i, mb_convert_encoding($raw, 'UTF-8', 'CP932'));
    }
}

$zip->close();
$zip->open('example.zip');
$zip->extractTo('/dest/');
$zip->close();
```

<!-- ポイントは FL_ENC_RAW でファイル名をそのまま取得することです。
CP932 かつ UTF-8 でない場合だけ変換してリネームします。
UTF-8 ファイル名（7zip製）はそのままスキップされるので二重変換による破壊が起きません。
全ファイルを処理し終わったら zip を閉じて再度開き、extractTo で展開します。
これで Windows 標準・Lhaplus・7zip のどれで作った zip でも正しく展開できます。 -->

---

# まとめ

- Windows 標準・Lhaplus は **CP932**、7zip は **UTF-8** でファイル名をエンコードする
- `ZipArchive` はエンコード未指定だと **UTF-8 として解釈**するため日本語ファイル名が化ける
- `FL_ENC_RAW` を使うと**生バイトでファイル名を取得**できる
- `mb_check_encoding` でエンコードを判定し、CP932 なら **UTF-8 に変換**してからリネーム・展開する

<!-- 整理すると4点です。
zip のエンコードはソフトによって変わる、ZipArchive はデフォルト UTF-8 解釈、FL_ENC_RAW で生バイト取得、mb_check_encoding で判定して変換、この流れを押さえておけば同じ問題は回避できます。以上です、ありがとうございました。 -->
