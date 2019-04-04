#!/usr/bin/env bash
# update LATEST_SPARK_VERSION file

cd remotespark

set -v

# fetching letsencrypt intermediates we can get and building trusted CA chain as remotespark doesnt sent the intermediate
echo | openssl s_client -connect letsencrypt.org:443 -showcerts > le.pem && \
curl -L https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt \
        https://letsencrypt.org/certs/letsencryptauthorityx3.pem.txt \
        https://letsencrypt.org/certs/lets-encrypt-x4-cross-signed.pem.txt \
        https://letsencrypt.org/certs/letsencryptauthorityx4.pem.txt \
        > le-intermediates.pem && \
cat /etc/ssl/certs/ca-certificates.crt le-intermediates.pem le.pem >> ./chain.pem

curl --cacert ./chain.pem -fLO https://www.remotespark.com/view/SparkGateway.zip

mkdir -p ./SparkGateway
unzip -n SparkGateway.zip -d ./SparkGateway

# extract version from some js file, likely: html/surface_min.js: svGlobal.version="5.7.0"
export version=$(grep -r -hPo 'version=.\K([0-9]\.[0-9]\.[0-9])' SparkGateway/)

# 5.7.0 - cut last .0 -> 5.7
version=${version/.0/}

# check if version matches our pattern (5.7, 5.0, 4.8.9, 5.6)
if [[ $(echo $version | egrep '^[0-9]\.[0-9][0-9\.]{0,1}$' | wc -l) -lt "1" ]]
then
  echo "error: version:$version did not match pattern"
  exit 1
fi

# detect if we have a newer version
detected_LATEST_SPARK_VERSION=$(echo -e "$version\n$(<LATEST_SPARK_VERSION)" | sort -r | head -1)
if [[ "$(<LATEST_SPARK_VERSION)" != "$detected_LATEST_SPARK_VERSION" ]]
then
  echo "$detected_LATEST_SPARK_VERSION" > ./LATEST_SPARK_VERSION
  ln -fs Dockerfile Dockerfile.${detected_LATEST_SPARK_VERSION}
  bash ./_ci/gh_update "LATEST_SPARK_VERSION" "Dockerfile.${detected_LATEST_SPARK_VERSION}"
fi