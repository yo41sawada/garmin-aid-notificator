# garmin-aid-notificator

Garmin Connect IQ アプリ。ランニング中に補給タイミングを通知します。

## 機能

- 補給間隔をあらかじめ設定（例：30分ごと）
- アクティビティ中、設定した間隔でバイブレーション通知
- 次の補給までの残り時間を画面に表示

## 対応デバイス

- Forerunner 165

## 開発環境

- Connect IQ SDK 9.1.0
- Monkey C

## セットアップ

```bash
source env.sh
```

## ビルド

```bash
monkeyc -f monkey.jungle -o output/aid-notificator.prg -y developer_key
```
