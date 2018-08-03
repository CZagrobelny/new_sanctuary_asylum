FROM ruby:2.3.5

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

RUN mkdir /tmp/sanctuary
COPY Gemfile /tmp/sanctuary/
COPY Gemfile.lock /tmp/sanctuary/
WORKDIR /tmp/sanctuary

# Bundle install
RUN gem install bundler && bundle install
COPY . /tmp/sanctuary

EXPOSE 5000
