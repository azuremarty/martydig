################ main COLOR variable
COLOR='\033[1;33m'
#######################other color variables
BOLD='\033[1;37m'
NC='\033[0m' # No Color
RED='\033[1;31m'
BLUE='\033[1;34m'
#YELLOW='\033[1;33m'
GREY='\033[1;30m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
############VARIABLES!!!!!!!!!!!
#=========================================
IP=$( dig $1 +short | grep [0-9][0-9] | sort -nr | head -n 1 ) # grep's for IP's then takes the top IP
PTR=$( dig -x $IP +short | grep -v "in-addr" | grep -v "Truncated" | head -n 1) #reverse DNS lookup to get PTR record
#===========================================
SRVRECORD=$( dig _sip._tls.$1 srv +nostats +noquestion +nocomments | grep IN | grep SRV | grep -v SOA | grep -v "RedHat" | grep -v "AAAA" | grep -v ".root-servers.net" | sort)
SRVFEDRECORD=$( dig _sipfederationtls._tcp.$1 srv +nostats +noquestion +nocomments | grep IN | grep SRV | grep -v SOA | grep -v "RedHat" | grep -v "AAAA" | grep -v ".root-servers.net" | sort)
#===========================================
ADRECORD=$( dig autodiscover.$1 +short )
ADIP=$( dig autodiscover.$1 +short | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -n 1 )
#===============================================
MAILMX=$( dig mx $1 +short | grep -v ".root-servers.net" | grep -v "CNAME" | sort -n | head -n 1 )
MAILMXLONG=$( dig mx $1 +short | grep -v ".root-servers.net" | sort -nr )
#======================================== 
MAILIP=$( dig $MAILMX +short | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" | head -n 1 )
MAILPTR=$( dig -x $MAILIP +short | grep -v "in-addr" | head -n 1 )

#=================================================================
clear
echo -e "${BLUE}|${BOLD}RECON SCRIPT FOR NEW MIGRATION${BLUE}|${NC}"
echo -e "${BLUE}_______________________________________________________${NC}"   
echo -e "${BLUE}[#] whois $1 (REGISTRAR INFO) ${NC}"
#=================================================================
#===============  WHOIS DOMAIN  ===================================
#==================================================================
echo -e ""
whois $1 | grep -e "[S][eE][rR][vV][eE][rR]" -e Nameserver: -e Registrar: -e "Registrar URL" -e Organization: -e "Admin" -e Comment: -e "Email" -e "nameservers:" -e "[hH][oO][lL][dD]" -e Expiration -e Expiry -e Reseller -e URL: -e "[tT]ransfer" -e "[Nn]ame:" -e "[nN]o match" -e ns1 -e NS1 -e ns2 -e NS2 -e ns3 -e NS3 -e ns4 -e NS4 -e "NOT FOUND" -e "[Nn][Ss]\." -e "abuse-mailbox:" -e "Name servers:" -e NET | grep -v "[cC]reated" | grep -v "[uU]pdated" | grep -v "The data in" | grep -v "information purposes only" | grep -v "makes this information available" | grep -v "that apply to" | grep -v "prior written consent" | grep -v "BRST" | grep -v "This server accepts" | grep -v "reserves the right" | grep -v "clientTransferProhibited" | grep -v "modify existing registrations" | grep -v "support questions" | grep -v "Redirected" | grep -v "Querying" | grep -v "\[whois\." | grep -v "follow the instructions" | grep -v "Unconditional Guarantee" | grep -v "reserves the right" | grep -v "[bB]illing" | grep -v "Registrar Abuse Contact Email" | grep -v "dest IP (your IP)" | grep -v "Intensity/frequency" | grep -v "Without these" | grep -v "NetName:" | grep -v "Domain Name:" | grep -v "Tech" | grep -v "NOCEmail" | grep -v "Administrative Contact Postal Code" | grep -v "Administrative Contact Phone Number" | grep -v "Administrative Contact Facsimile Number" | grep -v "Administrative Contact ID" | grep -v "Administrative Contact Address" | grep -v "Administrative Contact City" | grep -v "Administrative Contact Country" | grep -v "Administrative Contact State/Province" | grep -v "Administrative Contact Country Code" | grep -v "Admin Phone Ext" | grep -v "Admin Fax" | grep -v "Domain ID:" | grep -v "Admin Fax Ext" | grep -v "Admin Phone" | grep -v "Admin Country" | grep -v "Invalid option:" | grep -v "Admin Postal Code" | grep -v "Admin State/Province" | grep -v "Admin City" | grep -v "Admin Street" | grep -v "Admin ID" | grep -v "Registry Admin ID" | grep -v "has collected this" | grep -v "Last Transferred Date:" | grep -v "Administrative Application Purpose:" | grep -v "Administrative Nexus Category:" | grep -v "Parent" | grep -v "NetHandle:" | grep -v "Ref:" | grep -v "StateProv:" | grep -v "WHOIS Server:" | grep -v "Please register your domains" | grep -v "network:In-Addr-Server;" | grep -v "network:Network-Name:" | grep -v "Comments to" | grep -v "network:Tech-Contact;" | grep -v "OrgNOCName:" | grep -v "global Web hosting" | grep -v "DreamHost is" | grep -v "websites and apps hosted" | grep -v "Dedicated Server Hosting" | grep -v "Registrar Registration Expiration Date" | grep -v "high-value domains" | grep -v "DreamCompute" | grep -v "contains ONLY .COM" | grep -v "for more information"
#========================================================================
#=========================== NS RECORDS ===============================
#=======================================================================
echo -e "${GREEN}_______________________________________________________${NC}"
echo -e "${GREEN}[#] dig $1 ns (PROPAGATED NS RECORD) ${NC}"
echo -e ""
dig $1 ns +nostats +noquestion +nocomments | grep IN | grep NS | grep -v SOA | grep -v "RedHat" | grep -v "AAAA" | grep -v ".root-servers.net"
#======================================================================
#=========================== MX RECORDS ===============================
#=======================================================================
echo -e "${RED}_______________________________________________________${NC}"
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
echo -e "${RED}_______________________________________________________${NC}"
echo -e "${RED}[#] whois ${MAILIP} (MX RECORD IP INFO) ${NC}"
echo -e ""
if [[ ! -z $MAILIP  ]] #Checks to SEE THE IP INFO FOR THE TOP MX RECORD
	then
		whois $MAILIP | grep -e "[sS][eE][rR][vV][eE][rR]" -e Registrar: -e "Registrar URL" -e OrgTechEmaiL -e Organization: -e Network-Name -e Org-Name -e OrgName -e NetName -e "Status:" -e "Registrant Name" -e "org-name:" -e "Registrant Org" -e "Email" -e "Registrant Street" -e "Registrant City" -e "Registrant Country" -e "Registrant Phone:" -e Expiration -e Expiry -e Reseller -e "Organization Name" -e "(" -e netname: -e descr: -e remarks: -e person: -e abuse-mailbox: -e country -e Country -e network:Org-name: -e OrgAbuseEmail: -e network:Updated-By -e network:Organization -e network:Tech-Contact -e network:Admin-Contact -e e-mail: -e StateProv: -e City: -e ns1 -e NS1 -e ns2 -e NS2 | grep -v "[pP]arent" | grep -v served | grep -v "RTechEmail" | grep -v "Invalid option:" | grep -v "RNOCEmail" | grep -v "(BRST" | grep -v "This server accepts" | grep -v "RAbuseEmail" | grep -v "%rwhois" | grep -v "dest IP (your IP)" | grep -v "Intensity/frequency" | grep -v "Without these" | grep -v "NetName:" | grep -v "NOCEmail" | grep -v "Organization:" | grep -v "remarks:" | grep -v "OrgTechEmail:" | grep -v "contact details" | grep -v "network:In-Addr-Server;" | grep -v "City:" | grep -v "StateProv:" | grep -v "network:Network-Name:" | grep -v "Comments to" | grep -v "network:Tech-Contact;" | grep -v "OrgNOCName:" | grep -v "Country:" | grep -v "connect: Connection refused" | sort -u
	else
		:
	fi
#dig -x $1 | grep "PTR" | grep "in-addr" | grep -v ";" | grep -v "Invalid option:"
#=================================================================
#===============  PROPAGATED autodiscover record====================
#==================================================================
echo -e "${CYAN}_______________________________________________________${NC}"
echo -e "${CYAN}[#] dig autodiscover.$1 (AUTODISCOVER RECORD) ${NC}"
echo -e ""
if [[ ! -z $ADRECORD  ]] #Checks to see if there is a record propagated.
	then
		dig autodiscover.$1 +nostats +noquestion +nocomments | grep IN | grep -v SOA | grep -v "RedHat" | grep -v ".root-servers.net" | grep -v "autodiscover.geo.outlook.com" | grep -v "autodiscover.outlook.com.g.outlook.com" | grep -v "autodiscover.geo.outlook.com" | grep -v "autodiscover-namcentral" | head -n 6
#		echo -e "$ADRECORD" | head -n 6
	else
		:
	fi
	
#======================================================================
#===============  WHOIS AUTODISCOVER IP ADDRESS  ===================================
#======================================================================

echo -e "${CYAN}_______________________________________________________${NC}"
echo -e "${CYAN}[#] whois ${ADIP} (AUTODISCOVER RECORD IP INFO) ${NC}"
echo -e ""
if [[ ! -z $ADIP  ]] #Checks to see if there is an A record propagated for the given autodisover subdomain.
    then
        whois $ADIP | grep -e "[sS][eE][rR][vV][eE][rR]" -e Registrar: -e "Registrar URL" -e OrgTechEmaiL -e Organization: -e Network-Name -e Org-Name -e OrgName -e NetName -e "Status:" -e "Registrant Name" -e "org-name:" -e "Registrant Org" -e "Email" -e "Registrant Street" -e "Registrant City" -e "Registrant Country" -e "Registrant Phone:" -e Expiration -e Expiry -e Reseller -e "Organization Name" -e "(" -e netname: -e descr: -e remarks: -e person: -e abuse-mailbox: -e country -e Country -e network:Org-name: -e OrgAbuseEmail: -e network:Updated-By -e network:Organization -e network:Tech-Contact -e network:Admin-Contact -e e-mail: -e StateProv: -e City: -e ns1 -e NS1 -e ns2 -e NS2 | grep -v "[pP]arent" | grep -v served | grep -v "RTechEmail" | grep -v "Invalid option:" | grep -v "RNOCEmail" | grep -v "(BRST" | grep -v "This server accepts" | grep -v "RAbuseEmail" | grep -v "dest IP (your IP)" | grep -v "Intensity/frequency" | grep -v "Without these" | grep -v "NetName:" | grep -v "NOCEmail" | grep -v "Organization:" | grep -v "remarks:" | grep -v "City:" | grep -v "OrgTechEmail:" | grep -v "contact details" | grep -v "network:In-Addr-Server;" | grep -v "StateProv:" | grep -v "network:Network-Name:" | grep -v "Comments to" | grep -v "%rwhois" | grep -v "network:Tech-Contact;" | grep -v "OrgNOCName:" | grep -v "Country:" | grep -v "connect: Connection refused" | sort -u
    else
        :
    fi
#=================================================================
#===============  PROPAGATED A RECORD  ============================
#==================================================================
echo -e "${COLOR}_______________________________________________________${NC}"
echo -e "${COLOR}[#] dig $1 (A RECORD) ${NC}"
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
#=================================================================	
#========================  LOCAL NAMESERVERS  ====================	
#=================================================================
#
#echo -e "${COLOR}_______________________________________________________${NC}"
#echo -e "${COLOR}[#] dig @ns $1 (IMH+HUB LOCAL NS) ${NC}"
#echo -e ""
#if [[ ! -z $NS1IMH  ]] #Checks to see if there are any A record entries in the local nameservers
#	then
#		printf "${BOLD}@NS1.IMH${NC} ${COLOR}=>${NC} $NS1IMH"
#	else
#		:
#	fi
#if [[ ! -z $NS1IMHPTR  ]] #Checks to see if the A record IP has a PTR record
#	then
#		echo -e " ${COLOR}=>${NC} $NS1IMHPTR"
#	else
#		printf "\n"
#	fi
#=======================================================
#if [[ ! -z $NS2IMH  ]] #Checks to see if there are any A record entries in the local nameservers
#	then
#		printf "${BOLD}@NS2.IMH${NC} ${COLOR}=>${NC} $NS2IMH"
#	else
#		:
#	fi
#if [[ ! -z $NS2IMHPTR  ]] #Checks to see if the A record IP has a PTR record
#	then
#		echo -e " ${COLOR}=>${NC} $NS2IMHPTR"
#	else
#		printf "\n"
#	fi
#=========================================================
#if [[ ! -z $NS1HUB  ]] #Checks to see if there are any A record entries in the local nameservers
#	then
#		printf "${BOLD}@NS1.HUB${NC} ${COLOR}=>${NC} $NS1HUB"
#	else
#		:
#	fi
#if [[ ! -z $NS1HUBPTR  ]] #Checks to see if the A record IP has a PTR record
#	then
#		echo -e " ${COLOR}=>${NC} $NS1HUBPTR"
#	else
#		printf "\n"
#	fi
#============================================================
#if [[ ! -z $NS2HUB  ]] #Checks to see if there are any A record entries in the local nameservers
#	then
#		printf "${BOLD}@NS2.HUB${NC} ${COLOR}=>${NC} $NS2HUB"
#	else
#		:
#	fi
#if [[ ! -z $NS2HUBPTR  ]] #Checks to see if the A record IP has a PTR recordd
#	then
#		echo -e " ${COLOR}=>${NC} $NS2HUBPTR"
#	else
#		printf "\n"
#	fi
#	
#======================================================================
#===============  WHOIS IP ADDRESS  ===================================
#======================================================================
echo -e "${COLOR}_______________________________________________________${NC}"
echo -e "${COLOR}[#] whois ${IP} (A RECORD IP INFO) ${NC}"
echo -e ""
if [[ ! -z $IP  ]] #Checks to see if there is an A record propagated for the given domain.
	then
		whois $IP | grep -e "[sS][eE][rR][vV][eE][rR]" -e Registrar: -e "Registrar URL" -e OrgTechEmaiL -e Organization: -e Network-Name -e Org-Name -e OrgName -e NetName -e "Status:" -e "Registrant Name" -e "org-name:" -e "Registrant Org" -e "Email" -e "Registrant Street" -e "Registrant City" -e "Registrant Country" -e "Registrant Phone:" -e Expiration -e Expiry -e Reseller -e "Organization Name" -e "(" -e netname: -e descr: -e remarks: -e person: -e abuse-mailbox: -e country -e Country -e network:Org-name: -e OrgAbuseEmail: -e network:Updated-By -e network:Organization -e network:Tech-Contact -e network:Admin-Contact -e e-mail: -e StateProv: -e City: -e ns1 -e NS1 -e ns2 -e NS2 | grep -v "[pP]arent" | grep -v served | grep -v "RTechEmail" | grep -v "Invalid option:" | grep -v "RNOCEmail" | grep -v "(BRST" | grep -v "This server accepts" | grep -v "RAbuseEmail" | grep -v "dest IP (your IP)" | grep -v "Intensity/frequency" | grep -v "Without these" | grep -v "NetName:" | grep -v "NOCEmail" | grep -v "Organization:" | grep -v "remarks:" | grep -v "StateProv:" | grep -v "City:" | grep -v "OrgTechEmail:" | grep -v "contact details" | grep -v "network:In-Addr-Server;" | grep -v "network:Network-Name:" | grep -v "Comments to" | grep -v "%rwhois" | grep -v "network:Tech-Contact;" | grep -v "OrgNOCName:" | grep -v "Country:" | grep -v "connect: Connection refused" | sort -u
	else
		:
	fi
dig -x $1 | grep "PTR" | grep "in-addr" | grep -v ";" | grep -v "Invalid option:"
#======================================================================
#===============  txt records  ===================================
#======================================================================
echo -e "${PURPLE}_______________________________________________________${NC}"
echo -e "${PURPLE}[#] dig $1 txt (TXT RECORDS) ${NC}"
echo -e ""
dig $1 txt +short | grep -v ".root-servers.net" | grep -v "Truncated"
#=================================================================
#===============  PROPAGATED SRV RECORDs  ============================
#==================================================================
echo -e "${GREY}_______________________________________________________${NC}"
echo -e "${GREY}[#] dig $1 srv (SRV RECORDS) ${NC}"
echo -e ""
if [[ ! -z $SRVRECORD  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$SRVRECORD"
	else
		:
	fi
if [[ ! -z $SRVFEDRECORD  ]] #Checks to see if there is a record propagated.
	then
		echo -e "$SRVFEDRECORD"
	else
		:
	fi
echo -e "${GREY}_______________________________________________________${NC}"
echo -e ""
