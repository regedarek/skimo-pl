FROM ruby:2.7 
MAINTAINER maintainer@example.com

RUN groupadd -g 61000 docker
RUN useradd -g 61000 -l -M -s /bin/false -u 61000 docker

ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH

# nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn

# rails
RUN gem install rails bundler
COPY skimo-pl/Gemfile Gemfile
WORKDIR /opt/app/skimo-pl
RUN bundle install

RUN chown -R docker:docker /opt/app
USER docker
VOLUME ["$INSTALL_PATH/public"]
CMD bundle exec unicorn -c config/unicorn.rb
