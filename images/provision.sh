#!/usr/bin/env bash

sudo set -e

sudo yum update -y 

sudo yum install -y docker

sudo systemctl restart docker

