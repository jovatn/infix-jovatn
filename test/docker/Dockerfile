FROM alpine:3.18.0

RUN apk add --no-cache \
    gcc \
    iproute2 \
    iputils \
    libc-dev \
    libyang-dev \
    python3-dev \
    qemu-system-x86_64

COPY qemu-ifup /etc
