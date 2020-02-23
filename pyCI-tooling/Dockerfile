FROM docker.io/python:3.8-alpine AS base

LABEL org.label-schema.name="pyCI-tooling"
LABEL org.label-schema.vendor="Simon Kowallik"
LABEL org.label-schema.description="python CI tooling and libs for my CI pipelines"
LABEL org.label-schema.vcs-url="https://github.com/simonkowallik/docker"
LABEL org.label-schema.schema-version="1.0"

# build stage
FROM base as build

RUN apk update --no-cache; \
    apk add --no-cache \
            alpine-sdk \
            bash \
            git \
            libffi-dev \
            make \
            openssl \
            openssl-dev \
            ;
#            py3-cffi \
#            python3-dev \

RUN pip3 install \
      poetry;

#ADD ./Pipfile /
ADD ./pyproject.toml /

WORKDIR /build

#RUN pip3 install \
#      pipenv \
#      ; \
#    pipenv lock -r > /requirements.txt;

RUN poetry export --without-hashes \
      -f requirements.txt -o /requirements.txt;

RUN export PYTHONPATH=/build/lib/python3.8/site-packages; \
    export PATH="$PATH:/build/bin"; \
    pip3 install \
      --prefix /build \
      --ignore-installed \
      -r /requirements.txt || exit 1;

RUN cat /requirements.txt

# final image
FROM base

COPY --from=build /build /usr/local

WORKDIR /workdir

RUN apk update --no-cache; \
    apk add --no-cache \
            bash \
            git \
            openssl \
            vim \
            ;

CMD ["/bin/bash"]
