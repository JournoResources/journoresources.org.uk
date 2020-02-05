set -x

version=$(jq .version public/package.json | tr -d '"')

mkdir -p "jr-salaries-v${version}/public"

pushd public
yarn build
popd

cp -R public/build public/class-jr-salaries-public.php public/index.php public/partials \
  "jr-salaries-v${version}/public"

cp -R admin includes uninstall.php index.php vendor jr_salaries.php languages \
  "jr-salaries-v${version}"

zip -r "jr-salaries-v${version}.zip" "jr-salaries-v${version}"

rm -r "jr-salaries-v${version}"
