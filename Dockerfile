FROM ruby:2.3.1-slim

RUN apt-get -qq update && apt-get install -y build-essential
RUN apt-get install -y libmysqlclient-dev

RUN ruby -v
RUN gem install bundler --no-ri --no-rdoc

COPY . .

RUN bundle install --without development test

EXPOSE 3001
CMD ["bin/cmd", "migrate", "&&", "bin/cmd", "serve"]
