
FROM amazonlinux:2

ADD bedrock.repo /etc/yum.repos.d/bedrock.repo
ADD perl-aws.repo /etc/yum.repos.d/perl-aws.repo
RUN amazon-linux-extras install epel -y

# Perl dependencies
RUN yum install -y perl-core less tree gcc

# Apache
RUN yum install -y httpd mod_perl

# Bedrock
RUN yum install -y openbedrock bedrock-mysql-session bedrock-redis-session \
    bedrock-utils mariadb 'perl(IPC::Shareable)'

RUN rm /usr/lib/bedrock/config.d/startup/mysql-session.xml
RUN rm /usr/lib/bedrock/config/mysql-session.xml

# cleanup 
RUN yum clean all && rm -rf /var/cache/yum
# CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
CMD bedrock-cache.pl --create && bedrock-cache.pl --list && /usr/sbin/apachectl -D FOREGROUND
