FROM ruby:2.6.6

# needed to be able to pull postgresql-client-9.6 below
RUN apt-get install curl ca-certificates gnupg
RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update -qq && apt-get install -y lsb-release
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
    libpq-dev \
    postgresql-client-9.6 \
    build-essential \
    nodejs \
    wget \
  && rm -rf /var/lib/apt/lists/*t

RUN mkdir /sanctuary
COPY Gemfile /sanctuary/
COPY Gemfile.lock /sanctuary/
WORKDIR /sanctuary

# Bundle install
COPY . /sanctuary
RUN gem install bundler && bundle install
RUN rm -rf /sanctuary/tmp/pids/server.pid

EXPOSE 5000