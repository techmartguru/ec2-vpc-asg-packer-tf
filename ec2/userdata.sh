#!/bin/bash

sudo systemctl restart docker
sudo docker run -dit -p 8090:80 nginx
