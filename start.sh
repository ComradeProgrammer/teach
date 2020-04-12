#!/usr/bin/env bash
set -e
project=`basename $PWD`
# rvm 环境
# export PATH="$PATH:/home/deploy/.rvm/bin"
# source "/home/deploy/.rvm/scripts/rvm"
export PATH="$PATH:/usr/local/rvm/bin"
source "/usr/local/rvm/scripts/rvm"
cd /home/deploy/${project}
puma
