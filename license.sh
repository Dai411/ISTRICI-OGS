#! /bin/sh
# mailhome.sh - send a message back to OGS 
# Umberta Tinivella, National Institute of Oceanography and Applied Geophysics - OGS, 8 August 2022
#set -x

# these items identify the date/release of the codes
DATE="8 August 2022"
RELEASE="V1"

echo
echo
echo "################################################################"
echo "####### Legal Statement for ${DATE} Release ${RELEASE} of ISTRICI #######"
echo "################################################################"
echo
echo "hit return key to continue"  | tr -d "\012"
read RESP 
echo
	more ./LEGAL_STATEMENT
echo
echo "By answering you agree to abide by the terms and conditions of"
echo "the above LEGAL STATEMENT ?[y/n]"  | tr -d "\012"
read RESP

case $RESP in
	y*|Y*) # continue
	echo "ISTRICI Release $RELEASE $DATE" > ISTRICI_version
	;;
	*) # Stop installation
		exit 1
	;;
		esac

sh mailhome.sh

exit 0
