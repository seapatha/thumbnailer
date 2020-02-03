FROM ruby:2.5.3
WORKDIR /thumbnailer
ADD . /thumbnailer
RUN bundle update
RUN bundle install --standalone --clean
EXPOSE 80
ENTRYPOINT ["bundle", "exec", "ruby", "app.rb"]
