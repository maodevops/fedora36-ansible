#
# Dockerfile used to build Fedora 36 images for testing Ansible
#

# syntax = docker/dockerfile:1

ARG BASE_IMAGE_TAG=36

FROM fedora:${BASE_IMAGE_TAG}

ENV container=docker

RUN dnf -y install systemd && dnf clean all && \
  (cd /lib/systemd/system/sysinit.target.wants/ ; for i in * ; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i ; done) ; \
  rm -f /lib/systemd/system/multi-user.target.wants/* ;\
  rm -f /etc/systemd/system/*.wants/* ;\
  rm -f /lib/systemd/system/local-fs.target.wants/* ; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
  rm -f /lib/systemd/system/basic.target.wants/* ;\
  rm -f /lib/systemd/system/anaconda.target.wants/*

# Install required packages
# hadolint ignore=DL3041
RUN dnf -y install rpm dnf-plugins-core ; \
  dnf -y update ; \
  dnf -y install \
    sudo \
    which \
    python3-pip \
    python3-pyyaml ; \
  dnf clean all ; \
  pip3 install --no-cache-dir --upgrade pip

VOLUME ["/sys/fs/cgroup"]

CMD ["/usr/lib/systemd/systemd"]
