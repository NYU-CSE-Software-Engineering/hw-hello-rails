FROM ruby:3.3.8

RUN gem install rails
RUN gem install bundler

WORKDIR /app

# Default to the interactive bash shell
CMD ["/bin/bash"]
