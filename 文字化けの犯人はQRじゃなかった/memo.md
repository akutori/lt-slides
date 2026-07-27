# memo

QR-Barcode-GUI プロジェクトでのスキャナー文字化け調査を LT 化したもの。
元の調査は `QR-Barcode-GUI` リポジトリの開発チャットで実施。

## 元ネタの時系列

1. Inateck BCST-72 で日本語QRが文字化け → UTF-8/SJIS 選択機能を実装（本編アプリに反映済み）
2. UTF-16でのQR生成も試したが、PC側IME（Google IME/Microsoft IME）×スキャナー側解釈設定（UTF-8/Shift-JIS/そのまま）の全パターンで正しく読み取れず
3. スキャン中にNum Lockが点滅する現象に気づき、Keypad Emulation (Alt+Numpad) の仕組みと判明
4. GATTモードを試すため Bluetooth LE Explorer で接続、0xAE00/AE01/AE02 を発見（Read Not Permitted）

## 出典まとめ

- Zebra Keypad Emulation: https://docs.zebra.com/us/en/scanners/multi-plane/mp72pg/usb-interface/keypad-emulation.html
- Alt+Numpad (ConEmu): https://conemu.github.io/en/AltNumpad.html
- Windows コードページ: https://learn.microsoft.com/ja-jp/windows/win32/intl/code-pages
- Windows 文字セット: https://learn.microsoft.com/ja-jp/windows/win32/intl/character-sets
- Inateck Scanner SDK: https://docs.inateck.com/scanner-sdk-en/
- Bluetooth LE Explorer (GitHub): https://github.com/microsoft/BluetoothLEExplorer
- ROHM GATT解説: https://techweb.rohm.co.jp/product/wireless/bluetooth/3469/

## 出典未確認・原因未特定（要チェック・トーク時は断定しすぎない）

- 「キーボードエミュレーションがIMEを経由しない」という説明は、Zebra Keypad Emulation の仕組み記述からの推論であり、この一文自体を直接裏付ける一次情報は未確認
- Shift-JISエンコード時、同一ロケールでもGoogle IMEとMicrosoft IMEで読み取り結果が異なった。原因は特定できていない
- 「QRにはIDだけ入れてDB側で日本語を引く」設計が業界の定石、という主張は経験則ベースで、統計や公式ガイドラインの裏付けは取っていない
- Zebra/Honeywell/Datalogic が老舗としてCOM/SPPモードに対応している、という主張は業界の一般論として書いたが個別の一次情報URLは未確認

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
