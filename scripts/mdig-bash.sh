clear
COLOR='\033[1;33m'
BOLD='\033[1;37m'
NC='\033[0m' # No Color
RED='\033[1;31m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
GREY='\033[1;30m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
#============== TOP-LEVEL DOMAIN A-RECORD ===========================
IP=$( dig $1 +short | grep [0-9][0-9] | sort -nr | head -n 1 )
PTR=$( dig -x $IP +short | grep -v "in-addr" | grep -v "Truncated" | head -n 1)
#=================== MAIL.DOMAIN.COM SUBDOMAIN ========================
MAILSUBIP=$( dig mail.$1 +short | grep [0-9][0-9] | sort -nr | head -n 1 ) 
MAILSUBPTR=$( dig -x $MAILSUBIP +short | grep -Ev 'in-addr|Truncated' | head -n 1) 
#===============  DMARC RECORD  ==========================
DMARCRECORD=$(dig _dmarc.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort)
SPFRECORD=$(dig $1 txt +short | grep -E -v '\.root-servers\.net|Truncated' | grep 'v=spf1')
#===============  MX RECORD HOSTNAME ================================
MAILMX=$( dig mx $1 +short | grep -v ".root-servers.net" | grep -v "CNAME" | sort -n | head -n 1 )
MAILMXLONG=$( dig mx $1 +short | grep -v ".root-servers.net" | sort -nr )
#================  MX RECORD IP ADDRESS INFO  ==================== 
MAILIP=$( dig $MAILMX +short | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -n 1 )
MAILPTR=$( dig -x $MAILIP +short | grep -v "in-addr" | head -n 1 )
#==============  AUTODISCOVER  =============================
ADRECORD=$( dig autodiscover.$1 +nostats +noquestion +nocomments | grep IN | grep -v SOA | grep -v "RedHat" | grep -v ".root-servers.net" | grep -v "autodiscover.geo.outlook.com" | grep -v "autodiscover.outlook.com.g.outlook.com" | grep -v "autodiscover.geo.outlook.com" | grep -v "autodiscover-namcentral" | head -n 6 )
ADIP=$( dig autodiscover.$1 +short | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -n 1 )
#==============  GOOGLE + MICROSOFT DKIM KEYS  ========================== 
GOOGLEDKIM=$( dig google._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort)
MSDKIM1=$( dig selector1._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort)
MSDKIM2=$(dig selector2._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort)
#============== MAILGUN DKIMS ========================== 
MAILGUNDKIMSMTP=$( dig smtp._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort -r)
MAILGUNDKIMKRS=$( dig krs._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort -r)
MAILGUNDKIMMAILO=$( dig mailo._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort -r)
#============== SENDGRID DKIMS ========================== 
SENDGRIDDKIMS1=$( dig s1._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort)
SENDGRIDDKIMS2=$( dig s2._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort)
#============== MAILCHIMP DKIMS ========================== 
MAILCHIMPDKIMK2=$( dig k2._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort -r)
MAILCHIMPDKIMK3=$( dig k3._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort -r)
#============== KLAVIYO DKIMS ========================== 
KLAVIYODKIMKL=$( dig kl._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort -r)
KLAVIYODKIMKL2=$( dig kl2._domainkey.$1 txt +nostats +noquestion +nocomments | grep -E 'IN.*(CNAME|TXT)' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net' | sort -r)
#========================================
echo -e "${BLUE}|${BOLD}    __  ______    ____  ________  ______  __________    _    _____ ${BLUE}|${NC}"
echo -e "${BLUE}|${BOLD}   /  |/  /   |  / __ \/_  __/\ \/ / __ \/  _/ ____/   | |  / /__ |${BLUE}|${NC}"
echo -e "${BLUE}|${BOLD}  / /|_/ / /| | / /_/ / / /    \  / / / // // / _______| | / /__/ /${BLUE}|${NC}"
echo -e "${BLUE}|${BOLD} / /  / / ___ |/ _, _/ / /     / / /_/ // // /_/ /_____/ |/ // __/ ${BLUE}|${NC}"
echo -e "${BLUE}|${BOLD}/_/  /_/_/  |_/_/ |_| /_/     /_/_____/___/\____/      |___//____/ ${BLUE}|${NC}"
echo -e "${BLUE} ___________________________________________________________________${NC}"   
echo -e "${BLUE}[#] whois $1 (REGISTRAR INFO) ${NC}"
#=================================================================
#===============  WHOIS DOMAIN  ===================================
#==================================================================

echo -e ""

whois "$1" |
egrep -i "(Server|Nameserver:|Registrar:|Registrar URL|Organization:|Admin|Comment:|Email|nameservers:|Hold|Expiration|Expiry|Reseller|URL:|Transfer|Name:|No match|NS[1-4]|NOT FOUND|abuse-mailbox:|Name servers:|NET)" |
grep -vE "(created|updated|The data in|information purposes only|makes this information available|that apply to|prior written consent|BRST|This server accepts|reserves the right|clientTransferProhibited|modify existing registrations|support questions|Redirected|Querying|\[whois\.|follow the instructions|Unconditional Guarantee|reserves the right|Billing|Registrar Abuse Contact Email|dest IP \(your IP\)|Intensity/frequency|Without these|NetName:|Domain Name:|Tech|NOCEmail|Administrative Contact Postal Code|Administrative Contact Phone Number|Administrative Contact Facsimile Number|Administrative Contact ID|Administrative Contact Address|Administrative Contact City|Administrative Contact Country|Administrative Contact State/Province|Administrative Contact Country Code|Admin Phone Ext|Admin Fax|Domain ID:|Admin Fax Ext|Admin Phone|Admin Country|Invalid option:|Admin Postal Code|Admin State/Province|Admin City|Admin Street|Admin ID|Registry Admin ID|has collected this|Last Transferred Date:|Administrative Application Purpose:|Administrative Nexus Category:|Parent|NetHandle:|Ref:|StateProv:|WHOIS Server:|Please register your domains|network:In-Addr-Server;|network:Network-Name:|Comments to|network:Tech-Contact;|OrgNOCName:|global Web hosting|DreamHost is|websites and apps hosted|Dedicated Server Hosting|high-value domains|DreamCompute|contains ONLY .COM|for more information|Connection refused|Withheld for Privacy|Redacted for Privacy|URL of the ICANN WHOIS)" |
awk '!x[$0]++' |
sed -e 's/^[ \t]*//'

#========================================================================
#=========================== NS RECORDS ===============================
#=======================================================================

echo -e "${GREEN}________________________________________________${NC}"
echo -e "${GREEN}[#] dig $1 ns (PROPAGATED NS RECORD) ${NC}"
echo -e ""

dig $1 ns +nostats +noquestion +nocomments | grep -E 'IN.*NS' | grep -Ev 'SOA|RedHat|AAAA|.root-servers.net'

#======================================================================
#=========================== MX RECORDS ===============================
#=======================================================================

echo -e "${RED}________________________________________________${NC}"
echo -e "${RED}[#] dig $1 mx (MX RECORD) ${NC}"
echo -e ""

if [[ ! -z $MAILMX  ]] #Checks to see if there is an MX record propagated
	then
		printf "$MAILMXLONG"
	else
		:
	fi
if [[ ! -z $MAILIP  ]] #Checks to see what IP the MX record resolves to, if any.
	then
		echo -e " ${RED}=>${NC} $MAILIP ${RED}=>${NC} $MAILPTR"
	else
		echo -e ""
	fi
	
#======================================================================
#===============  WHOIS mail IP ADDRESS  ===================================
#======================================================================

echo -e ""
echo -e "${RED}[#] whois ${MAILIP} (MX RECORD IP INFO) ${NC}"
echo -e ""

if [[ ! -z $MAILIP  ]] #Checks to SEE THE IP INFO FOR THE TOP MX RECORD
	then
		curl --max-time 5 -s "https://rdap.arin.net/registry/ip/$MAILIP" | jq |
		grep -E 'abuse@|netops@|support@|name' | grep -v 'please' | grep -v "*" |
		sed -e 's/^[ \t]*//' | sort | uniq
		
	else
		:
	fi

#=================================================================
#===============  PROPAGATED A RECORD  ============================
#==================================================================

echo -e "${COLOR}________________________________________________${NC}"
echo -e "${COLOR}[#] dig $1 (WEBSITE/TLD) ${NC}"
echo -e ""

if [[ ! -z $IP  ]] #Checks to see if there is an A record propagated.
	then
		printf "$IP"
	else
		:
	fi
if [[ ! -z $PTR  ]] #Checks to see if the A record IP has a PTR record.
	then
		echo -e " ${COLOR}=>${NC} $PTR"
	else
		echo -e ""
	fi

#======================================================================
#===============  WHOIS IP ADDRESS  ===================================
#======================================================================

echo -e ""
echo -e "${COLOR}[#] whois ${IP} (A RECORD IP INFO) ${NC}"
echo -e ""

if [[ ! -z $IP  ]] #Checks to see if there is an A record propagated for the given domain.
	then
		curl --max-time 5 -s "https://rdap.arin.net/registry/ip/$IP" | jq |
		grep -E 'abuse@|netops@|support@|name' | grep -v 'please' | grep -v "*" |
		sed -e 's/^[ \t]*//' | sort | uniq
		
	else
		:
	fi
dig -x mail.$1 | grep "PTR" | grep "in-addr" | grep -v ";" | grep -v "Invalid option:"

	
#======================================================================
#===============  SPF records  ===================================
#======================================================================

echo -e "${PURPLE}________________________________________________${NC}"
echo -e "${PURPLE}[#] dig $1 txt (SPF RECORD) ${NC}"
echo -e ""

if [[ ! -z $SPFRECORD  ]] #Checks to see if there is an SPF record propagated.
	then
		echo -e "$SPFRECORD"
	else
		:
	fi

#=================================================================
#========  PROPAGATED DMARC + GOOGLE DKIM RECORDs  =================
#==================================================================

echo -e "${GREY}________________________________________________${NC}"
echo -e "${GREY}[#] dig _.dmarc.$1 (DMARC RECORD) ${NC}"
echo -e ""

if [[ ! -z $DMARCRECORD  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$DMARCRECORD"
	else
		:
	fi

echo -e "${GREEN}________________________________________________${NC}"
echo -e "${GREEN}[#] (GOOGLE / MS365 DKIMS) ${NC}"
echo -e ""

if [[ ! -z $GOOGLEDKIM  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$GOOGLEDKIM"
	else
		:
	fi

if [[ ! -z $MSDKIM1  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$MSDKIM1"
		echo -e ""
	else
		:
	fi

if [[ ! -z $MSDKIM2  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$MSDKIM2"
	else
		:
	fi
	
echo -e "${RED}________________________________________________${NC}"
echo -e "${RED}[#] (MAILGUN DKIMS) ${NC}"
echo -e ""

if [[ ! -z $MAILGUNDKIMKRS  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$MAILGUNDKIMKRS"
		echo -e ""
	else
		:
	fi

if [[ ! -z $MAILGUNDKIMMAILO  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$MAILGUNDKIMMAILO"
		echo -e ""
	else
		:
	fi
	
if [[ ! -z $MAILGUNDKIMSMTP  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$MAILGUNDKIMSMTP"
	else
		:
	fi

echo -e "${BLUE}________________________________________________${NC}"
echo -e "${BLUE}[#] (SENDGRID DKIMS) ${NC}"
echo -e ""

if [[ ! -z $SENDGRIDDKIMS1  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$SENDGRIDDKIMS1"
		echo -e ""
	else
		:
	fi

if [[ ! -z $SENDGRIDDKIMS2  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$SENDGRIDDKIMS2"
	else
		:
	fi

echo -e "${COLOR}________________________________________________${NC}"
echo -e "${COLOR}[#] (MAILCHIMP DKIMS) ${NC}"
echo -e ""

if [[ ! -z $MAILCHIMPDKIMK2  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$MAILCHIMPDKIMK2"
		echo -e ""
	else
		:
	fi
	
if [[ ! -z $MAILCHIMPDKIMK3  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$MAILCHIMPDKIMK3"
	else
		:
	fi

echo -e "${COLOR}________________________________________________${NC}"
echo -e "${COLOR}[#] (KLAVIYO DKIMS) ${NC}"
echo -e ""

if [[ ! -z $KLAVIYODKIMKL  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$KLAVIYODKIMKL"
		echo -e ""
	else
		:
	fi
	
if [[ ! -z $KLAVIYODKIMKL2  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$KLAVIYODKIMKL2"
	else
		:
	fi
#=================================================================
#===============  PROPAGATED MAIL.DOMAIN.COM A RECORD  ===========
#=================================================================

echo -e "${GREY}________________________________________________${NC}"
echo -e "${GREY}[#] dig ${RED}mail.$1 ${GREY}(mail.$1 A RECORD) ${NC}"
echo -e ""
if [[ ! -z $MAILSUBIP  ]] #Checks to see if there is an A record propagated for mail.domain.com.
	then
		printf "$MAILSUBIP"
	else
		:
	fi
if [[ ! -z $MAILSUBPTR  ]] #Checks to see if the A record IP for mail.domain.com has a PTR record.
	then
		echo -e " ${GREY}=>${NC} $MAILSUBPTR"
	else
		echo -e ""
	fi
	
# ======================================================================
# ===============  WHOIS MAIL.DOMAIN.COM IP ADDRESS  ===================
# ======================================================================

echo -e ""
echo -e "${GREY}[#] whois ${RED}${MAILSUBIP} ${GREY}(A RECORD IP INFO) ${NC}"
echo -e ""
if [[ ! -z $MAILSUBIP  ]] #Checks to see if there is an A record propagated for the given domain.
	then
		curl --max-time 5 -s "https://rdap.arin.net/registry/ip/$MAILSUBIP" | jq |
		grep -E 'abuse@|netops@|support@|name' | grep -v 'please' | grep -v "*" |
		sed -e 's/^[ \t]*//' | sort | uniq

	else
		:
	fi
dig -x mail.$1 | grep "PTR" | grep "in-addr" | grep -v ";" | grep -v "Invalid option:"

# =================================================================
# ===============  PROPAGATED autodiscover record==================
# =================================================================

echo -e "${GREY}________________________________________________${NC}"
echo -e "${GREY}[#] dig autodiscover.$1 (AUTODISCOVER RECORD) ${NC}"
echo -e ""
if [[ ! -z $ADRECORD  ]] #Checks to see if there is a record propagated.
	then
		
		echo -e "$ADRECORD"
	else
		:
	fi
echo -e ""

#======================================================================
#===============  WHOIS AUTODISCOVER IP ADDRESS  ======================
#======================================================================

echo -e "${GREY}[#] whois ${ADIP} (AUTODISCOVER RECORD IP INFO) ${NC}"
echo -e ""
if [[ ! -z $ADIP  ]] #Checks to see if there is an A record propagated for the given autodisover subdomain.
    then		
		curl --max-time 5 -s "https://rdap.arin.net/registry/ip/$ADIP" | jq |
		grep -E 'abuse@|netops@|support@|name' | grep -v 'please' | grep -v "*" |
		sed -e 's/^[ \t]*//' | sort | uniq

	else
		:
	fi
echo -e "${GREY}________________________________________________${NC}"