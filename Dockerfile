FROM golang:latest as build
RUN apt-get update
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y upgrade
RUN apt-get -y install gcc cmake autoconf wget bison libncurses-dev
RUN wget -qO- https://binaries.cockroachdb.com/cockroach-v21.1.0.src.tgz | tar  xvz
RUN go version
WORKDIR cockroach-v21.1.0
RUN make build
RUN make install

FROM ubuntu:latest
RUN apt-get update && apt-get -y upgrade && apt-get install -y libc6 ca-certificates tzdata && rm -rf /var/lib/apt/lists/*
WORKDIR /cockroach/
ENV PATH=/cockroach:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN mkdir -p /cockroach/
COPY --from=build /usr/local/bin/cockroach /cockroach/cockroach
EXPOSE 26257 8080
ENTRYPOINT ["/cockroach/cockroach"]
