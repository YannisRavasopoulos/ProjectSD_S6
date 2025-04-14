# https://docs.flutter.dev/get-started/install/linux/android
FROM ubuntu:latest
RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install -y curl wget git unzip xz-utils zip libglu1-mesa && \
    apt-get install -y libc6:amd64 libstdc++6:amd64 lib32z1 libbz2-1.0:amd64

RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.2-stable.tar.xz && \
    tar -xf flutter_linux_3.29.2-stable.tar.xz -C /opt && \
    chown -R root:root /opt/flutter

ENV PATH="/opt/flutter/bin:${PATH}"
# WORKDIR /workspace
