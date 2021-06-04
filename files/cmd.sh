#!/usr/bin/env bash
if [ ! -f /srv/app/composer.json ]; then 
	echo "[erro]: não existe um projeto Symfony na pasta /srv/app"
	echo "[erro]: utilize a opção \"-v \$(pwd):/srv/app\" no comando docker"
	exit 1
else
	symfony serve --port=443
fi
