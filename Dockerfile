FROM ruby:3.1.1-alpine

LABEL maintainer="Klaus Meyer <spam@klaus-meyer.net>"

ENV APP_ENV production

RUN apk update \
 && apk add build-base zlib-dev tzdata nodejs openssl-dev \
    avahi avahi-compat-libdns_sd avahi-dev libsodium dbus supervisor \
 && rm -rf /var/cache/apk/*

COPY docker/supervisord.conf /etc/supervisord.conf

WORKDIR /app
ADD . .

RUN addgroup -S app && adduser -S app -G app -h /app \
 && chown -R app.app /app \
 && chown -R app.app /usr/local/bundle

USER app
RUN gem install bundler -v $(tail -n1 Gemfile.lock | xargs) \
 && bundle config set without "development test" \
 && bundle install

USER root
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
