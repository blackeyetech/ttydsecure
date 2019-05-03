# Dockerfile for ttyd
FROM debian:stretch-slim AS build-stage

# First step is to build ttyd
RUN apt-get update && \
    apt-get install -y cmake g++ pkg-config git vim-common && \
    apt-get install -y libwebsockets-dev libjson-c-dev libssl-dev && \
    git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && \
    cmake .. && \
    make && make install

# Now build the main image
FROM debian:stretch-slim

LABEL maintainer="Black Eye Technology"

# Copy the ttyd from the build stage to this image
COPY --from=build-stage /usr/local/bin/ttyd /ttydbin/

# We need to add the libjson-c3 and libwebsockets8 libs for ttyd
# We need openssl so we can create certs
# We should have an editor so install vim
# We may also need sudo and ssh 
RUN set -e && \
    apt-get update && \
    apt-get install --no-install-recommends -y \
    libjson-c3 libwebsockets8 openssl vim sudo openssh-client && \
    mkdir /certs && chmod ugo=rwx /certs && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# Copy our scripts
COPY ./scripts/* /bin/

ENV SERVER_CRT="/certs/server.crt"
ENV SERVER_KEY="/certs/server.key"

ENV TTYD_MAX_CONNS=1

ENV TTYD_AUTH_TYPE=""
ENV TTYD_CMD="sudo login"
ENV TTYD_USER=""
ENV TTYD_PASSWD=""
ENV TTYD_SUDOER="N"

EXPOSE 7681

CMD ["ttydsecure"]
