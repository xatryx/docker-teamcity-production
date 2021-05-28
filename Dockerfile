FROM jetbrains/teamcity-agent:2021.1-linux-sudo

MAINTAINER Ronan Harris

ENV GRADLE_HOME=/usr/bin/gradle
ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update
RUN apt-get install -y --allow-downgrades expect git mc gradle unzip wget curl libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5-dev lib32z1
RUN apt-get clean
RUN rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD ./scripts/android-accept-licenses.sh /opt/tools/
ENV PATH ${PATH}:/opt/tools
ENV LICENSE_SCRIPT_PATH /opt/tools/android-accept-licenses.sh

RUN cd /opt && mkdir android-sdk-tools && mkdir android-sdk-tools/cmdline-tools
RUN cd /opt &&  wget --output-document=latest.zip https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip && unzip latest.zip -d android-sdk-tools/cmdline-tools
RUN cd /opt &&  wget --output-document=platform.zip https://dl.google.com/android/repository/platform-tools-latest-linux.zip && unzip platform.zip -d android-sdk-tools
RUN chown -R 0:0 /opt/android-sdk-tools/
RUN rm /opt/latest.zip && rm /opt/platform.zip
RUN mv /opt/android-sdk-tools/cmdline-tools/cmdline-tools/ /opt/android-sdk-tools/cmdline-tools/latest/

ENV ANDROID_SDK_ROOT /opt/android-sdk-tools/
ENV PATH ${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools

RUN yes | sdkmanager --licenses
RUN sdkmanager --update
RUN yes | sdkmanager "build-tools;30.0.3" "platforms;android-28" "platforms;android-29" "platforms;android-30" "ndk-bundle" "ndk;22.1.7171670"
