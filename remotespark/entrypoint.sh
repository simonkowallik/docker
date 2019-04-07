#!/usr/bin/env sh
set -e

if [[ "$1" == "run_remotespark" ]]
then
  if [[ ! -f /usr/local/bin/SparkGateway/SparkGateway.jar ]]
  then
    # need to install SparkGateway

    #ADD https://www.remotespark.com/view/SparkGateway.zip .
    # downloading directly via https fails - remotespark doesnt send the intermediate letsencrypt certificate
    #ADD failed: Get https://www.remotespark.com/view/SparkGateway.zip: x509: certificate signed by unknown authority

    #https://www.remotespark.com/view/5.6/SparkGateway.zip
    #https://www.remotespark.com/view/5.5/SparkGateway.zip

    # SPARK_VERSION <- Dockerfile ENV
    [[ "$SPARK_VERSION" == "$(cat /LATEST_SPARK_VERSION)" ]] && \
      echo -e "\n* notice: version ${SPARK_VERSION} is 'latest', using 'latest' instead\n" && \
      SPARK_VERSION="latest" ; \
    [[ "$SPARK_VERSION" == "latest" ]] && SPARKVER="" || SPARKVER="${SPARK_VERSION}/";
    
    url="https://www.remotespark.com/view/${SPARKVER}SparkGateway.zip"
    
    echo -e "\n*** RemoteSpark Gateway not preloaded, starting download for version:$SPARK_VERSION from:$url ***\n"
    curl -fLO --cacert /usr/local/bin/SparkGateway/chain.pem $url

    #extract SparkGateway - do not overwrite files (eg. volume for logs/gateway.conf)
    unzip -n SparkGateway.zip -d /usr/local/bin

    # remove zip and manuals (frees 15MB)
    rm -f SparkGateway.zip
    find /usr/local/bin/SparkGateway/html/ -type f | grep -i 'pdf$' | xargs rm -f
  fi
  # start SparkGateway
  echo -e "\n*** Starting SparkGateway ***\n"
  exec java -jar SparkGateway.jar
else
  # cmd probably changed by docker run
  exec "$@"
fi