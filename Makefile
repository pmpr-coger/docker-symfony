.DEFAULT_GOAL := build

vendor=pmprcoger
app_image_name=symfony
app_image_version=1.0.4
php_version=php:8.0.9-fpm

build:
	make -s .build-prod
	make -s .build-dev

.build-dev: .image-version-test .rm-php-image
	docker build -f dev/Dockerfile -t $(vendor)/$(app_image_name):$(app_image_version)-dev --build-arg https_proxy=$(https_proxy) --build-arg http_proxy=$(http_proxy) --build-arg no_proxy=$(no_proxy) .
	docker image tag $(vendor)/$(app_image_name):$(app_image_version)-dev $(vendor)/$(app_image_name):latest-dev

.build-prod: .image-version-test .rm-php-image
	docker build -f prod/Dockerfile -t $(vendor)/$(app_image_name):$(app_image_version) --build-arg https_proxy=$(https_proxy) --build-arg http_proxy=$(http_proxy) --build-arg no_proxy=$(no_proxy) .
	docker image tag $(vendor)/$(app_image_name):$(app_image_version) $(vendor)/$(app_image_name):$(app_image_version)-prod
	docker image tag $(vendor)/$(app_image_name):$(app_image_version) $(vendor)/$(app_image_name):latest-prod
	docker image tag $(vendor)/$(app_image_name):$(app_image_version) $(vendor)/$(app_image_name):latest
	docker image remove $(php_version)

push: build .get-versions
	git tag $(app_image_version)
	docker push --all-tags $(vendor)/$(app_image_name)
	git add README.md
	git commit -m "chore: atualiza README"
	git push --tag origin main

# busca a versão mais recente do php 8.0
.rm-php-image:
	sh test-image-php-exists.sh

# acrescenta informações de versões do php, symfony e composer ao README
.get-versions: 
	echo "## VERSÕES INSTALADAS:" > 02-VERSIONS.md
	docker run -it --rm $(vendor)/$(app_image_name):$(app_image_version)-prod php --version > PHP_VERSION
	docker run -it --rm $(vendor)/$(app_image_name):$(app_image_version)-prod composer --version > COMPOSER_VERSION
	docker run -it --rm $(vendor)/$(app_image_name):$(app_image_version)-prod symfony version > SYMFONY_VERSION
	echo "" >> PHP_VERSION
	echo "" >> PHP_VERSION
	echo "" >> COMPOSER_VERSION
	echo "" >> COMPOSER_VERSION
	cat PHP_VERSION COMPOSER_VERSION SYMFONY_VERSION >> 02-VERSIONS.md
	cat 01-README.md 02-VERSIONS.md > README.md
	rm -rf PHP_VERSION COMPOSER_VERSION SYMFONY_VERSION 02-VERSIONS.md

# testa se a tag da imagem já não foi enviada para o dockerhub
.image-version-test:
	sh -c "$(PWD)/test-image-version-exists.sh $(vendor) $(app_image_name) $(app_image_version)-dev"
	sh -c "$(PWD)/test-image-version-exists.sh $(vendor) $(app_image_name) $(app_image_version)-prod"

