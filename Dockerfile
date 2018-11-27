#!/usr/bin/env bash

FROM base/archlinux:latest
LABEL maintainer "Jeremy Seago <seagoj@gmail.com>"
ARG GID=1000
ARG UID=1000
ARG REPO="https://aur.archlinux.org/yay.git"

RUN pacman -Sy --noconfirm archlinux-keyring && \
    pacman -Syu  --noconfirm base-devel git boost && \
    pacman-db-upgrade && \
    update-ca-trust && \
    pacman -Scc --noconfirm
RUN groupadd -r yay -g $GID && useradd --no-log-init -r --create-home -g yay -u $UID yay
COPY sudoers /etc/sudoers
RUN chown -c root:root /etc/sudoers && \
    chmod -c 0440 /etc/sudoers
USER yay
WORKDIR /home/yay
RUN git clone "${REPO}"
RUN cd yay && makepkg --noconfirm -si

ENTRYPOINT [ "yay" ]
