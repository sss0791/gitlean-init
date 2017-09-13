# gitlean-init
Setup instruction and scripts for GitLean initialization.

# Reqierements
* Install [Docker](https://www.docker.com/)
* Register in [DockerHub](https://hub.docker.com)
* Contact us on team@gitlean.com and provide your DockerHub login so we will be able to give you access to our Docker images

# Instruction
* Clone this repository
* Clone repositories you want to analyze with GitLean in some folder. Let's say it has name - `/repos/to/analyze`
  > **Pls do not use your working copies of repositories. Our analyzer can save you local changes in git stash automatically but it will be safer to avoid it.**
* Run `docker-compose -p=gitlean up -d` from directory where this repository has been cloned
* Run repository parser
  * on Mac OS or Linux – `./parser.sh -r /repos/to/analyze`
  * on Windows – `to be provided`
* Follow propmt instructions of script
