FROM ruby:2.6.1

RUN apt-get update -qq \
	&& apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    wget

RUN wget -qO - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq \
	&& apt-get install -y --no-install-recommends \
  postgresql-client-9.6 \
  && rm -rf /var/lib/apt/lists/*t

RUN mkdir /sanctuary
COPY Gemfile /sanctuary/
COPY Gemfile.lock /sanctuary/
WORKDIR /sanctuary

# Bundle install
RUN gem install bundler && bundle install
COPY . /sanctuary
RUN rm -rf /sanctuary/tmp/pids/server.pid

EXPOSE 5000
