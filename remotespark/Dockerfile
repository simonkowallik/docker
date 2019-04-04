FROM openjdk:13-alpine

# to add RemoteSpark software version 5.6 to the image during build run:
# docker build --build-arg SPARK_VERSION=5.6 --build-arg EMBED=true .
# otherwise it will be downloaded on first container start
ARG EMBED=false
ARG SPARK_VERSION=latest

ENV SPARK_VERSION $SPARK_VERSION

#ADD https://www.remotespark.com/view/SparkGateway.zip .
# downloading directly via https fails - remotespark doesnt send the intermediate letsencrypt certificate
#ADD failed: Get https://www.remotespark.com/view/SparkGateway.zip: x509: certificate signed by unknown authority

ADD entrypoint.sh /entrypoint.sh
ADD LATEST_SPARK_VERSION /LATEST_SPARK_VERSION

WORKDIR /tmp/build

RUN apk add --update --no-cache curl openssl && \
  mkdir /usr/local/bin/SparkGateway && \
  echo -e "\n* WORKAROUND: fetching letsencrypt intermediates we can get and building trusted CA chain as remotespark doesnt sent the intermediate :(\n" && \
  echo | openssl s_client -connect letsencrypt.org:443 -showcerts > le.pem && \
  curl -L https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem.txt \
          https://letsencrypt.org/certs/letsencryptauthorityx3.pem.txt \
          https://letsencrypt.org/certs/lets-encrypt-x4-cross-signed.pem.txt \
          https://letsencrypt.org/certs/letsencryptauthorityx4.pem.txt \
          > le-intermediates.pem && \
  cat /etc/ssl/certs/ca-certificates.crt le-intermediates.pem le.pem >> /usr/local/bin/SparkGateway/chain.pem && \
  echo -e "\n* starting actual docker build tasks\n"; \
  rm -f /opt/openjdk-13/lib/src.zip; \
  [[ "$SPARK_VERSION" == "$(cat /LATEST_SPARK_VERSION)" ]] && \
    echo -e "\n* notice: version ${SPARK_VERSION} is 'latest', using 'latest' instead\n" && \
    SPARK_VERSION="latest" ; \
  [[ "$SPARK_VERSION" == "latest" ]] && SPARKVER="" || SPARKVER="${SPARK_VERSION}/"; \
  url="https://www.remotespark.com/view/${SPARKVER}SparkGateway.zip"; \
  [[ "$EMBED" == "true" ]] && ( \
      echo -e "\n* EMBEDing RemoteSpark Gateway version:$SPARK_VERSION from url:$url\n" && \
      curl -fLO $url \
            --cacert /usr/local/bin/SparkGateway/chain.pem; \
      unzip SparkGateway.zip -d /usr/local/bin; \
      rm -f SparkGateway.zip /usr/local/bin/SparkGateway/html/*.pdf; \
    ); \
  [[ "$EMBED" == "true" ]] && \
      [[ ! -f /usr/local/bin/SparkGateway/SparkGateway.jar ]] && exit 1; \
  [[ "$EMBED" == "false" ]] && \
      echo -e "\n* Test availability for RemoteSpark Gateway version:$SPARK_VERSION from url:$url\n" && \
      curl -I $url --cacert /usr/local/bin/SparkGateway/chain.pem 2>/dev/null | head -1 | grep -v '200 OK' && exit 1; \
  rm -rf /tmp/build;

WORKDIR /usr/local/bin/SparkGateway

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "run_remotespark" ]