vendor=pmprcoger
app_image_name=symfony
app_image_version=1.0.0

build: .get-versions
	docker build -t $(vendor)/$(app_image_name):$(app_image_version) --build-arg https_proxy=$(https_proxy) --build-arg http_proxy=$(http_proxy) --build-arg no_proxy=$(no_proxy) .

push: build
	docker image tag $(vendor)/$(app_image_name):$(app_image_version) $(vendor)/$(app_image_name):latest
	docker push --all-tags $(vendor)/$(app_image_name)

.get-versions: 
	echo "## MÓDULOS ZEND INSTALADOS:" > 02-VERSIONS.md
	docker run -it --rm pmprcoger/symfony-ssl:$(app_image_version) php --version > PHP_VERSION
	docker run -it --rm pmprcoger/symfony-ssl:$(app_image_version) symfony version > SYMFONY_VERSION
	cat PHP_VERSION SYMFONY_VERSION >> 02-VERSIONS.md
	cat 01-README.md 02-VERSIONS.md > README.md
	rm -rf PHP_VERSION SYMFONY_VERSION 02-VERSIONS.md
	
