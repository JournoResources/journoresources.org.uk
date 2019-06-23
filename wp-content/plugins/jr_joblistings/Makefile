build:
	mkdir -p jr-joblistings-v1.3.0/public
	cd ./public && yarn build
	cp -R public/build public/class-jr-joblistings-public.php public/index.php public/partials jr-joblistings-v1.3.0/public
	cp -R admin includes uninstall.php index.php vendor jr_joblistings.php languages jr-joblistings-v1.3.0
	zip -r jr-joblistings-v1.3.0.zip jr-joblistings-v1.3.0
	rm -r jr-joblistings-v1.3.0
