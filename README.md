# garmin-aid-notificator

Garmin Connect IQ アプリ。ランニング中に補給タイミングを通知します。

## 機能

- 補給間隔をあらかじめ設定（例：30分ごと）
- アクティビティ中、設定した間隔でバイブレーション通知
- 次の補給までの残り時間を画面に表示

## 対応デバイス

- Forerunner 165

## プロジェクト構成

```
source/
├── AidNotificatorApp.mc    # アプリエントリーポイント
└── AidNotificatorView.mc   # データフィールドの表示・ロジック
resources/
├── drawables/
│   └── launcher_icon.png
└── resources.xml           # 文字列・画像リソース
credentials/                # 開発者キー（git 管理外）
├── developer_key.pem
└── developer_key.der
manifest.xml                # アプリ設定（種別・対応デバイス）
monkey.jungle               # ビルド設定
```

## 前提条件

- **Java（Temurin）** — Connect IQ SDK の実行に必要
  - [Adoptium](https://adoptium.net/) から macOS 向け JDK をインストール
- **Connect IQ SDK Manager** — SDK とデバイス定義のインストールに使用
  - [Garmin Developer](https://developer.garmin.com/connect-iq/sdk/) からインストール
  - SDK Manager を起動し、SDK 最新版と `Forerunner 165` デバイスをインストール

## 開発環境

- Connect IQ SDK 9.1.0
- Monkey C

## Claude Code を使った開発

このプロジェクトは Claude Code での開発を想定しており、`.claude/settings.json` にプロジェクト共通の権限設定が含まれています。

個人環境に依存する設定は `.claude/settings.local.json`（git 管理外）に記述します。

## セットアップ

**1. SDK の bin ディレクトリを PATH に追加する**

```
$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/<sdk-version>/bin
```

`<sdk-version>` は SDK Manager でインストールしたバージョン名（例: `connectiq-sdk-mac-9.1.0-2026-03-09-6a872a80b`）。

**2. 開発者キーを生成する**

```bash
mkdir -p credentials
openssl genrsa -out credentials/developer_key.pem 4096
openssl pkcs8 -topk8 -inform PEM -outform DER -in credentials/developer_key.pem -out credentials/developer_key.der -nocrypt
```

## ビルド

```bash
mkdir -p output
monkeyc -f monkey.jungle -o output/aid-notificator.prg -d fr165 -y credentials/developer_key.der
```

## シミュレーターでのテスト

**1. シミュレーターを起動する**

```bash
connectiq &
```

**2. アプリをシミュレーターに転送する**

```bash
monkeydo output/aid-notificator.prg fr165
```

シミュレーター上でデータフィールドが表示されます。表示レイアウトは **Data Fields → Layout** から変更できます。

**3. アクティビティデータをシミュレートする**

距離などのアクティビティデータを動かすには、**Simulation → Activity Data** を開き、**Start** ボタンをクリックします。Data Source が **Data Simulation** になっていることを確認してください。
