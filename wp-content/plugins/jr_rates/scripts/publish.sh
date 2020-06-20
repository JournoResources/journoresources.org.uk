set -x

version=$(jq .version public/package.json | tr -d '"')
target=$1

sed -i '' "s/${version}/${target}/g" public/package.json
sed -i '' "s/${version}/${target}/g" jr_rates.php
