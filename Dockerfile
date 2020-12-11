FROM alpine:latest as git-crypt

RUN apk --update add ca-certificates bash curl git g++ gnupg make openssh openssl openssl-dev

ENV VERSION 0.6.0-1

RUN curl -L https://github.com/AGWA/git-crypt/archive/debian/$VERSION.tar.gz | tar zxv -C /var/tmp
RUN cd /var/tmp/git-crypt-debian-$VERSION && make && make install PREFIX=/usr/local

FROM ubuntu:20.04

COPY --from=git-crypt /usr/local ./usr/local

# Install runtime dependencies
RUN apt-get update -qq && apt-get install -qq -y --no-install-recommends git openssh-client cron

# Install scripts
COPY sync.sh entrypoint.sh /usr/local/bin/

VOLUME /root/.ssh
VOLUME /git-crypt
VOLUME /sync-dir

# Run the command on container startup
ENTRYPOINT ["entrypoint.sh"]