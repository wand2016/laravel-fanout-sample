#!/bin/sh

cp env_a docker-php-a/.env
cp env_b docker-php-b/.env

sh -c 'cd docker-php-a && docker-compose up -d'
sh -c 'cd docker-php-b && docker-compose up -d'

sudo chmod -R 777 docker-php-a/log
sudo chmod -R 777 app_a/storage/
sudo chmod -R 777 docker-php-b/log
sudo chmod -R 777 app_b/storage/
