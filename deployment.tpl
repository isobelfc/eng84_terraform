#!/bin/bash
cd home/ubuntu/eng84_cicd_jenkins/app
# sudo echo "export DB_HOST=mongodb://${db_private_ip}:27017/posts" >> ~/.bashrc
# echo "export DB_HOST=mongodb://${db_private_ip}:27017/posts" | sudo tee -a ~/.bashrc
# sudo sh -c 'echo "export DB_HOST=mongodb://${db_private_ip}:27017/posts" >> ~/.bashrc'
# source ~/.bashrc
npm install
pm2 kill
nodejs seeds/seed.js
pm2 start app.js


# #!/bin/sh
# sudo sh -c 'echo "export DB_HOST=mongodb://10.0.1.139:27017/posts" >> ~/.bashrc'
# source ~/.bashrc
