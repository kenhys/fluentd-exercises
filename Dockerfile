FROM fluent/fluentd:edge-debian

LABEL maintainer "Kentaro Hayashi <kenhys@gmail.com>"
LABEL Description="Fluentd docker image with self signed certificate" Vendor="XDUMP.ORG" Version="0.1.0"

COPY fluent.conf /fluentd/etc/
COPY entrypoint.sh /bin/

RUN openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out /fluentd/etc/cacert.key \
 && openssl req -x509 -key /fluentd/etc/cacert.key -out /fluentd/etc/cacert.crt -subj "/C=JP/ST=Saitama/L=Saitama/O=localhost/OU=Fabre/CN=localhost/emailAddress=admin@localhost" \
 && mkdir -p /fluentd/etc/demoCA/newcerts \
 && touch /fluentd/etc/demoCA/index.txt \
 && echo 01 | tee  /fluentd/etc/demoCA/serial \
 && cd /fluentd/etc \
 && openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out /fluentd/etc/user.key \
 && openssl req -new -key /fluentd/etc/user.key -out /fluentd/etc/user.csr -subj "/C=JP/ST=Saitama/L=Saitama/O=localhost/OU=Fluentd/CN=noreply@localhost" \
 && openssl ca -batch -in /fluentd/etc/user.csr -out /fluentd/etc/user.crt -keyfile /fluentd/etc/cacert.key -cert /fluentd/etc/cacert.crt -key "" \
 && openssl pkcs12 -export -inkey /fluentd/etc/user.key -in /fluentd/etc/user.crt -out /fluentd/etc/user.pfx -passout pass:

ENV FLUENTD_CONF="fluent.conf"

ENV LD_PRELOAD="/usr/lib/libjemalloc.so.2"
EXPOSE 24224 5140

USER fluent
ENTRYPOINT ["tini",  "--", "/bin/entrypoint.sh"]
CMD ["fluentd"]
