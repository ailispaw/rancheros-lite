FROM debian:wheezy

RUN apt-get update && \
    apt-get install --no-install-recommends -y -q \
      ca-certificates \
      curl \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["curl"]
