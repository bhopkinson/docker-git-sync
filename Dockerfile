FROM ubuntu:20.04

# Install runtime dependencies
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update -qq && apt-get install -qq -y --no-install-recommends git openssh-client cron git-crypt

# Install scripts
COPY sync.sh entrypoint.sh /usr/local/bin/

VOLUME /root/.ssh
VOLUME /git-crypt
VOLUME /sync-dir

# Run the command on container startup
ENTRYPOINT ["entrypoint.sh"]
