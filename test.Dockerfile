#
#
#
FROM alpine:latest

LABEL description="This is test docker image from https://github.com/Enchan1207/gha-sandbox. \
In details, please check repository."

WORKDIR /host_files
COPY ./README.md README.md
COPY ./LICENSE LICENSE
