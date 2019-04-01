#!/usr/bin/env bash
PLEX_TZ=America/Los_Angeles
PLEX_CLAIM=${PLEX_CLAIM}

docker run \
    -d \
    --restart unless-stopped \
    --name plex \
    --network=host \
    -e TZ="${PLEX_TZ}" \
    -e PLEX_CLAIM="${PLEX_CLAIM}" \
    -v /datalake/plex/database:/config \
    -v /datalake/plex/transcode:/transcode \
    -v /datalake/plex/media:/data \
    plexinc/pms-docker:plexpass
