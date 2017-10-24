CREATE USER redmine PASSWORD 'link_redmine';
CREATE DATABASE redmine;
GRANT ALL PRIVILEGES ON DATABASE redmine TO redmine;
CREATE USER gitbucket PASSWORD 'link_gitbucket';
CREATE DATABASE gitbucket;
GRANT ALL PRIVILEGES ON DATABASE gitbucket TO gitbucket;
