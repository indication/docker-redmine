# docker-redmine

# Usage

To run the container, do the following:

~~~ sh
sudo docker-compose build
sudo docker-compose up -d
~~~

You can see services:
 - gitbucket to http://localhost/gitbucket
 - redmine to http://localhost/redmine
 - adminer to http://localhost:8000

And provide samba DC service witch you can access to `\\localhost` with `samba.dom\Administrator`, password is `Password1!`.
If you do not confort with password, you can change it docker-compose.yml and scripts/postgres_create_db_users.sql before run the container.

# Rocket start

1. Change passwords on  docker-compose.yml and scripts/postgres_create_db_users.sql
2. Setup docker via tools/setup_centos_01install_docker.sh
3. Setup docker-compose via tools/setup_centos_02install_compose.sh
4. Setup service via setup_centos_05env.sh
