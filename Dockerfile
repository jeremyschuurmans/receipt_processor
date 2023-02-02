FROM ruby:3.2.0

ADD . /receipt_processor
WORKDIR /receipt_processor
RUN bundle install

ENV RAILS_ENV development

EXPOSE 3000
CMD ["bash"]