# Squid Docker Container Image

[![Build Status](https://github.com/wodby/squid/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/squid/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/squid.svg)](https://hub.docker.com/r/wodby/squid)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/squid.svg)](https://hub.docker.com/r/wodby/squid)

## Docker Images

Use image revision tags such as `wodby/squid:7-rN` to select a Wodby image revision.
The `rN` suffix identifies the image revision separately from the upstream software version.
See [release tags](https://github.com/wodby/squid/tags) for available revisions and the [image revision policy](https://github.com/wodby/images#image-revisions) for upgrade guidance.
Existing SemVer image tags remain available.

Overview:

- All images based on Alpine Linux
- Base image: [wodby/alpine](https://github.com/wodby/alpine)
- [GitHub actions builds](https://github.com/wodby/squid/actions)
- [Docker Hub](https://hub.docker.com/r/wodby/squid)

Supported tags and respective `Dockerfile` links:

- `7.6`, `7`, `latest` [_(Dockerfile)_](https://github.com/wodby/squid/blob/main/Dockerfile)

All images built for `linux/amd64`

Squid 5 is no longer built. Review your configuration against the [Squid 7 release notes](https://www.squid-cache.org/Versions/v7/RELEASENOTES.html) before upgrading.
