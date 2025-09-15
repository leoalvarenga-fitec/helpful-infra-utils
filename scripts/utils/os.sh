#!/usr/bin/env bash

export DISTRO=$(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2 | sed "s/\"//g" | cut -d ' ' -f1)

export ARCH_CODE="Arch"
export DEBIAN_CODE="Debian"
export UBUNTU_CODE="Ubuntu"

