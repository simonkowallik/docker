FROM alpine:3.9

LABEL name="httpbin"
LABEL description="A simple HTTP service."

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /httpbin

RUN apk update --no-cache; \
    apk add --no-cache python3 libffi && \
    apk add --no-cache --virtual .build-deps \
        alpine-sdk \
        git \
        libffi-dev \
        python3-dev && \
    git clone --depth=1 https://github.com/postmanlabs/httpbin.git /httpbin && \
    rm -rf /httpbin/.git && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir pipenv gunicorn && \
    pipenv lock -r > /httpbin/requirements.txt && \
    pip3 install --no-cache-dir /httpbin && \
    apk del .build-deps

EXPOSE 80

CMD ["gunicorn", "-b", "0.0.0.0:80", "httpbin:app", "-k", "gevent"]