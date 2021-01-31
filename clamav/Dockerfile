FROM alpine:3.13.1

# set version
ENV CLAM_VERSION=0.103.0-r1

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

VOLUME /var/lib/clamav

ENTRYPOINT ["sh","/docker-entrypoint.sh"]

EXPOSE 3310