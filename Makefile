vendor=pmprcoger
app_image_name=symfony-ssl
app_image_version=1.0.0

build:
	docker build -t $(vendor)/$(app_image_name):$(app_image_version) --build-arg https_proxy=$(https_proxy) --build-arg http_proxy=$(http_proxy) --build-arg no_proxy=$(no_proxy) .

push: build
	docker image tag $(vendor)/$(app_image_name):$(app_image_version) $(vendor)/$(app_image_name):latest
	docker push --all-tags $(vendor)/$(app_image_name)


	
