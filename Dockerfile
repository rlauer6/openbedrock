FROM amazonlinux
RUN yum update -y
RUN yum install -y util-linux rpm-build rpm-sign wget expect aws-cli createrepo
ADD .gnupg/* /root/.gnupg/
ADD .rpmmacros /root/
ADD rpm-sign /root/
ADD build-bedrock /root/
ENTRYPOINT ["/root/build-bedrock"]
