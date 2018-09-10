FROM jruby:9.1.17-alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle install

ADD . /usr/src/app
#RUN rake test # TODO: no tests right now

CMD ["ruby", "app.rb", "-h"]
