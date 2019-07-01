version = 1.3.3

build:
	mkdir -p jr-joblistings-v$(version)/public
	cd ./public && yarn build
	cp -R public/build public/class-jr-joblistings-public.php public/index.php public/partials jr-joblistings-v$(version)/public
	cp -R admin includes uninstall.php index.php vendor jr_joblistings.php languages jr-joblistings-v$(version)
	zip -r jr-joblistings-v$(version).zip jr-joblistings-v$(version)
	rm -r jr-joblistings-v$(version)
