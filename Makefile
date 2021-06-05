vendor=pmprcoger
app_image_name=symfony
app_image_version=1.0.0

build: #.get-versions
	docker build -t $(vendor)/$(app_image_name):$(app_image_version) --build-arg https_proxy=$(https_proxy) --build-arg http_proxy=$(http_proxy) --build-arg no_proxy=$(no_proxy) .
	docker image remove php:8.0-fpm

push: .image-version-test build
	docker image tag $(vendor)/$(app_image_name):$(app_image_version) $(vendor)/$(app_image_name):latest
	git tag $(app_image_version)
	docker push --all-tags $(vendor)/$(app_image_name)
	git push --tag origin main

# acrescenta informações de versões do php, symfony e composer ao README
.get-versions: .image-version-test
	echo "## VERSÕES INSTALADAS:" > 02-VERSIONS.md
	docker run -it --rm $(vendor)/$(app_image_name):latest php --version > PHP_VERSION
	docker run -it --rm $(vendor)/$(app_image_name):latest "composer --version" > COMPOSER_VERSION
	docker run -it --rm $(vendor)/$(app_image_name):latest symfony version > SYMFONY_VERSION
	echo "" >> PHP_VERSION
	echo "" >> PHP_VERSION
	echo "" >> COMPOSER_VERSION
	echo "" >> COMPOSER_VERSION
	cat PHP_VERSION COMPOSER_VERSION SYMFONY_VERSION >> 02-VERSIONS.md
	cat 01-README.md 02-VERSIONS.md > README.md
	rm -rf PHP_VERSION COMPOSER_VERSION SYMFONY_VERSION 02-VERSIONS.md

# testa se a tag da imagem já não foi enviada para o dockerhub
.image-version-test:
	sh -c "$(PWD)/test-image-version-exists.sh $(vendor) $(app_image_name) $(app_image_version)"

