FROM debian:wheezy

MAINTAINER Marc Hoersken "info@marc-hoersken.de"

# Based upon https://i.rationa.li/mark/note/2TWATCchRQGyMA0RlvZSQA
RUN echo "deb-src http://deb.debian.org/debian wheezy main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y autoconf
RUN apt-get build-dep -y apache2

RUN mkdir -p /usr/src
WORKDIR /usr/src

RUN apt-get source apache2
WORKDIR /usr/src/apache2-2.2.22

#ADD apache-2.2.24-wstunnel.patch /tmp/apache-2.2.24-wstunnel.patch
#RUN patch -p1 -i /tmp/apache-2.2.24-wstunnel.patch

ADD 0001-Fixed-r1452911-r1452949-r1452954-r1453022-r1453574-r.patch /tmp/0001-Fixed-r1452911-r1452949-r1452954-r1453022-r1453574-r.patch
RUN patch -p1 -i /tmp/0001-Fixed-r1452911-r1452949-r1452954-r1453022-r1453574-r.patch

ADD 0002-Fixed-r1569615-from-trunk.patch /tmp/0002-Fixed-r1569615-from-trunk.patch
RUN patch -p1 -i /tmp/0002-Fixed-r1569615-from-trunk.patch

ADD 0003-Fixed-r1587036-r1587040-r1587053-r1587654-from-trunk.patch /tmp/0003-Fixed-r1587036-r1587040-r1587053-r1587654-from-trunk.patch
RUN patch -p1 -i /tmp/0003-Fixed-r1587036-r1587040-r1587053-r1587654-from-trunk.patch

ADD 0004-Merge-r1594625-from-trunk.patch /tmp/0004-Merge-r1594625-from-trunk.patch
RUN patch -p1 -i /tmp/0004-Merge-r1594625-from-trunk.patch

ADD 0005-Merge-r1597642-r1608999-r1605207-r1610366-r1610353-r.patch /tmp/0005-Merge-r1597642-r1608999-r1605207-r1610366-r1610353-r.patch
RUN patch -p1 -i /tmp/0005-Merge-r1597642-r1608999-r1605207-r1610366-r1610353-r.patch

ADD 0006-Merge-r1533765-r1621419-r1638159-r1638188-r1601603-r.patch /tmp/0006-Merge-r1533765-r1621419-r1638159-r1638188-r1601603-r.patch
RUN patch -p1 -i /tmp/0006-Merge-r1533765-r1621419-r1638159-r1638188-r1601603-r.patch

ADD 0007-Fixed-r1635644-from-trunk.patch /tmp/0007-Fixed-r1635644-from-trunk.patch
RUN patch -p1 -i /tmp/0007-Fixed-r1635644-from-trunk.patch

ADD 0008-Fixed-r1657636-r1657638-r1669130-from-trunk.patch /tmp/0008-Fixed-r1657636-r1657638-r1669130-from-trunk.patch
RUN patch -p1 -i /tmp/0008-Fixed-r1657636-r1657638-r1669130-from-trunk.patch

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
