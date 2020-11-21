FROM ruby:2.6.6
RUN apt-get update -y && \
  rm -rf /var/lib/apt/lists/*
RUN mkdir /zaim_api
WORKDIR /zaim_api
COPY ./Gemfile Gemfile
COPY ./Gemfile.lock Gemfile.lock
RUN bundle install
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
  echo "Asia/Tokyo" > /etc/timezone
COPY . /zaim_api
CMD ["bash"]
