#!/bin/bash
clear
user=$(whoami)  # Remove the extra space

follow() {
    read -p "Press 'Enter' to continue"
}

loop2=0
while [ $loop2 -lt 1 ]; do  # Corrected the integer comparison
    echo "### brc-script installer ###"
    echo "---------------------------------------------"
    echo "Do you want to install for the current user ($user)?"
    echo "---------------------------------------------"
    echo " y - yes"
    echo " n - no"
    echo " q - exit" 
    echo " default - yes"
    echo "---------------------------------------------"
    read choice
    if [ "$choice" == "n" ]; then
        loop2=1
        loop1=0
        clear
        while [ $loop1 -lt 1 ]; do  # Corrected the integer comparison
            echo "----------------------------"
            echo "List of the available users:"
            echo "----------------------------"
            for i in $(grep -E ':/home/' /etc/passwd | cut -d: -f1); do echo $i; done 
            echo "q = exit"
            echo "----------------------------"
            echo "Type the user:"
            read choice2
            if [ -d "/home/$choice2" ]; then
                user=$choice2
                echo "Selected user '$choice2'!"
                echo "-------------------"
                echo "Can you confirm it?"
                echo "-------------------"
                echo " y = yes "
                echo " n = no "
                echo " default = no "
                echo "-------------------"
                read confirm  # Changed 'input' to 'read'
                if [ "$confirm" == "y" ]; then
                    user=$choice2
                    echo "Using user '$choice2'"
                    loop1=1
                else
                    echo "Wrong selection, for user '$choice2' "
                    follow
                    loop1=0
                fi
            elif [ "$choice2" == "q" ]; then
                echo "Exit from the installer script"
                exit 1
            else
                echo "Home folder for '$choice2' does not exist!"
                echo "Try with another one!"
            fi
        done
	elif [ "$choice" == "q" ]; then
		echo "[ Exit from the installer script! ]"
		exit 1
    else
        clear
        loop3=0
        while [ $loop3 -eq 0 ]; do
            echo "--------------------------------"
            echo "Do you want to use '$user' user?"
            echo "--------------------------------"
            echo " y = yes"
            echo " n = no "
            echo "--------------------------------"
            read choice3
            if [ "$choice3" == "y" ]; then
                echo "Selected the current user '$user'"
                loop2=1
                loop3=1
                follow
            elif [ "$choice3" == "n" ]; then  # Corrected from 'no' to 'n'
                echo "Not selected the current user '$user'"
                loop3=1
                follow
				clear
            else
                echo "Pressed wrong button!"
                follow
				clear
		clear
            fi
        done
    fi
done

#### NEEDED VARIABLES ####
location="$(pwd)/../"
home="/home/$user"
bashrc="$home/.bashrc"
mainfolder="$home/.bashrc.d/"
neededfold="${mainfolder}scripts-needed"
avfolder="${mainfolder}scripts-available"
enfolder="${mainfolder}scripts-enabled"
rmfolder="${mainfolder}scripts-removed"

#### INSTALLATION #### 
cp "$bashrc"  "bashrc-backup-`date +%F`"
echo "[ Created a backup ]"
cat NEEDED-FOR-INSTALLER >> $bashrc
echo "[ Added info in the .bashrc file ]"
cp -r $location $mainfolder
echo "[ Installed Main Folder ]"
echo $mainfolder
source $bashrc
echo "[ Refreshed bashrc ]"
echo ""
echo "Intallation Completed!"
follow
clear
## EXECUTION ##
echo "##################################"
echo "        Small Introduction        "
echo "##################################"
echo "" 
echo "You can handle your script by adding them in the $avfolder."
echo "Make sure that all the scripts you add are within a function, otherwise they will be loaded each time you open the bash CLI."
echo "You can start managing scripts by using the command 'brc-script', and refresh bash with 'refresh-brc'."
echo "You can create your own script using 'brc-script -c'."
echo "To enable an available script (after copying or creating one in the scripts-available), use 'brc-script -e' and provide the index."
echo "You can also modify existing scripts using 'brc-script -m'."
echo ""
echo "##################################"
echo "   Thanks for using this script.  "
echo "##################################"
echo "Visit my website www.simolinuxdesign.org to discover more plugins I created!"

