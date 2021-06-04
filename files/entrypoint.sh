#!/usr/bin/env bash
if [ ! -f /srv/app/composer.json ]; then symfony new projeto --no-git; fi
cp -r projeto/ /srv/app/ 
