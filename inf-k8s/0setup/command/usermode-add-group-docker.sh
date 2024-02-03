#!/bin/bash

# add this user on docker group
sudo usermod -aG docker `whoami`
sudo service docker restart
