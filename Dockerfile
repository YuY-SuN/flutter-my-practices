FROM registry.hub.docker.com/library/ubuntu:latest

RUN apt-get update -y && apt-get install -y systemd

