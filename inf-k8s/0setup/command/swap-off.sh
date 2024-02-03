#!/bin/bash

sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo sed -i '/ swap / s/^/#/' /etc/fstab
