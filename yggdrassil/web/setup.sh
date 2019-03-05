#!/usr/bin/env bash
export DDNS_PASSWORD=${DDNS_PASSWORD}

envsubst < ddclient/ddclient.conf.template > ddclient/ddclient.conf

if [ -e nginx/certs/remington_io.chain.crt ]; then
    echo "remington.io SSL certificate exists, proceeding."
else
    echo "Please add remington.io certificate and private key!"
    exit 1
fi

export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}

export MYSQL_DATABASE_NEXTCLOUD=nextcloud
export MYSQL_USER_NEXTCLOUD=nextcloud
export MYSQL_PASSWORD_NEXTCLOUD=${MYSQL_PASSWORD_NEXTCLOUD}

if [ -z "MYSQL_PASSWORD_NEXTCLOUD" ]; then
    echo "Please provide Nextcloud password."
    exit 2
fi

export MYSQL_DATABASE_GHOST=ghost
export MYSQL_USER_GHOST=ghost
export MYSQL_PASSWORD_GHOST=${MYSQL_PASSWORD_GHOST}

if [ -z "MYSQL_PASSWORD_GHOST" ]; then
    echo "Please provide Ghost password."
    exit 3
fi

echo "Substituting Nextcloud environment variables."
envsubst < nextcloud/db.env.template > nextcloud/db.env

echo "Substituting Ghost environment variables."
envsubst < ghost/db.env.template > ghost/db.env

echo "Substituting MariaDB SQL script variables."
envsubst < mariadb/db.env.template > mariadb/db.env
envsubst < mariadb/conf.d/ghost.sql.template > mariadb/conf.d/ghost.sql
envsubst < mariadb/conf.d/nextcloud.sql.template > mariadb/conf.d/nextcloud.sql

echo "Bringing up environment."
docker-compose up -d
