#!/bin/sh

# Thank you for using shTicket.
# shTicket is a script written in BASH (Bourne Again Shell) which turns MSMTP into a lightweight support ticketing system
# With a simple command line menu, shTicket formats tickets to be sent via e-mail using MSMTP.
# For help configuring the e-mail to which tickets will arrive (usually your help desk / support e-mail), read the help docs.



FILENAME=ticketlogs.txt
introfile=logoshtick

if test -f "$FILENAME"
then 
	echo "Log file already exists. Good."
else
	echo 'creating log file...'
       	touch ticketlogs.txt
fi


cat  $introfile
sleep 1

menu () {
echo '-------------------------------'
echo 'Please select an option:'
echo '1. Submit a new ticket'
echo '2. Close a ticket'
echo '3. View ticket history'
echo '4. Close'
read option
}

menu


ticketwiz () {
	ticketID=$((1000 + $RANDOM % 10000))
	echo "Subject of ticket"
	read subject
	echo "Additional information"
	read info

	if grep -Fxq "$ticketID" ticketlogs.txt
	then
		ticketID=$((1000 + $RANDOM % 10000))
		echo "Ticket number: $ticketID, Subject: $subject, Info: $info" >> ticketlogs.txt
	else
		echo "Ticket number: $ticketID, Subject: $subject, Info: $info " >> ticketlogs.txt
	fi

	printf "Subject: Ticket ID:  $ticketID, $subject \n$info" | msmtp -a gmail1 example@example.com

	if [ "$?" == 0 ]
	then
		echo "Ticket submitted."
	fi

}

ticketclose () {
	logfile='ticketlogs.txt'
	read -p "Enter ticket number: " closedID
	replace="$closedID - Closed"
	if [[ $closedID != "" && $replace != "" ]]
	then 
		sed -i "s/$closedID/$replace/" $logfile
		if [ "$?" == 0 ]
		then
			echo "Ticket closed."
		fi
	fi

}


viewtickethistory () {
	cat $FILENAME
	echo "Enter any character to exit."
	read homecheck
	if [ $homecheck != "" ]
	then
		exit
	fi
}

if [ $option == 1 ]
then
	ticketwiz 
elif [ $option == 2 ]
then
	ticketclose 
elif [ $option == 3 ]
then
	viewtickethistory
elif [ $option == 4 ]
then 
	echo 'Exiting shTicket'
	sleep 1 
else 
	echo "Invalid input. "
	sleep 3
	menu
fi


