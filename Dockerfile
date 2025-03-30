FROM texlive/texlive:latest

RUN apt-get update && apt-get install -y --plantuml make

WORKDIR /workspace


# FROM ubuntu:latest

# # Install required packages
# RUN apt-get update
# RUN apt-get install -y --no-install-suggests texlive-base plantuml make

# RUN rm -rf /var/lib/apt/lists/*

# # Set working directory
# WORKDIR /workspace
