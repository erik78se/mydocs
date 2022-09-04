# DNS with bahnhof sites
This will work with bahnhof in sweden. Your mail-provider needs different settings for the SPF record in the DNS. Ask them.

## Setup your DNS:

Assuming your DNS domain: example.com

- Create a DNS record: "mail.example.com" (CNAME seems to work)
- Create a MX record: "@ mail.example.com"
- Create a TXT record: "v=spf1 mx a:ste-pvt-msa1.bahnhof.se a:ste-pvt-msa2.bahnhof.se a:pio-pvt-msa1.bahnhof.se a:pio-pvt-msa2.bahnhof.se a:pio-pvt-msa3.bahnhof.se -all"

## Test the SPF settings

Test the SPF entries so that it works: https://dmarcian.com/spf-survey/

    dig +short example.com txt

## Configure the ssmtp client.

- Configure ssmtp.conf as descrimed in this repo.

Send a mail to  your address (should not end up in SPAM):

    ssmtp your.address@whatever.com < somemail.txt

## Trouble shooting

Test that your mail is good here (3 per day is free): https://www.mail-tester.com/
