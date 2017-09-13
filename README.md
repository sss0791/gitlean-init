# gitlean-init
Setup instruction and scripts to init GitLean

# Reqierements
* Install [Docker](https://www.docker.com/)
* Contact us on team@gitlean.com and provide you DockerHub login. So we will be able to give you access to our Docker images

# Instruction
* Clone this repository
* Clone repositories you want to analyze with GitLean in some folder. Let's say it has name - `/repos/to/analyze`
  > Pls do not use your working clones of repositories.
* Run `docker-compose -p=gitlean up -d` from directory where you cloned this repository
* Run analyze script
  * on Mac OS or Linux – `./analyze.sh -r /repos/to/analyze`
  * on Windows – `to be provided`

