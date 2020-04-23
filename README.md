# インフラ構築 #

./terraform-practice/env_sample を .envにコピーし、`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`と作業ディレクトリを書き込む

```
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_DEFAULT_REGION=ap-northeast-1

TERRAFORM_WORKDIR=../infra/
```

```sh
./tf init
./tf apply # yes
```

- 出力結果にSNSのARNとSQSのid (URL)が出力されるので控える (後で使用する)

```
...

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

sns_topic_arn = arn:aws:sns:ap-northeast-1:xxxxxxxxxxxx:fanout-example
sqs_url_a = https://sqs.ap-northeast-1.amazonaws.com/xxxxxxxxxxxx/fanout-example-application-a
sqs_url_b = https://sqs.ap-northeast-1.amazonaws.com/xxxxxxxxxxxx/fanout-example-application-b
```


## インフラ解体 ##

```sh
./tf destroy # yes
```


# アプリケーション環境構築 #

```sh
./init.sh
```

- でたぶんいけるはず
- linuxだと`sudo chown`とか`sudo chmod 777`とかしないとstorageが書き込めなくて死ぬかも


# アプリケーション準備 #

- `app_a`, `app_b`それぞれで
  - composer install
  - .envにSNSのARN, SQSのURLを書き込む


# ジョブワーカー動かす #

- `app_a`, `app_b`それぞれで

```php
php artisan queue:work
```


# pub #

- http://localhost:10080/publish にアクセス


# sub #

- `app_a`, `app_b`それぞれのログが書き出されれば成功

```
[2020-04-23 14:16:55] local.INFO: --app a--  
[2020-04-23 14:16:55] local.INFO: fanout example ["hola"] 
```

```
[2020-04-23 14:16:55] local.INFO: --app b--  
[2020-04-23 14:16:55] local.INFO: fanout example ["hola"] 
```
