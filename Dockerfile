FROM ruby:2.6.6
RUN apt-get update -y && \
  rm -rf /var/lib/apt/lists/*
RUN mkdir /zaim_api
WORKDIR /zaim_api
COPY ./Gemfile Gemfile
COPY ./Gemfile.lock Gemfile.lock
ENV GEM_HOME=/usr/local/lib/ruby/gems/2.6.0
RUN bundle install
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  echo "Asia/Tokyo" > /etc/timezone
COPY . /zaim_api
CMD ["ruby","webrick.rb"]
