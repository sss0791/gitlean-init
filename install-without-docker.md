# CENTOS/RedHat

## Requirements
* PostgreSQL 9.6
* node.js 8.x
* git >2.13
* Nginx 1.12.2

### To install required packages
```
#nginx

sudo yum -y install nginx

#postgresql

sudo yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm

sudo yum -y install postgresql96
sudo yum -y install postgresql96-server

sudo /usr/pgsql-9.6/bin/postgresql96-setup initdb
sudo systemctl enable postgresql-9.6
sudo systemctl start postgresql-9.6

#node

curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
sudo yum -y install nodejs

#git - on centos

sudo yum -y install epel-release
sudo yum -y install https://$(rpm -E '%{?centos:centos}%{!?centos:rhel}%{rhel}').iuscommunity.org/ius-release.rpm
sudo yum -y install git2u

#git - on redhat

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-$(rpm -E '%{rhel}').noarch.rpm
sudo yum -y install https://$(rpm -E '%{?centos:centos}%{!?centos:rhel}%{rhel}').iuscommunity.org/ius-release.rpm
sudo yum -y install git2u
```

## Setup DB
* `sudo su - postgres`
* `psql`
  * `ALTER ROLE postgres WITH PASSWORD 'your_secure_password';`
  * `\q`
* `cd 9.6/data/`
* `nano pg_hba.conf`
  >
  * Change these lines:
  >
  ```
  local   all             all                                     peer
  host    all             all             127.0.0.1/32            ident
  host    all             all             ::1/128                 ident
  ```
  >
  * To these:
  >
  ```
  local   all             all                                     md5
  host    all             all             127.0.0.1/32            md5
  ```
* `nano postgresql.conf`
  >
  * change this line:
  >
  ```
  #listen_addresses = 'localhost'
  ```
  >
  * to this:
  >
  ```
  listen_addresses = '*'
  ```
* `createuser root`
* `createdb gitlean`
* `psql`
  >
  ```
  alter user root with encrypted password 'gitlean';
  grant all privileges on database gitlean to root;
  \q
  ```
* `exit`
* `sudo systemctl restart postgresql-9.6`

## Setup backend
* Run (to unpack backend):
  ```
  cd <path-to-builds>
  mkdir backend
  tar -zxvf backend-no-docker.tar.gz -C backend
  ```
* In `<path-to-builds>/backend`
  * Run `node server.js &> ../backend.log &` or `./gitlean-backend &> ../backend.log &`

# Setup frontend
* Run (to install `nginx`):
  ```
  sudo systemctl enable nginx
  sudo systemctl start nginx

  sudo firewall-cmd --permanent --zone=public --add-service=http
  sudo firewall-cmd --permanent --zone=public --add-service=https
  sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
  sudo firewall-cmd --reload

  sudo setsebool -P httpd_can_network_connect true
  ```
* In `/etc/nginx/nginx.conf` remove or comment dafault server block:
  ```
  server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
        }

	      error_page 404 /404.html;
            location = /40x.html {
        }

	      error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
  }
  ```
* Run (to setup conf file to serve frontend files. ):
  ```
  sudo bash -c 'echo "upstream backend {
    server localhost:3000;
  }

  server {
    listen       80;
    server_name  localhost;
    location / {
      root   /usr/share/nginx/html;
      index  index.html index.htm;
    }

    location /api {
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header Host \$http_host;
      proxy_set_header X-NginX-Proxy true;

      rewrite ^/api/?(.*) /\$1 break;

      proxy_pass http://backend;
      proxy_redirect off;
    }
  }" > /etc/nginx/conf.d/frontend.conf'
  ```
* Run (to unpack frontend files into `/usr/share/nginx/html` *Replace `<path-to-builds>` with real path*:
  ```
  sudo tar -zxvf <path-to-builds>/frontend-no-docker.tar.gz -C /usr/share/nginx/html/
  ```
* Run (to restart ngingx):
  * `sudo systemctl restart nginx`

## Setup parser
* Run (to unpack parser):
  ```
  cd <path-to-builds>
  mkdir parser
  tar -zxvf parser-no-docker.tar.gz -C parser
  ```
* In `<path-to-builds>/parser`
  ```
  ln -s $(pwd)/scripts/git-diff-blame /usr/local/bin/git-diff-blame
  git config --global core.excludesfile $(pwd)/scripts/global-gitignore
  git config --global user.email "parser@gitlean.com"
  git config --global user.name "GitLean"
  git config --global core.quotepath false
  ```

# To run parsing
* [Base instruction for installation with docker](https://docs.google.com/document/d/1KPa0hkvc3_k5ftoIUSL9VEhQNsfEI2nTNfCYyodCa_s/edit) - we just need to adsut it a little bit
* Let's say we clone all repos in some dir `<repos_dir>`
* To analyze repos. Run from `<path-to-builds>/parser`:
  ```
  ./gitlean-git-parser --reposDir=<repos_dir> --onlyAnalyze --outFilesPostfix=<company> --company=<company> --autoYes --withPrepare --since=2017-01-01
  ```
* Adjust `repo_config_<company_name>.json` file. And run `cp gtl-out/repo_config_<company>.json gtl-out/repo_config_<company>_final.json`
* To parse. Run from `<path-to-builds>/parser`:
  ```
  ./gitlean-git-parser --reposDir=<repos_dir> --reposConfig=./gtl-out/repo_config_<company>_final.json --update --mergeAuthors
  ```
* To setup update:
  ```
  echo "0 0 * * * root PATH=${PATH} cd <path-to-builds>/parser && ./gitlean-git-parser --reposDir=<repos_dir> --reposConfig=./gtl-out/repo_config_<company>_final.json --update >> /var/log/cron.log 2>&1" > /etc/cron.d/update
  echo "#empty line" >> /etc/cron.d/update
  chmod 0644 /etc/cron.d/update
  touch /var/log/cron.log
  /sbin/service crond start
  ```
