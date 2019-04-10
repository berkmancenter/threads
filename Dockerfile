FROM ruby:2.4.1-alpine

RUN apk update && apk add build-base nodejs postgresql-dev tzdata git sqlite \
    sqlite-dev && gem install mailcatcher --no-ri --no-rdoc

RUN mkdir /app
WORKDIR /app

COPY . .
RUN bundle install

CMD (sidekiq --concurrency 2 &) && puma -C config/puma.rb
