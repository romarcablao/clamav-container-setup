FROM alpine:3.15.0

# set version (refer to alpine linux version)
ENV CLAM_VERSION=0.104.1-r0

# add dependencies
RUN apk add --no-cache clamav=$CLAM_VERSION clamav-libunrar=$CLAM_VERSION 
RUN apk add ca-certificates && update-ca-certificates

# add clamav user
RUN adduser -S -G clamav -u 1000 clamav_user -h /var/lib/clamav && \
    mkdir -p /var/lib/clamav && \
    mkdir -p /var/run/clamav && \
    mkdir /usr/local/share/clamav && \
    chown -R clamav_user:clamav /var/lib/clamav /usr/local/share/clamav /etc/clamav

# configure clamav
COPY --chown=clamav_user:clamav ./conf/*.conf /etc/clamav/
COPY --chown=clamav_user:clamav ./scripts/docker-entrypoint.sh /

# set permissions
RUN chown clamav_user:clamav /var/run/clamav && \
    chown clamav_user:clamav /var/log/clamav && \
    chmod 750 /var/run/clamav && \
    chmod 750 /var/log/clamav

# set user
USER clamav_user

# initial update of av databases
RUN freshclam

# set volume
VOLUME /var/lib/clamav

# expose service
EXPOSE 3310

# add entrypoint
ENTRYPOINT ["sh","/docker-entrypoint.sh"]

