#!/bin/bash

# This script installs a specific version of VSCode Server for Linux for airgapped systems.
#
# The parent of version source directories is the first argument to the script.


install_vscode () {
    clear
    code_vers="$1"
    cd ${srcpath}${code_vers}
    git_cid=($(cat cid.txt))
    echo "$PWD"
    echo "Installing VSCode Server version: ${git_cid}"
    install_path="${HOME}/.vscode-server/bin/${git_cid}"
    echo $install_path
    if [ -d $install_path ]; then
        echo "Already installed"
    else
        mkdir -p ${install_path}
        tar -xzf vscode-server-linux-x64.tar.gz -C ${install_path} --strip-components 1
        touch ${install_path}/0
    fi
    install_path="${HOME}/.vscode-server/cli/servers/Stable-${git_cid}/server"
    echo $install_path
    if [ -d $install_path ]; then
        echo "Already installed"
    else
        mkdir -p ${install_path}
        tar -xzf vscode-server-linux-x64.tar.gz -C ${install_path} --strip-components 1
        touch ${install_path}/0
    fi
    echo "Press r to return"
    read -n 1
    return 0
}

if [ $# -eq 0 ]
    then
        srcpath=/mnt/share/code/
    else
        srcpath="$1"
fi


declare -a codevers=($(find ${srcpath} -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))
codever=""
while [ 1 ]; do
    clear
    if [[ -z "$codever" ]]; then
        echo "Please code version"
        for i in "${!codevers[@]}"; do
            echo "$i - ${codevers[i]}"
        done
        echo "Press x to exit"
        read -n 1 ver
        codever=${codevers[ver]}
        echo "v $codever"
        echo "a ${codevers[ver]}"
    else
        echo "Code version is $codever"
        git_cid=($(cat ${srcpath}${codever}/cid.txt))
        echo "Git ID is $git_cid"
        echo "s - Install vscode server"
        echo "Press x to exit"
        read -n 1 c
        case $c in
        s)
            install_vscode $codever
            ;;
        x)
            exit
            ;;
        esac
    fi
done

