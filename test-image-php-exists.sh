#!/usr/bin/env bash
docker image ls | grep "php.*8[.]0-fpm"
if [ $? -eq 0 ]; then 
	docker image remove php:8.0-fpm
fi	
exit 0
