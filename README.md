## 概要
zaim にて公開されている [PHPによるサンプルコード](https://dev.zaim.net/home/api/authorize) を Ruby にリライトしたもの。

## 使用技術

使用技術        | 説明
---------------|----------------------
Ruby           | メインで使用したプログラミング言語
HTML           | ブラウザへの表示に使用
webrick        | webサーバ機能を提供
docker         | 使用者毎の環境差異を無くすために使用
docker-compose | コンテナ立ち上げ時の設定を省略するために使用
rubocop        | コード解析ツール

## 挙動確認方法
[Zaim 開発センター](https://dev.zaim.net/home) にて任意のアプリケーションを追加。  
コンシューマ ID 及び コンシューマシークレット を控えておく。

以下コマンドを実行して このリポジトリを clone する。

```
git clone https://github.com/watanavi/zaim_api.git zaim_api
```

cloneしたフォルダに移動する。

```
cd zaim_api
```

`sample_code.rb` 内の コンシューマ ID 、コンシューマシークレット、コールバック先 URL を変更する。

### docker が使える環境の場合

以下コマンドを実行してコンテナを起動、webサーバを立ち上げる。

```
docker-compose up
```

以下 URL をブラウザに張り付けてアクセスする。

```
http://localhost:3000
```

### docker が使えない環境の場合
Ruby および gem のインストール場所によっては webサーバが立ち上がらない場合あり。  
その場合は`webrick.rb`内の CGIInterpreter や gem のインストール先を要確認。

以下コマンドを実行して gem をインストールする。

```
bundle install
```

以下コマンドを実行して webサーバを立ち上げる。

```
ruby ./webrick.rb
```

以下 URL をブラウザに張り付けてアクセスする。

```
http://localhost:3000
```

## 各ファイル説明

ファイル名                             | 説明
--------------------------------------|-----------------------------------------------------
sample_code.rb　                      | ruby でのメイン処理を記載
sample_code.html.erb                  | 結果表示用の ruby 埋め込み html ファイル
webrick.rb                            | webrick でのサーバ立ち上げ用ファイル
.rubocop.yml<br> .rubocop_todo.yml    | rubocop でコード解析したため、rubocop 関連の設定ファイル
Dockerfile<br> docker-compose.yml     | docker で開発環境を整えたため、docker 関連ファイル
Gemfile<br> Gemfile.lock              | Gem 関連ファイル


## シーケンス図
右側にはフローチャート中の対応する処理、サンプルコード中の対応する行数を記載。

![シーケンス図2](https://user-images.githubusercontent.com/64312219/100351690-307c9800-302f-11eb-90e1-bf30db3d7b96.png)


## フローチャート
処理内容にはサンプルコード中の対応する行数を記載。

![フローチャート](https://user-images.githubusercontent.com/64312219/99997337-61c35100-2e00-11eb-8054-053e23530cb5.png)

