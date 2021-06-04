#!/usr/bin/env bash
docker pull $1/$2:$3
if [ $? -eq 0 ]; then 
	echo "A versão de imagem já existe. Corrija no arquivo Makefile"; 
	exit 255
fi	
exit 0
