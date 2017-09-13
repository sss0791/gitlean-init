#!/bin/sh

set -e

repos_dir="";
while [[ ${1:0:1} == - ]]; do
  [[ $1 =~ ^-r|--reposDir$ ]] && { repos_dir="$2"; shift 2; continue; };
  break;
done;

if [ ! "$repos_dir" ]
then
  echo 'Please speify path to directory with repos via -r or --reposDir options'
  exit
fi

repos_dir="`cd "${repos_dir}";pwd`"
current_dir="$(cd "$(dirname "$0")"; pwd)"

docker run --rm -it \
-v "${repos_dir}":/app/repos \
-v "${current_dir}/parser-out":/app/logs \
-v "${current_dir}/parser-out":/app/results \
--network=gitlean_webnet \
gitlean-parser
