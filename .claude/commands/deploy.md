アプリをビルドしてシミュレーターに転送する。

1. 以下のコマンドで SDK の PATH を設定する:
   ```
   export PATH="$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/$(ls "$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/" | sort -V | tail -1)/bin:$PATH"
   ```

2. `mkdir -p output` で出力ディレクトリを作成する。

3. 以下のコマンドでビルドする:
   ```
   monkeyc -f monkey.jungle -o output/aid-notificator.prg -d fr165 -y credentials/developer_key.der
   ```

4. ビルドが成功したら、以下のコマンドでシミュレーターに転送する:
   ```
   monkeydo output/aid-notificator.prg fr165
   ```

5. 結果を報告する。
