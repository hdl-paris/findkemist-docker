# Base image:
FROM ruby:2.3.3

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs npm locales

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN export LANG=en_US.UTF-8
RUN export LC_ALL=en_US.UTF-8

RUN ln -s /usr/bin/nodejs /usr/bin/node

# Set an environment variable where the Rails app is installed to inside of Docker image:
ENV RAILS_ROOT /var/www/findkemist
RUN mkdir -p $RAILS_ROOT

# Set working directory, where the commands will be ran:
WORKDIR $RAILS_ROOT

ENV BUNDLE_JOBS=2
ENV BUNDLE_PATH=/usr/local/bundle

COPY ./findkemist/Gemfile Gemfile
COPY ./findkemist/Gemfile.lock Gemfile.lock
COPY ./findkemist/config/puma.rb config/puma.rb
RUN gem install bundler
RUN bundle install

# Copy the main application.
COPY ./findkemist .

EXPOSE 3000

CMD bundle exec puma -C config/puma.rb
