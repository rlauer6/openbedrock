FROM debian:bookworm

RUN apt-get update && apt-get install -y \
  gcc make perl less vim curl libexpat-dev

RUN curl -L https://cpanmin.us | perl - App::cpanminus

COPY Bedrock-Core*.tar.gz /

RUN cpanm -v --installdeps Bedrock-Core*.tar.gz

RUN cpanm -v Bedrock-Core*.tar.gz

RUN rm -rf /root/.cpanm/work

RUN echo '<trace --output $env>' | bedrock
