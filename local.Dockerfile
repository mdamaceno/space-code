FROM ruby:3.2.2-slim

RUN apt-get update -qq
RUN apt-get install -y \
    build-essential \
    libpq-dev \
    git \
    shared-mime-info \
    nano

ENV VISUAL=nano

ENV app /app

RUN mkdir $app

WORKDIR $app

RUN gem install bundler

COPY Gemfile /app/

ENV BUNDLE_PATH /box
