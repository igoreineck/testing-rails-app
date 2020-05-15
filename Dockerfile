FROM ruby:2.5
RUN apt update -qq && apt install -y nodejs postgresql-client
RUN mkdir /testing-app
WORKDIR /testing-app
COPY Gemfile /testing-app/Gemfile
COPY Gemfile.lock /testing-app/Gemfile.lock
RUN bundle install
COPY . /testing-app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "127.0.0.1"]
