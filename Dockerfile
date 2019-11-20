FROM ruby:2.6.2
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