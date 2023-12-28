FROM amazonlinux:2

ADD bedrock.repo /etc/yum.repos.d/bedrock.repo
ADD perl-aws.repo /etc/yum.repos.d/perl-aws.repo
RUN amazon-linux-extras install epel -y

# Perl dependencies
RUN yum install -y perl-core

# Apache
RUN yum install -y httpd mod_perl

# Bedrock
RUN yum install -y openbedrock bedrock-mysql-session bedrock-redis-session \
    bedrock-utils mariadb 'perl(IPC::Shareable)'

# Extras
RUN yum install -y less tree gcc procps curl make iputils

# cpanm
RUN curl -L https://cpanmin.us | perl - App::cpanminus

# these files will be replaced with versions in the docker directory
RUN rm -f /usr/lib/bedrock/config.d/startup/mysql-session.xml
RUN rm -f /usr/lib/bedrock/config/mysql-session.xml
RUN rm -f /usr/lib/bedrock/config/tagx.xml
RUN rm -f /etc/httpd/conf.d/perl_bedrock.conf

# cleanup 
RUN yum clean all && rm -rf /var/cache/yum

CMD bedrock-cache.pl --create && bedrock-cache.pl --list && /usr/sbin/apachectl -D FOREGROUND
