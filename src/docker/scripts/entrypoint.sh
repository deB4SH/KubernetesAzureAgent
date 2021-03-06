#! /bin/bash

# parse options
while getopts f: flag
do
    case "${flag}" in
        f) filepath=${OPTARG};;
    esac
done

# print debug
echo "[x]====== 0.1 - copy setup scripts to rw-dir"
mkdir /tmp/container-init
cp -R -p $filepath /tmp/container-init
# print debug
echo "[x]====== 1.0 - calling setup scripts for further setup"
#add executable tag to all scripts in setup dir
find /tmp/container-init -name "*.sh" -exec chmod +x {} \;
#execute all scripts in setup dir
find /tmp/container-init -name "*.sh" -exec sh -c {} \;
# print debug
echo "[x]====== 2.0 - start azure client"
sh -c /azp/start.sh
