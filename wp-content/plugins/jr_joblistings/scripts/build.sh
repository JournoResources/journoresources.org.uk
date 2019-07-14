set -x

version=$(jq .version public/package.json | tr -d '"')

mkdir -p "jr-joblistings-v${version}/public"

pushd public
yarn build
popd

cp -R public/build public/class-jr-joblistings-public.php public/index.php public/partials \
  "jr-joblistings-v${version}/public"

cp -R admin includes uninstall.php index.php vendor jr_joblistings.php languages jr-google-api-service-account.json \
  "jr-joblistings-v${version}"

zip -r "jr-joblistings-v${version}.zip" "jr-joblistings-v${version}"

rm -r "jr-joblistings-v${version}"
