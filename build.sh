#!/bin/bash

sudo docker build -t keybase.net.docker:latest . && sudo docker save keybase.net.docker:latest > Keybase.net.Docker.tar
