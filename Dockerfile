FROM openjdk:8
LABEL maintainer "Apiumhub <dev@apiumhub.com>"
ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="Apiumhub"

ENV ANDROID_HOME "/android-sdk"
ENV ANDROID_COMPILE_SDK "28"
ENV ANDROID_BUILD_TOOLS "28.0.0"
ENV ANDROID_SDK_TOOLS "4333796"
ENV PATH "$PATH:${ANDROID_HOME}/platform-tools"

RUN apt-get update && \
    apt-get -y install \
        git \
        bash \
        curl \
        wget \
        zip \
        unzip \
        ruby \
        ruby-full \
        openssh-client \
        g++ \
        make \
    && rm -rf /tmp/* /var/tmp/*

RUN gem install fastlane -NV
RUN curl -sL firebase.tools | bash

ADD https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip sdk-tools-linux.zip

RUN unzip sdk-tools-linux.zip -d ${ANDROID_HOME} && \
    rm sdk-tools-linux.zip && \
    echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}"
