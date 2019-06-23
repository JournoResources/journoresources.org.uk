build:
	mkdir -p jr-joblistings-v1.3.1/public
	cd ./public && yarn build
	cp -R public/build public/class-jr-joblistings-public.php public/index.php public/partials jr-joblistings-v1.3.1/public
	cp -R admin includes uninstall.php index.php vendor jr_joblistings.php languages jr-joblistings-v1.3.1
	zip -r jr-joblistings-v1.3.1.zip jr-joblistings-v1.3.1
	rm -r jr-joblistings-v1.3.1
