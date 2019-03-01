#!/usr/bin/env bash
export MYSQL_DATABASE_NEXTCLOUD=nextcloud
export MYSQL_USER_NEXTCLOUD=nextcloud
export MYSQL_PASSWORD_NEXTCLOUD=

if [ -z "MYSQL_PASSWORD_NEXTCLOUD" ]; then
    echo "Please provide Nextcloud password."
fi

export MYSQL_DATABASE_GHOST=ghost
export MYSQL_USER_GHOST=ghost
export MYSQL_PASSWORD_GHOST=

if [ -z "MYSQL_PASSWORD_GHOST" ]; then
    echo "Please provide Ghost password."
fi

echo "Substituting Nextcloud environment variables."
envsubst < nextcloud/db.env.template > nextcloud/db.env
envsubst < nextcloud/nextcloud.env.template nextcloud/nextcloud.env

echo "Substituting Ghost environment variables."
envsubst < ghost/db.env.template > ghost/db.env
envsubst < ghost/ghost.env.template > ghost/ghost.env

echo "Substituting MariaDB SQL script variables."
envsubst < mariadb/ghost.sql.template > mariadb/ghost.sql
envsubst < mariadb/nextcloud.sql.template > mariadb/nextcloud.sql

echo "Bringing up environment."
docker-compose up -d