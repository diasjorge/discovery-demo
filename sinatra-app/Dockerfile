FROM ruby:2.1.5

RUN gem install sinatra

ADD . /

EXPOSE 4567

ENV RACK_ENV production

CMD ["ruby", "starter.rb"]
