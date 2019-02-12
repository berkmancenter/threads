FROM ruby:2.4.5-alpine

RUN apk update && apk add build-base nodejs postgresql-dev tzdata git

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .

CMD puma -C config/puma.rb
