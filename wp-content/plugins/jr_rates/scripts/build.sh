set -x

version=$(jq .version public/package.json | tr -d '"')

mkdir -p "jr-rates-v${version}/public"

pushd public
yarn build
popd

cp -R public/build public/class-jr-rates-public.php public/index.php public/partials \
  "jr-rates-v${version}/public"

cp -R admin includes uninstall.php index.php vendor jr_rates.php languages recaptcha-secret.env \
  "jr-rates-v${version}"

zip -r "jr-rates-v${version}.zip" "jr-rates-v${version}"

rm -r "jr-rates-v${version}"
