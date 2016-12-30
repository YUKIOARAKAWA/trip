## rubyバージョン
ruby 2.3.0

## railsバージョン
Rails 4.2.6

## データベース
PostgreSQL 9.5.3


## 環境構築
```git clone https://github.com/YUKIOARAKAWA/tripplan.git```

``` bundle install --path vendor/bundler ```

database.ymlを自分のローカル環境の合わせて修正

``` bundle exec rake db:create ```

``` bundle exec rake db:migrate ```

``` bundle exec rake db:seed ```


マスタデータ作成
bin/rake db:seed

## テスト
Rspec + factory_girl + database_cleaner

### 注意
プルリク前に
``` bundle exec rspec ```
を実行しテスト結果がgreenであることを確認する

## 現在heorkuで仮公開
https://triplaning.herokuapp.com/
