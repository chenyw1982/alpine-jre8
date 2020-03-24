FROM alpine:3.10
MAINTAINER vincent

#Helpful utils, but only sudo is required
# 设置编码
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV  GLIBC_VERSION=2.23-r4 


# update aliyun repositories
RUN echo http://mirrors.aliyun.com/alpine/v3.10/main/ > /etc/apk/repositories && \
    echo http://mirrors.aliyun.com/alpine/v3.10/community/ >> /etc/apk/repositories
RUN apk update && apk upgrade

# 设置时区
RUN apk --update add curl bash tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata  

COPY glibc-2.29-r0.apk /usr/local/
COPY glibc-bin-2.29-r0.apk /usr/local/
COPY glibc-i18n-2.29-r0.apk /usr/local/

#JRE 8 安装
ADD jre-8u241-linux-x64.tar.gz /usr/local/

RUN set -ex \
    && cd /usr/local/ \
    && apk --no-cache add ca-certificates wget \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && apk add glibc-2.29-r0.apk glibc-bin-2.29-r0.apk glibc-i18n-2.29-r0.apk \
    && rm -rf /var/cache/apk/* glibc-2.29-r0.apk glibc-bin-2.29-r0.apk glibc-i18n-2.29-r0.apk

# SET 
ENV JAVA_HOME /usr/local/jre1.8.0_241
ENV CLASSPATH $JAVA_HOME/bin
ENV PATH .:$JAVA_HOME/bin:$PATH

# run container with base path:/
WORKDIR /

# Should we only provide an entry point to Java?
CMD ["/bin/sh"]
