FROM debian:wheezy

MAINTAINER Marc Hoersken "info@marc-hoersken.de"

# Based upon https://i.rationa.li/mark/note/2TWATCchRQGyMA0RlvZSQA
RUN echo "deb-src http://http.debian.net/debian wheezy main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y autoconf
RUN apt-get build-dep -y apache2

RUN mkdir -p /usr/src
WORKDIR /usr/src

RUN apt-get source apache2
WORKDIR /usr/src/apache2-2.2.22

ADD apache-2.2.24-wstunnel.patch /tmp/apache-2.2.24-wstunnel.patch
RUN patch -p1 -i /tmp/apache-2.2.24-wstunnel.patch

RUN autoconf

RUN ./configure --enable-so \
                --enable-proxy=shared \
                --enable-proxy-connect=shared \
                --enable-proxy-http=shared \
                --enable-proxy-wstunnel=shared

RUN make

RUN mkdir -p /usr/local/lib/apache2/modules
RUN cp modules/proxy/.libs/mod_proxy*.so /usr/local/lib/apache2/modules

ADD installer /tmp/installer
CMD /tmp/installer
