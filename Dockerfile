FROM alpine
LABEL maintainer="rob1998"

ENV TOKEN="didNotSetTokenGoBackAndSetTheTokenEnvironmentVariable"
ENV USERNAME=""
ENV PASSWORD=""
ENV CONSOLE_LOG=1

COPY ./ /app/

RUN apk add --no-cache build-base \
        libssl1.0 \
        curl \
        git \
        nodejs-npm \
        su-exec \
        python \
        nodejs \
        nodejs-npm \
    && cd /app \
    && npm install

VOLUME /config
WORKDIR /app
CMD ["npm", "start", "${USERNAME}", "${PASSWORD}"]
