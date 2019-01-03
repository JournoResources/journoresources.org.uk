build:
	mkdir -p jr-salaries-v1.0.0/public
	cd ./public && yarn build
	cp -R public/build public/class-jr-salaries-public.php public/index.php public/partials jr-salaries-v1.0.0/public
	cp -R admin includes uninstall.php index.php vendor jr_salaries.php languages jr-salaries-v1.0.0
	zip -r jr-salaries-v1.0.0.zip jr-salaries-v1.0.0
	rm -r jr-salaries-v1.0.0
