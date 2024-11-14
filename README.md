# MartyDig - a comprehensive tool for querying various DNS and registration records related to a domain.
INSTRUCTIONS 👇 <br><br>
Place index.php file in web root directory<br>
Copy mdig.sh into scripts directory (usr/local/bin is default)<br>
Update filepath references to mdig.sh within index.php if needed<br>
run ./mdig.sh domain.com -- or use the web page tool :)

# Features<br>
-Whois Domain Info: Retrieves WHOIS information for the specified domain (Registrar info, nameservers, organization details)

-NS Records: Fetches and displays the NS (Nameserver) records for the domain.

-MX Records: Retrieves MX (Mail Exchange) records for the domain, showing both the mail server hostname and associated IP address.
-Whois for Mail IP Address: Retrieves ARIN information for the IP address of the mail server.

-Propagated A Record: Retrieves and displays the A record (IPv4 address) for the domain and associated PTR record.
-Whois for A Record IP Address: Retrieves ARIN information for the IP address of the domain.

-SPF Records: Retrieves and displays SPF (Sender Policy Framework) records for the domain.

-DMARC Records: Retrieves and displays DMARC records for the domain.

-Google and Microsoft DKIM Records: Retrieves and displays DKIM records for Google and Microsoft services.
-Mailgun DKIM Records: Retrieves and displays DKIM records for Mailgun.
-SendGrid DKIM Records: Retrieves and displays DKIM records for SendGrid.
-Mailchimp DKIM Records: Retrieves and displays DKIM records for Mailchimp.

-Mail.Domain.com A Record: Retrieves and displays the A record for the mail subdomain (mail.domain.com) and associated PTR record.
-Whois for Mail.Domain.com IP Address: Retrieves ARIN information for the IP address of the mail subdomain.

-Autodiscover Records: Retrieves and displays autodiscover records for the domain.
-Whois for Autodiscover IP Address: Retrieves ARIN information for the IP address of the autodiscover subdomain.
