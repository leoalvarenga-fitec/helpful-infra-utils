#!/usr/bin/env bash

install_basics() {
	sudo apt-get update > /dev/null 2>&1
	sudo apt-get upgrade -y > /dev/null 2>&1

	sudo apt-get install -y curl  wget unzip jq gnupg software-properties-common > /dev/null 2>&1
}

