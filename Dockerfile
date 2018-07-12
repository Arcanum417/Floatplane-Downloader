FROM alpine
LABEL maintainer="rob1998"

# Env variables
ENV CONFIG_PATH="/config"
ENV USERNAME="$USERNAME"
ENV PASSWORD="$PASSWORD"
ENV MEDIA_PATH="/media/floatplane/"
ENV UID=991
ENV GID=991

# Copy files
COPY rootfs /

# Install some required packages
RUN apk add -U build-base \
				libssl1.0 \
				curl \
				git \
				nodejs-npm \
				su-exec \
				s6 \
				python \
				nodejs \
				nodejs-npm \
		# Create dir and clone Floatplane-Downloader
		&& mkdir -p /opt \
		&& cd /opt \
		&& git clone https://github.com/rob1998/Floatplane-Downloader.git \
		# Copy settings example to settings
		&& cd Floatplane-Downloader \
		# Install
		&& npm install \
		# Set permissions
		&& chmod a+x /usr/local/bin/* /etc/s6.d/*/* \
		# Cleanup
		&& apk del build-base \
		&& rm -rf /tmp/* /var/cache/apk/*

RUN apk add --no-cache ffmpeg

# Add config path volume
VOLUME /config

# Execute run.sh script
CMD ["run.sh"]
