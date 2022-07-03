FROM ubuntu:focal AS base

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y sudo software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

ARG TAGS
RUN addgroup --gid 1000 k1ng
RUN adduser --gecos k1ng --uid 1000 --gid 1000 --disabled-password k1ng
RUN echo "k1ng ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
USER k1ng
WORKDIR /home/k1ng/ansible

FROM base
COPY . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]

