# memo

QR-Barcode-GUI プロジェクトでのスキャナー文字化け調査を LT 化したもの。
元の調査は `QR-Barcode-GUI` リポジトリの開発チャットで実施。

## 元ネタの時系列

1. Inateck BCST-72 で日本語QRが文字化け → UTF-8/SJIS 選択機能を実装（本編アプリに反映済み）
2. 好奇心でUTF-16も試した（プロジェクト外のスクラッチスクリプトで検証、コミットはしていない）
3. スキャン中にNum Lockが点滅する現象に気づき、Keypad Emulation (Alt+Numpad) の仕組みと判明
4. GATTモードを試すため Bluetooth LE Explorer で接続、0xAE00/AE01/AE02 を発見
5. Notify購読してもデータが来ない → Inateck公式SDK (GitHub: scanner_lib) のヘッダーで auth() の存在を確認
6. 生GATT探索はここで区切り。bleak 単体では auth() を突破できないことも整理した

## 出典まとめ

- Zebra Keypad Emulation: https://docs.zebra.com/us/en/scanners/multi-plane/mp72pg/usb-interface/keypad-emulation.html
- Alt+Numpad (ConEmu): https://conemu.github.io/en/AltNumpad.html
- Inateck Scanner SDK: https://docs.inateck.com/scanner-sdk-en/
- Inateck scanner_lib (GitHub, auth() 確認元): https://github.com/Inateck-Technology-Inc/scanner_lib
- UnifiedPOS (OMG): https://www.omg.org/retail/unified-pos.htm
- MS POS Barcode Scanner Bluetooth UUIDs (SSI/SPP-SSI): https://learn.microsoft.com/en-us/windows-hardware/drivers/pos/barcode-scanner-bluetooth-service-uuids

## 出典未確認（要チェック・トーク時は断定しすぎない）

- 「キーボードエミュレーションがIMEを経由しない」という説明は、Zebra Keypad Emulation の仕組み記述からの推論であり、この一文自体を直接裏付ける一次情報は未確認
- 「QRにはIDだけ入れてDB側で日本語を引く」設計が業界の定石、という主張は経験則ベースで、統計や公式ガイドラインの裏付けは取っていない

## UTF-16実験の生データ

```
[utf-8]      18 bytes
[utf-16]     14 bytes (BOM付き)
[utf-16-le]  12 bytes (BOMなし)
[utf-16-be]  12 bytes (BOMなし)

UTF-16バイト列を utf-8    としてデコード: 失敗 (UnicodeDecodeError)
UTF-16バイト列を shift_jis としてデコード: 失敗 (UnicodeDecodeError)
UTF-16バイト列を utf-16   としてデコード: 成功 '日本語テスト'
```

テキストは「日本語テスト」（6文字）。
