FROM ruby:3.3.8

RUN gem install rails -v '<8.0'
RUN gem install bundler

WORKDIR /app

# Default to the interactive bash shell
CMD ["/bin/bash"]
