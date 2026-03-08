FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    automake \
    autoconf \
    libtool \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
COPY . .

RUN autoreconf -fi
RUN ./configure
RUN make polyglot

FROM debian:bookworm-slim

COPY --from=builder /src/polyglot /usr/local/bin/polyglot

ENTRYPOINT ["/bin/sh", "-c", "exec polyglot \"$@\"", "--"]
