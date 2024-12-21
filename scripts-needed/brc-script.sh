#!/bin/bash

###############
### OPTIONS ###
###############
editor="vim"

#################
### VARIABLES ###
################# 
home_folder="$HOME/"
available_scripts="${home_folder}.bashrc.d/scripts-available/"
enabled_scripts="${home_folder}.bashrc.d/scripts-enabled/"
needed_scripts="${home_folder}.bashrc.d/scripts-needed"
bin_folder="${home_folder}.bashrc.d/scripts-removed/"
bashrc="${home_folder}.bashrc"

#################
### FUNCTIONS ###
#################

# Refresh Bash #
refresh-brc(){
	if [ "$1" == "-dis" ]; then
		echo "------------------------------------"
		echo "[ Bashrc Refreshed ]"
		echo "You can't use the old commands from now!"
		echo "------------------------------------"
	elif [ "$1" == "-en" ]; then
		echo "------------------------------------"
		echo "[ Bashrc Refreshed ]"
		echo "------------------------------------"
		echo "You can you the new commands from now!"
		echo "------------------------------------"
	else
		echo "[ Bashrc Refreshed ]"
	fi
	source "$bashrc"
}


createscript() {
	echo "------------------------------------"
	echo "       Creation New Scripts:        " 
	echo "------------------------------------"
	echo "Name of the script: "
	read namenewscript
	if [ -f "${available_scripts}$namenewscript" ]; then
		echo "Script already exists!"
	else	
		newscriptav="${available_scripts}$namenewscript.sh"
		
		### INITIALIZZATION NEW SCRIPT ### 
		touch $newscriptav
		echo "#!/bin/bash" >> $newscriptav
		echo "" >> $newscriptav
		echo "### OPTIONS ###" >> $newscriptav
		echo "" >> $newscriptav
		echo "" >> $newscriptav
		echo "### VARIABLES ###" >> $newscriptav
		echo "" >> $newscriptav
		echo "" >> $newscriptav
		echo "### FUNCTIONS ###" >> $newscriptav
		echo "${namenewscript}() {" >> $newscriptav
		echo "# Add your code here!" >> $newscriptav
		echo 'echo "This is the new script"' >> $newscriptav
		echo "}" >> $newscriptav
		echo "" >> $newscriptav
		echo "### EXECUTE ###" >> $newscriptav
		echo "" >> $newscriptav
		echo "" >> $newscriptav
		### END NEW SCRIPT ###

		vim "$newscriptav"
		if [ $? -ne 0 ]; then
			echo "------------------------------------"
			echo "         Editor aborted!"
	       		echo " Continue or remove $namenewscript?"
			echo "------------------------------------"
			echo "     1 | Continue "
			echo "     2 | Abort "
			echo "   Def | Continue "
			echo "------------------------------------"
			read answer
			if [ "${answer}x" = "2x" ]; then
				rm "$newscriptav"
				return
			fi
		fi
		echo "------------------------------------"
		echo "   Script $namenewscript created!"
		echo "     Do you want to enable it?"
		echo "------------------------------------"
		echo "     1 | yes "
		echo "     2 | no "
		echo "   Def | no "
		echo "------------------------------------"
		read answer
		if [ "$answer" -eq 1 ]; then
			ln -sf "$newscriptav" "${enabled_scripts}$namenewscript.sh"
			refresh-brc -en
		else
			echo "Script not enabled!"
		fi 
	fi
}
 
listitem() {
	index=0
   	for i in $(ls "$available_scripts"); do
        	inotext=${i:0:-3}
		(( index ++ ))
		enabled=""
   		if [ -f "$enabled_scripts$i" ]; then 
			enabled="-"
   		fi
		printf "%5d | %1s %s\n" "$index" "$enabled" "$inotext"
	done
}


managescript() {
	echo "------------------------------------"
	echo "         Select the index:          "
	echo "------------------------------------"
    read manageindex
    index2=1  
    for i in $(ls "$available_scripts"); do
        if [ "$manageindex" == "$index2" ]; then
            # DISABLE WITH NUMBER #
            if [ "$1" == "--disable" ]; then
		if [ ! -f "${enabled_scripts}$i" ]; then
			echo "Script not enabled!"
		else
                 	unlink "${enabled_scripts}$i"
          	 	inoext=${i:0:-3}
                	echo "[ Scripts $inoext Disabled ]"
                	refresh-brc -dis
		fi
            # ENABLE WITH NUMBER #
            elif [ "$1" == "--enable" ]; then
		if [ -f "${enabled_scripts}$i" ]; then
			echo "Script already enabled!"
		else
			ln -sf "$available_scripts$i" "${enabled_scripts}$i"
	                inoext=${i:0:-3}
					echo "------------------------------------"
	                echo "[ Scripts $inoext Enabled ]"
	                refresh-brc -en
		fi

            # MODIFY WITH NUMBER #
            elif [ "$1" == "--modify" ]; then
                if [ "$editor" == "vim" ]; then
                    vim "$available_scripts$i"
                elif [ "$editor" == "nano" ]; then
                    nano "$available_scripts$i"
                else
                    echo "------------"
                    echo " 1 - nano   "
                    echo " 2 - vim    "
                    echo " def - vim  "
                    echo "------------"
                    read ched
                    if [ "$ched" == "1" ]; then
                        nano "$available_scripts$i"
                    else
                        vim "$available_scripts$i"
                    fi
                fi
				clear
				echo "------------------------------------"
				echo "Would you like to rename the script?"
				echo "------------------------------------"
				echo " 1 | yes "
				echo " 2 | no  "
				echo " default | no "
				echo "------------------------------------"
				read renscr
				if [ $renscr == "1" ]; then
				clear
					countloop=0
					while [ $countloop -lt 1 ]; do
						echo "------------------------------------"
						echo "Insert new name:"
						read  renamenow
						echo "------------------------------------"
						echo "Is the name correct? "
						echo "------------------------------------"
						echo " 1 | no "
						echo " 0 | yes "
						echo " default | yes "
						echo "------------------------------------"
						read confirm
						if [ "$confirm" == "1" ]; then
							countloop=0
							clear
							echo "------------------------------------"
							echo "Rename again the file:"
						else
							wasenabled=0
							if [ -f "$enabled_scripts$i" ]; then
								unlink "$enabled_scripts$i"
								echo "[ Temporary Disabled Script ]"
								wasenabled=1
							fi
							mv "$available_scripts$i" "${available_scripts}$renamenow.sh"
							echo "[ Script $i renamed to $renamenow.sh ]"
							if [ "$wasenabled" -eq 1 ]; then
								ln -sf "${available_scripts}$renamenow.sh" "${enabled_scripts}$renamenow.sh"
								echo "[ Script Enabled Again ]"
							fi
							countloop=1
						fi 
					done
				fi	
                refresh-brc -en
	    # REMOVE SCRIPT #
	    elif [ "$1" == "--remove" ]; then 
		if [ ! -d "$bin_folder" ]; then
			mkdir $bin_folder
		fi
		if [ -f "${enabled_scripts}$i" ]; then
			unlink "${enabled_scripts}$i"
			echo "[ Script $i unabled! ]"
		fi
		removed_data="$i-`date +%F`_`date +%T`"
		mv "${available_scripts}$i" "${bin_folder}$removed_data"
		echo "[ Script $i removed! ]         "
		echo "You can find it in the folder: "
		echo "'$bin_folder' "
		echo "------------------------------------"
		refresh-brc	
            fi
	    
            break  
        fi
        ((index2++))
    done
}

removescript(){
	echo "------------------------------------"
	echo "           Remove Script            "
	echo "------------------------------------"
	listitem
	managescript --remove
}	

enablescript() {
	echo "------------------------------------"
	echo "           Enable Scripts           "
	echo "------------------------------------"
	listitem
	managescript --enable
}

enableallscript() {
	for i in $(ls "$available_scripts"); do
		ln -sf "$available_scripts$i" "${enabled_scripts}$i"
                inoext=${i:0:-3}
                echo "enabled $inoext"
	done
	echo "------------------------------------"
	echo "[ All available scripts enabled ]"
	refresh-brc -en
}


disablescript() {
	echo "------------------------------------"
	echo "          Disable Scripts           "
	echo "------------------------------------"
	listitem
	managescript --disable
}


disableallscript() {
	# Disabilita tutti gli script
	for i in $(ls "$enabled_scripts"); do
		unlink "${enabled_scripts}$i"
		inoext=${i:0:-3}
		echo "disabled $inoext"
	done
	echo "------------------------------------"
	echo "[ All Scripts Disabled ]"
	refresh-brc -dis
}

#################
### EXECUTION ###
#################

# Main Script # 
brc-script() {
	### ENABLE SCRIPTS ###
	if [ "$1" == "-e" ]; then
		enablescript

	### ENABLE ALL SCRIPTS ###
	elif [ "$1" == "-ea" ]; then
		enableallscript

    	### DISABLE SCRIPT ###
	elif [ "$1" == "-d" ]; then
		disablescript

	### DISABLE ALL SCRIPTS ###
	elif [ "$1" == "-da" ]; then
		disableallscript

	### SCRIPTS LIST ###
	elif [ "$1" == "-l" ]; then
			echo "------------------------------------"
	        echo "            Scripts List            "
			echo "------------------------------------"
		listitem
		echo "------------------------------------"
		echo "    The script preceded by the" 
		echo "      '-' character is active.  "
		echo "------------------------------------"
	
	### MODIFY SCRIPTS ###
	elif [ "$1" == "-m" ]; then
		echo "###### MODIFY SCRIPTS #######"
		listitem
		managescript --modify
		
	### CREATE NEW SCRIPT ###
	elif [ "$1" == "-c" ]; then
		createscript
	
	### REMOVE SCRIPT ###
	elif [ "$1" == "-r" ]; then
		removescript

	### COMMAND LISTS ###
	else
			echo "-----------------------------"
        	echo " List of brc-scripts command "
	        echo "-----------------------------"
		echo "  -c  | Create New Script    "
	        echo "  -m  | Modify Script        "
       		echo "  -l  | Scripts List         "
		echo "  -e  | Enable Scripts       "
	        echo "  -d  | Disable Scripts      "
		echo "  -da | Disable All Scripts  "
		echo "  -ea | Enable All Scripts   "
		echo "  -r  | Remove Script        "
	        echo "-----------------------------"
	fi
}
