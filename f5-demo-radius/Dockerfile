FROM alpine:3.9

RUN apk update --no-cache; \
    apk add tini freeradius freeradius-radclient && \
      rm -rf /var/cache/apk/*; \
      sed -ie 's/^root::/root:!:/' /etc/shadow; \
      echo '$INCLUDE /etc/raddb/users.default' >> /etc/raddb/mods-config/files/authorize; \
      echo '$INCLUDE /etc/raddb/users.custom' >> /etc/raddb/mods-config/files/authorize; \
      touch /etc/raddb/users.custom; \
      rm -f /etc/raddb/sites-enabled/inner-tunnel; \
      sed -i -e 's/-sql//g' -e 's/-ldap//g' /etc/raddb/sites-enabled/default;

ADD etc/raddb /etc/raddb

EXPOSE \
    1812/udp \
    1813/udp

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["radiusd","-ftxl", "stdout"]
