FROM ruby:2.3.1

RUN apt-get -qq update && apt-get install -y build-essential
RUN apt-get install -y libmysqlclient-dev
RUN apt-get install -y libsqlite3-dev

RUN ruby -v
RUN gem install bundler --no-ri --no-rdoc

COPY . .

RUN bundle install

EXPOSE 3001
CMD ["bin/run", "start"]
