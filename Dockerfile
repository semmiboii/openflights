# SPECIFYING THE RUBY VERSION IN .ruby_version and Gemfile
ARG RUBY_VERSION=2.7
FROM ruby:$RUBY_VERSION

#Installing necessary dependencies
ADD https://dl.yarnpkg.com/debian/pubkey.gpg /tmp/yarn-pubkey.gpg
RUN apt-key add /tmp/yarn-pubkey.gpg && rm /tmp/yarn-pubkey.gpg
RUN echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -qq -y --no-install-recommends build-essential libpq-dev curl
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash
RUN apt-get update && apt-get install -qq -y --no-install-recommends nodejs yarn postgresql-client
RUN yarn

ENV RAILS_ENV="production"

#Rails App lives here
WORKDIR /app

# Install application gems
COPY Gemfile Gemfile.lock ./

RUN gem install bundler:2.2.30

RUN bundle install 
RUN bundle exec rails db:create
RUN bundle exec rails db:migrate
RUN rails webpacker:install:react

# Copy application code
COPY . .

EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
