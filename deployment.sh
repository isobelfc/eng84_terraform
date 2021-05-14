#!/bin/bash

sudo echo "export DB_HOST=mongodb://${aws_instance.db_instance.ip}:27017/posts" >> ~/.bashrc
source ~/.bashrc
cd eng84_cicd_jenkins/app
nodejs seeds/seed.js
pm2 kill
pm2 start app.js
