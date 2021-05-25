FROM jetbrains/teamcity-agent:2021.1-linux-sudo

MAINTAINER Ronan Harris

ENV GRADLE_HOME=/usr/bin/gradle
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y --allow-downgrades expect git mc gradle unzip wget curl libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5-dev lib32z1
RUN apt-get clean
RUN rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./scripts/android-accept-licenses.sh /opt/tools/
ENV PATH ${PATH}:/opt/tools
ENV LICENSE_SCRIPT_PATH /opt/tools/android-accept-licenses.sh

RUN cd /opt && wget --output-document=android-tools.zip \
    https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip android-tools.zip -d android-sdk-linux && \
    chown -R root.root android-sdk-linux

ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

RUN yes | sdkmanager --licenses
RUN sdkmanager --update
RUN yes | sdkmanager "build-tools;30.0.3" "platforms;android-28" "platforms;android-29" "platforms;android-30" "ndk-bundle" "ndk;22.1.7171670"
