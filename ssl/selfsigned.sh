#!/bin/sh
#
# First argument: email address
#
# Generate self signed certs for hostname -f
#
# Generate self signed root CA cert

_email=$1
_hostname=`hostname -f`

openssl req -nodes -x509 -newkey rsa:2048 -keyout ${_hostname}_CA.key -out ${_hostname}_CA.crt -subj "/C=SE/ST=STO/L=Stockholm/O=haproxy/OU=root/CN=${_hostname}/emailAddress=${_email}"

# Generate server cert to be signed
openssl req -nodes -newkey rsa:2048 -keyout ${_hostname}_server.key -out ${_hostname}_server.csr -subj "/C=SE/ST=STO/L=Stockholm/O=haproxy/OU=server/CN=${_hostname}/emailAddress=${_email}"

# Sign the server cert
openssl x509 -req -in ${_hostname}_server.csr -CA ${_hostname}_CA.crt -CAkey ${_hostname}_CA.key -CAcreateserial -out ${_hostname}_server.crt

# Create server PEM file
cat ${_hostname}_server.key ${_hostname}_server.crt > ${_hostname}_server.pem

# Generate client cert to be signed
openssl req -nodes -newkey rsa:2048 -keyout ${_hostname}_client.key -out ${_hostname}_client.csr -subj "/C=SE/ST=STO/L=Stockholm/O=haproxy/OU=client/CN=${_hostname}/emailAddress=${_email}"

# Sign the client cert
openssl x509 -req -in ${_hostname}_client.csr -CA ${_hostname}_CA.crt -CAkey ${_hostname}_CA.key -CAserial ${_hostname}_CA.srl -out ${_hostname}_client.crt

# Create client PEM file
cat ${_hostname}_client.key ${_hostname}_client.crt > ${_hostname}_client.pem

# Create clientPFX file (for Java, C#, etc)
# openssl pkcs12 -inkey ${_hostname}_client.key -in ${_hostname}_client.crt -export -out ${_hostname}_client.pfx

printf "Server cert: %s \n" ${_hostname}_server.crt
printf "Server pem: %s \n" ${_hostname}_server.pem
printf "Client cert: %s \n" ${_hostname}_client.crt
printf "Client pem %s \n" ${_hostname}_client.pem
