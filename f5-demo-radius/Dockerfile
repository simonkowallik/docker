FROM alpine:latest

RUN apk update --no-cache; \
    apk upgrade; \
    apk add \
        vim \
        bash \
        freeradius \
        freeradius-lib \
        freeradius-radclient \
        ;

RUN rm -rf /var/cache/apk/*;

RUN sed -ie 's/^root::/root:!:/' /etc/shadow; \
      echo '$INCLUDE /etc/raddb/users.f5-bigip-tmos' >> /etc/raddb/mods-config/files/authorize; \
      echo '$INCLUDE /etc/raddb/users.f5os' >> /etc/raddb/mods-config/files/authorize; \
      echo '$INCLUDE /etc/raddb/users.custom' >> /etc/raddb/mods-config/files/authorize; \
      touch /etc/raddb/users.custom; \
      rm -f /etc/raddb/sites-enabled/inner-tunnel; \
      sed -i -e 's/-sql//g' -e 's/-ldap//g' /etc/raddb/sites-enabled/default;

ADD etc/raddb /etc/raddb

EXPOSE \
    1812/udp \
    1813/udp

CMD ["radiusd","-ftxl", "stdout"]
