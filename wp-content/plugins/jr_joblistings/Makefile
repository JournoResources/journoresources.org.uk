build:
	mkdir -p package/public
	cd ./public && yarn build
	cp -R public/build package/public
	cp -R admin includes uninstall.php index.php vendor jr_joblistings.php languages package
	zip -r jr_joblistings-v1.2.0.zip package
	rm -r package
