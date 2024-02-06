FROM amazonlinux:2

COPY package.lst .
RUN amazon-linux-extras install -y epel
RUN yum install -y $(cat package.lst)

RUN curl -L https://cpanmin.us | perl - App::cpanminus
RUN cpanm -v ExtUtils::MakeMaker

COPY Bedrock-Model-3.2.0.tar.gz .
RUN cpanm -v Bedrock-Model-3.2.0.tar.gz
COPY connect-db /usr/local/bin
RUN chmod +x /usr/local/bin/connect-db
COPY test-model.pl /usr/local/bin
RUN chmod +x /usr/local/bin/test-model.pl
