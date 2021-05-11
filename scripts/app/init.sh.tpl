#!/bin/bash

cd home/ubuntu/eng84_devops_cicd/app
npm install
pm2 start app.js
