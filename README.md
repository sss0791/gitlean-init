# gitlean-init
Setup instruction and scripts for GitLean initialization.

# Reqierements
* Install [Docker](https://www.docker.com/)
* Register in [DockerHub](https://hub.docker.com)
* Contact us on team@gitlean.com and provide your DockerHub login so we will be able to give you access to our Docker images

# Instruction
* Clone this repository
* Clone repositories you want to analyze with GitLean in some folder. Let's say it has name - `/repos/to/analyze`
  **Pls do not use your working copies of repositories. Our analyzer can save you local changes in git stash automatically but it will be safer to avoid it.**
* Before next steps be sure you are logged in docker. The best way to login is login via terminal and `docker login` command. Because sometimes login via docker app don't work properly.
* If you use Docker Toolbox (on Windows below Windows 10 or Windows 10 without Hyper-V) all next commands should be run from `Docker Quickstart Terminal`
* Run `docker-compose -p=gitlean up -d` from directory where this repository has been cloned
* Run repository parser
  * on Mac OS or Linux – `./parser.sh -r /repos/to/analyze`
  * on Windows
    * If you use Docker Toolbox (on Windows below Windows 10 or Windows 10 without Hyper-V).
      * Run `./parser.sh -r /repos/to/analyze`
    * If you use latest Docker for Windows (on Windows 10 with Hyper-V)
      * Run `.\parser.bat -r \repos\to\analyze`
* Follow promt instructions of script. Script will ask you several questions before it starts parsing data from your repositories
  > *Parsing of repositories could take several hours. Parsing of 1000 comiits usually takes ~10-30min*
* After the script finished you can check GitLean analytics dashboard on `localhost:8080`
  * If you use Docker Toolbox `localhost:8080` wouldn't work
    * Run `docker-machine ip default`
    * Open `ip_from_previous_comand:8080`
