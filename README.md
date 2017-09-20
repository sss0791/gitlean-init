# gitlean-init
Setup instruction and scripts for GitLean initialization.

# Reqierements
* Install [Docker](https://www.docker.com/)
* Register in [DockerHub](https://hub.docker.com)
* Contact us on team@gitlean.com and provide your DockerHub login so we will be able to give you access to our Docker images

# Instruction
* Clone this repository
* Clone repositories you want to analyze (let's say `my_repo_1`, `my_repo_2`, `my_repo_3`, etc.) to some parent folder (let's say `/my/parent/dir/with/repos`).
Folder structure should be like the following:
  `/my/parent/dir/with/repos/my_repo_1`,
  `/my/parent/dir/with/repos/my_repo_2`,
  `/my/parent/dir/with/repos/my_repo_3`,
  etc.

  **Pls do not use your working copies of repositories.**

* **Note for second usage (if you do it first time just skip this note):**
  If you already analyzed some repos and after it you wish to add some extra repos - just add them to `/my/parent/dir/with/repos/` and run repository parser again. Don't remove repos that are already there. Use the same company name that you specified previously.

* Before the next steps be sure you are logged in Docker via terminal, use `docker login` command and set your DockerId and password.
* If you use Docker Toolbox (on Windows below Windows 10 or Windows 10 without Hyper-V) all the next commands should be run from `Docker Quickstart Terminal`
* Run `docker-compose -p=gitlean up -d` from directory where this repository has been cloned. (If you're experiencing problems check Troubleshooting section)
* Run repository parser
  * on Mac OS or Linux – `./parser.sh -r /my/parent/dir/with/repos/`
  * on Windows
    * If you use Docker Toolbox (on Windows below Windows 10 or Windows 10 without Hyper-V).
      * Run `./parser.sh -r /my/parent/dir/with/repos/`
    * If you use latest Docker for Windows (on Windows 10 with Hyper-V)
      * Run `.\parser.bat -r \my\parent\dir\with\repos\`
* Follow promt instructions of script. Script will ask you several questions before it starts parsing data from your repositories
  > *Parsing of repositories could take several hours. Parsing of 1000 commits usually takes ~10-30min*
* After the script finished you can check GitLean analytics dashboard on `localhost:8080`
  * If you use Docker Toolbox `localhost:8080` wouldn't work
    * Run `docker-machine ip default`
    * Open `ip_from_previous_comand:8080`
* To stop GitLean containers run `docker-compose -p=gitlean down` from directory where this repository has been cloned

# Troubleshooting with docker-compose

* If you're experiencing some problems on Windows try to check [Docker for Windows. Troubleshoot]( https://docs.docker.com/docker-for-windows/troubleshoot/)
* One of ports could be already used. We store default ports in file .env. DB_PORT=5432, BACKEND_PORT=3000, FRONTEND_PORT=8080. If Docker failed because it tried to use some already occupied port you should change port manually.
  * Check if new port is not in use, let's say 8081:
    * MacOS: `lsof -n -i:8081 | grep LISTEN`
    * Windows: `netstat -aon | findstr :8081`
    * Linux: `netstat -tulpn | grep :8081`
  * Go to file .env and set chosen port instead of old one.
