#
#
#
FROM alpine:latest

WORKDIR /host_files
COPY ./README.md README.md
COPY ./LICENSE LICENSE
