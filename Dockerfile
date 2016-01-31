FROM ruby:2.1-slim
MAINTAINER Roger Ignazio <me@rogerignazio.com>

ENV WAYLON_HOME /usr/local/waylon
WORKDIR $WAYLON_HOME
COPY . ${WAYLON_HOME}/

RUN apt-get update
RUN apt-get install -y build-essential libsasl2-dev memcached
RUN bundle install --path vendor/

EXPOSE 8080
CMD curl -Lo config/waylon.yml ${WAYLON_CONFIG} && bundle exec foreman start -f Procfile.docker
