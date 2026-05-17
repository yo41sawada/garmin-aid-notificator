# garmin-aid-notificator

Garmin Connect IQ アプリ。ランニング中に補給タイミングを通知します。

## 機能

- 次の補給ポイントまでの残り距離をリアルタイム表示（小数点2桁）
- 補給ポイント通過時にトーン・バイブレーション・全画面アラートで通知
- 補給ポイントの距離はソースコード内の `AID_STATIONS` に km リストで自由に指定
- アクティビティ開始前は "AID Ready"、全ポイント通過後は "Keep going!" を表示
- ブラック・ホワイト背景に対応（デバイス設定に追従）

## 留意事項

| 項目 | 内容 |
|------|------|
| 補給ポイントの数 | 特に上限なし |
| GPS 未取得時 | 直前の値を表示し続ける |

## 対応デバイス

- Forerunner 165

## プロジェクト構成

```
source/
├── AidNotificatorApp.mc    # アプリエントリーポイント
├── AidNotificatorView.mc   # データフィールドの表示・ロジック
└── AidAlertView.mc         # 補給通知の全画面アラート
resources/
├── drawables/
│   └── launcher_icon.png   # ランチャーアイコン（70x70）
├── store/
│   └── store_icon.png      # Connect IQ ストア申請用アイコン（512x512）
└── resources.xml           # 文字列・画像リソース
credentials/                # 開発者キー（git 管理外）
├── developer_key.pem
└── developer_key.der
manifest.xml                # アプリ設定（種別・対応デバイス）
monkey.jungle               # ビルド設定
```

## 開発環境

| ツール | バージョン | 用途 |
|--------|-----------|------|
| [Java（Temurin）](https://adoptium.net/) | 26.0.1 | Connect IQ SDK の実行 |
| [Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/) | 9.1.0 | ビルド・シミュレーター |
| [OpenMTP](https://openmtp.ganeshrvel.com/) | 3.2.25 | macOS での実機転送（MTP） |
| [Claude Code](https://claude.ai/code) | 最新版 | AI 支援開発 |

Connect IQ SDK は SDK Manager からインストールする。SDK Manager 起動後、SDK 9.1.0 と `Forerunner 165` デバイスをインストールする。

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

**3. Claude Code の設定をする**

このプロジェクトは Claude Code での開発を想定しており、`.claude/settings.json` にプロジェクト共通の権限設定が含まれています。個人環境に依存する設定は `.claude/settings.local.json`（git 管理外）に記述します。

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

**4. 全画面アラートを有効にする**

シミュレーターのデフォルトでは DataFieldAlert が無効になっています。**Settings → Data Fields → Enable Alert** にチェックを入れてください。

**5. トーン・バイブレーションをテストする**

**Settings → Tones / Vibrate** のチェック状態を切り替えることで、デバイス設定のオン/オフをシミュレートできます。

## 実機へのインストール

macOS では Finder が MTP デバイスを認識しないため、[OpenMTP](https://openmtp.ganeshrvel.com/) を使用する。

**1. OpenMTP をインストールする**

[openmtp.ganeshrvel.com](https://openmtp.ganeshrvel.com/) からダウンロードしてインストールする。

**2. デバイスを USB 接続し、MTP モードに切り替える**

FR165 で **設定 → システム → USB モード → Garmin（MTP）** を選択する。

**3. `.prg` ファイルをビルドする**

```bash
mkdir -p output
monkeyc -f monkey.jungle -o output/aid-notificator.prg -d fr165 -y credentials/developer_key.der
```

**4. OpenMTP でファイルを転送する**

1. OpenMTP を起動する
2. 左パネル（Mac 側）で `output/` ディレクトリを開く
3. 右パネル（デバイス側）で `GARMIN/Apps/` を開く（表示されない場合はリフレッシュボタンをクリック）
4. `aid-notificator.prg` を右パネルの `GARMIN/Apps/` にコピーする

**5. デバイスを切断してアプリを追加する**

ケーブルを抜いた後、FR165 でランニングアクティビティのデータフィールドスロットに「Aid Notificator」を追加する。
