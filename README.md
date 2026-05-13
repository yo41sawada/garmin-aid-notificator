# garmin-aid-notificator

Garmin Connect IQ アプリ。ランニング中に補給タイミングを通知します。

## 機能

- 補給間隔をあらかじめ設定（例：30分ごと）
- アクティビティ中、設定した間隔でバイブレーション通知
- 次の補給までの残り時間を画面に表示

## 対応デバイス

- Forerunner 165

## 前提条件

- **Java（Temurin）** — Connect IQ SDK の実行に必要
  - [Adoptium](https://adoptium.net/) から macOS 向け JDK をインストール
- **Connect IQ SDK Manager** — SDK とデバイス定義のインストールに使用
  - [Garmin Developer](https://developer.garmin.com/connect-iq/sdk/) からインストール
  - SDK Manager を起動し、SDK 最新版と `Forerunner 165` デバイスをインストール

## 開発環境

- Connect IQ SDK 9.1.0
- Monkey C

## セットアップ

SDK のパスを通します：

```bash
export PATH="$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/$(ls ~/Library/Application\ Support/Garmin/ConnectIQ/Sdks/ | sort -V | tail -1)/bin:$PATH"
```

## ビルド

```bash
monkeyc -f monkey.jungle -o output/aid-notificator.prg -y credentials/developer_key.der
```
