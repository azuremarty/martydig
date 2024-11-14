# MartyDig - a comprehensive tool for querying various DNS and registration records related to a domain.
INSTRUCTIONS 👇 <br><br>
-- LAMP stack with SSH required<br>
-- navigate to your "web root" or "document root"<br>
-- run "git clone https://github.com/azuremarty/martydig"<br>
-- chmod -R +x scripts/ is required or you will get a permissions error :)<br>
-- run "./mdig-web domain.com" from terminal, or use the web form (index.php)

# Features<br>
-Whois Domain Info: Retrieves WHOIS information for the specified domain (Registrar info, nameservers, organization details)<br>

-NS Records: Fetches and displays the NS (Nameserver) records for the domain.<br>

-MX Records: Retrieves MX (Mail Exchange) records for the domain, showing both the mail server hostname and associated IP address.<br>
-Whois for Mail IP Address: Retrieves ARIN information for the IP address of the mail server.<br>

-Propagated A Record: Retrieves and displays the A record (IPv4 address) for the domain and associated PTR record.<br>
-Whois for A Record IP Address: Retrieves ARIN information for the IP address of the domain.<br>

-SPF Records: Retrieves and displays SPF (Sender Policy Framework) records for the domain.<br>
-DMARC Records: Retrieves and displays DMARC records for the domain.<br>

-Google and Microsoft DKIM Records: Retrieves and displays DKIM records for Google and Microsoft services.<br>
-Mailgun DKIM Records: Retrieves and displays DKIM records for Mailgun.<br>
-SendGrid DKIM Records: Retrieves and displays DKIM records for SendGrid.<br>
-Mailchimp DKIM Records: Retrieves and displays DKIM records for Mailchimp.<br>

-Mail.Domain.com A Record: Retrieves and displays the A record for the mail subdomain (mail.domain.com) and associated PTR record.<br>
-Whois for Mail.Domain.com IP Address: Retrieves ARIN information for the IP address of the mail subdomain.

-Autodiscover Records: Retrieves and displays autodiscover records for the domain.<br>
-Whois for Autodiscover IP Address: Retrieves ARIN information for the IP address of the autodiscover subdomain.
