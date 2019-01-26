FROM node:lts-alpine

ARG AS3_SCHEMA_VALIDATIOR_VERSION=3.5.1

WORKDIR /build

RUN apk add --no-cache --virtual .build-deps curl unzip && \
    curl -fsSLO https://github.com/F5Networks/f5-appsvcs-extension/raw/master/AS3-schema-validator/${AS3_SCHEMA_VALIDATIOR_VERSION}/build.zip && \
    unzip -d / build.zip && \
    rm -f build.zip && \
    npm install -g serve && \
    apk del .build-deps
 
EXPOSE 5000:5000

CMD ["serve"]
