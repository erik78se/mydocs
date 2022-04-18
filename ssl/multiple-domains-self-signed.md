# Configuring ssl requests(CSR) including multiple alias with openssl

## Generate the Certificate Request File
For a generic SSL certificate request (CSR), openssl doesn’t require much fiddling. Since we’re going to add a SAN or two to our CSR, we’ll need to add a few things to the openssl conf file. You need to tell openssl to create a CSR that includes x509 V3 extensions and you also need to tell openssl to include a list of subject alternative names in your CSR.

Create an openssl configuration file which enables subject alternative names (openssl.cnf):

In the [req] section. This is the section that tells openssl what to do with certificate requests (CSRs).
Within that section should be a line that begins with req_extensions. We’ll want that to read as follows:

    [req]
    distinguished_name = req_distinguished_name
    req_extensions = v3_req
    This tells openssl to include the v3_req section in CSRs.

Now we’ll go own down to the v3_req section and make sure that it includes the following:


    [req_distinguished_name]
    countryName = Country Name (2 letter code)
    countryName_default = US
    stateOrProvinceName = State or Province Name (full name)
    stateOrProvinceName_default = MN
    localityName = Locality Name (eg, city)
    localityName_default = Minneapolis
    organizationalUnitName	= Organizational Unit Name (eg, section)
    organizationalUnitName_default	= Domain Control Validated
    commonName = Internet Widgits Ltd
    commonName_max	= 64

    [ v3_req ]
    # Extensions to add to a certificate request
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    subjectAltName = @alt_names

    [alt_names]
    DNS.1 = dns.example.com
    DNS.2 = myname.example.org
    DNS.3 = secondname.example.net
    IP.1 = 192.168.1.5
    IP.2 = 192.168.69.12
    
Note that whatever we put here will appear on all CSRs generated from this point on: if at a later date you want to generate a CSR with different SANs, you’ll need to edit this file and change the DNS.x entries.

## Generate a private key
You’ll need to make sure your server has a private key created:

    openssl genrsa -out dns_example_com.key 2048

Where doman is the FQDN of the server you’re using. That’s not necessary, BTW, but it makes things a lot clearer later on.

## Create the CSR file

Then the CSR is generated using:

    openssl req -new -out dns_example_com.csr -key dns_example_com.key -config openssl.cnf

or

    openssl req -new -newkey rsa:2048 -keyout hostname_key.pem -nodes -out hostname_csr.pem

Explanation of the command line options:

-new – generate a new CSR
-newkey rsa:2048– generate a new private key of type RSA of length 2048 bytes. If you had previously generated a private RSA key (by using the “openssl genrsa” command, for example) and would like to use it rather than generating a new key, you can use the -key FILENAME option to read in your existing key.
-keyout hostname_key.pem – write out the newly generated RSA private key to the file hostname_key.pem. You will need to save this file since it’s required when you generate the SSL certificate.
-nodes – an optional parameter NOT to encrypt the private key. This is useful when your web server starts automatically, at boot time. If your private key is encrypted, you would be required to enter a password every time your web server restarted. You could also omit this option to create an encrypted key and then later remove the encryption from the key.
-out hostname_csr.pem – write out the CSR to the file hostname_csr.pem. This is the file you will submit to Accenture CA.

You’ll be prompted for information about your organization, and it’ll ask if you want to include a passphrase (you don’t). It’ll then finish with nothing much in the way of feedback. But you can see that san_domain_com.csr has been created.

It’s nice to check our work, so we can take a look at what the csr contains with the following command:

    openssl req -text -noout -in dns_example_com.csr
    
You should see some output like below. Note the Subject Alternative Name section:

    Certificate Request:
    Data:
    Version: 0 (0x0)
    Subject: C=US, ST=Texas, L=Fort Worth, O=My Company, OU=My Department, CN=server.example
    Subject Public Key Info: Public Key Algorithm: rsaEncryption RSA Public Key: (2048 bit)
    Modulus (2048 bit): blahblahblah
    Exponent: 65537 (0x10001)
    Attributes:
    Requested Extensions: X509v3
    Basic Constraints: CA:FALSE
    X509v3 Key Usage: Digital Signature, Non Repudiation, Key Encipherment
    X509v3 Subject Alternative Name: DNS:dns.example.com, DNS:myname.example.org , DNS:secondname.example.net Address:192.168.1.5
    Signature Algorithm: sha1WithRSAEncryption
    blahblahblah

So now we’ve got a shiny new CSR. But, of course, we have to sign it.

Self-sign and create the certificate:

    openssl x509 -req -days 3650 -in dns_example_com.csr -signkey dns_example_com.key -out dns_example_com.crt-extensions v3_req -extfile openssl.cnf

Package the key and cert in a PKCS12 file:
The easiest way to install this into IIS is to first use openssl’s pkcs12 command to export both the private key and the certificate into a pkcs12 file:

    openssl pkcs12 -export -in dns_example_com.crt -inkey dns_example_com.key -out dns_example_com.p12

How to determine the Key length?

    openssl rsa -in private.key -text -noout

The top line of the output will display the key size.

For example:

Private-Key: (2048 bit)
To view the key size from a certificate:

    openssl x509 -in public.pem -text -noout | grep "RSA Public Key"
    
RSA Public Key: (2048 bit)
