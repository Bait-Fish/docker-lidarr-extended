FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-aarch64.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM linuxserver/lidarr:arm64v8-nightly
LABEL maintainer="RandomNinjaAtk"

ENV dockerTitle="lidarr-extended"
ENV dockerVersion="1.0.141"
ENV LANG=en_US.UTF-8
ENV autoStart=true
ENV configureLidarrWithOptimalSettings=false
ENV audioFormat=native
ENV audioBitrate=lossless
ENV audioLyricType=both
ENV addDeezerTopArtists=false
ENV addDeezerTopAlbumArtists=false
ENV addDeezerTopTrackArtists=false
ENV topLimit=10
ENV addRelatedArtists=false
ENV tidalCountryCode=US
ENV numberOfRelatedArtistsToAddPerArtist=5
ENV beetsMatchPercentage=90

RUN \
	echo "*** install packages ***" && \
	apk add -U --upgrade --no-cache \
		flac \
		beets \
		jq \
		ffmpeg \
		python3 \
		py3-pip \
		gcc \
		libc-dev \
		yt-dlp && \
	echo "*** install python packages ***" && \
	pip3 install --upgrade \
		yq \
		pyacoustid \
		deemix

# copy local files
COPY root/ /

WORKDIR /config

# ports and volumes
EXPOSE 8686
VOLUME /config /music /music-videos /downloads
