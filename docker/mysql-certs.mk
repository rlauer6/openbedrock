#-*- mode: makefile; -*-
########################################################################
# MySQL server certificates for Docker
########################################################################
# !! NOTE !!
########################################################################
# Starting with MySQL 8.4 self-signed certificates will be created by
# MySQL if no certificates are installed.  We have a target here
# 'certs' but we're not using them in 'docker-compose.yml' anymore
# because 8.4 will not use our self signed certs.
########################################################################

CA_KEY  = mysql-certs/mysqld-ca-key.pem
KEY     = mysql-certs/mysqld-server-key.pem
CERT    = mysql-certs/mysqld-server-cert.pem
CA_CERT = mysql-certs/mysqld-ca-cert.pem
CSR     = mysql-certs/mysqld-server-req.pem

.PHONY: certs
certs:
	if ! [ "$$(id -u)" = "0" ]; then \
	  echo "ERROR: must be root"; \
	  false; \
	fi
	test -d mysql-certs || mkdir mysql-certs
	chown 999:999 mysql-certs
	openssl genrsa 2048 > $(CA_KEY)
	openssl req -sha1 -new -x509 -nodes -days 3650 -key $(CA_KEY) -subj "/C=FR/ST=/L=/O=mysqld/CN=mysqld-CA" > $(CA_CERT)
	openssl req -sha1 -newkey rsa:2048 -days 3650 -nodes -keyout $(KEY) -subj "/C=FR/ST=/L=/O=mysqld/CN=mysqld-server" > $(CSR)
	openssl rsa -in $(KEY) -out $(KEY)
	openssl x509 -sha1 -req -in $(CSR) -days 3650 -CA $(CA_CERT) -CAkey $(CA_KEY) -set_serial 01 > $(CERT)
	chown 999:999 mysql-certs/*
	chmod 0644 mysql-certs/*.pem
	chmod 0600 mysql-certs/*key*.pem

# -------------------------------------
# MySQL client certificate for Docker
# -------------------------------------
CLIENT_KEY  = mysql-certs-client/mysql-client-key.pem
CLIENT_CSR  = mysql-certs-client/mysql-client-req.pem
CLIENT_CERT = mysql-certs-client/mysql-client-cert.pem

.PHONY: client-cert
client-cert: certs
	test -d mysql-client-cert || mkdir mysql-client-cert
	openssl req -sha1 -newkey rsa:2048 -days 3650 -nodes -keyout $(CLIENT_KEY) > $(CLIENT_CSR) -subj "/C=FR/ST=/L=/O=mysql-client/CN=mysql-client"
	openssl rsa -in $(CLIENT_KEY) -out $(CLIENT_KEY)
	openssl x509 -sha1 -req -in $(CLIENT_CSR) -days 3650 -CA $(CA_CERT) \
                -CAkey $(CA_KEY) -set_serial 01 > $(CLIENT_CERT)
