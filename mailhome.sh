#! /bin/sh
# mailhome.sh - send a message back to OGS 
# Umberta Tinivella, National Institute of Oceanography and Applied Geophysics, 8 August 2022
#set -x

# these items identify the date/release of the codes
DATE="8 August 2022"
RELEASE="V1"

# home address
ADDRESS="utinivella@ogs.it"

# message
MESSAGE="Installing the $DATE version (Release ${RELEASE}) of the OGS codes."
YOURADDRESS=


echo
echo
echo "######################"
echo "######################"
echo
echo
echo "To give us at OGS an idea of who uses our codes"
echo "the master Makefile will email the following message:"
echo
echo " \"${MESSAGE}\" "
echo
echo "to: \"${ADDRESS}\" "
echo
echo
echo
echo "You will then be put on our OGS/ISTRICI mailing list"
echo "and will be informed of future updates of the OGS/ISTRICI releases."
echo
echo
echo "However, if you would rather not have this message sent"
echo "you may specify this as your response to the next query."
echo
echo
echo "Send automatic mail message back to OGS?[y/n]"  | tr -d "\012"
read RESP 

case $RESP in
	y*|Y*) # continue

		ok=false
		while [ $ok = false ]
		do
			echo "please type your e-mail address: "  | tr -d "\012"
			read YOURADDRESS
			#check to see if address is correct
			echo "is $YOURADDRESS correct?[y/n]"  | tr -d "\012"
			read ISADDRESSOK
			case $ISADDRESSOK in
			n*) ok=false
			;;
			*)  ok=true
				echo "$MESSAGE $YOURADDRESS" | mail $ADDRESS

				echo 
				echo
				echo "Beginning installation process"
				echo
				echo
				sleep 5
				echo
				echo "THANK YOU FOR YOUR FEEDBACK!!!"
				echo 
			;;
			esac
		done
	;;
	*) # don't send the message
		echo "Continuing without sending the mailing."
	;;
		esac

exit 0

