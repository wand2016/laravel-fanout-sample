# ジョブワーカー動かす #

`app_a`, `app_b`それぞれで

```php
php artisan queue:work
```


# pub #

http://localhost:10080/publish にアクセス


# sub #

`app_a`, `app_b`それぞれにログが書き出されれば成功の予定
