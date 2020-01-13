FROM anapsix/alpine-java:8_jdk

LABEL maintainer "E&Y"

ARG VCS_REF

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="E&Y"

ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"

ENV ANDROID_HOME "/android-sdk"
ENV ANDROID_COMPILE_SDK "28"
ENV ANDROID_BUILD_TOOLS "28.0.0"

ENV PATH "$PATH:${ANDROID_HOME}/platform-tools"

RUN apk update && \
    apk add --no-cache \
        git \
        bash \
        curl \
        wget \
        zip \
        unzip \
        ruby \
        ruby-rdoc \
        ruby-irb \
        ruby-dev \
        openssh \
        g++ \
        make \
        ca-certificates \
        wget \
    && rm -rf /tmp/* /var/tmp/*

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-2.26-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-bin-2.26-r0.apk
RUN wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.26-r0/glibc-i18n-2.26-r0.apk

RUN apk add glibc-2.26-r0.apk \
    glibc-bin-2.26-r0.apk \
    glibc-i18n-2.26-r0.apk

RUN /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8

RUN curl -sL firebase.tools | sed 's#sudo##g' | bash

RUN gem install fastlane -NV bundler:1.17.2 json:2.3.0 fastlane-plugin-firebase_app_distribution:0.1.4

ADD https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip sdk-tools-linux.zip

RUN unzip sdk-tools-linux.zip -d ${ANDROID_HOME} && \
    rm sdk-tools-linux.zip && \
    echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}"
