#!/bin/bash
home="/home/$(whoami)"
bashrc="$home/.bashrc"
mainfolder="$home/.bashrc.d/"
neededfold="${mainfolder}scripts-needed"
avfolder="${mainfolder}scripts-available"
enfolder="${mainfolder}scripts-enabled"
rmfolder="${mainfolder}scripts-removed"

## FUNCTIONS ##
createdir(){
	if [ ! -d "$mainfolder" ]; then 
		mkdir $mainfolder
		echo "[ Created $mainfolder ]"
	fi

    if [ ! -d "$neededfold" ]; then 
        mkdir $neededfold
        echo "[ Created $neededfold ]"
    fi

    if [ ! -d "$avfolder" ]; then 
        mkdir $avfolder
        echo "[ Created $avfolder ]"
    fi

    if [ ! -d "$enfolder" ]; then 
        mkdir $enfolder
        echo "[ Created $enfolder ]"
    fi

    if [ ! -d "$rmfolder" ]; then 
        mkdir $rmfolder
        echo "[ Created $rmfolder ]"
    fi
}



modular-bashrc(){
echo 'mkdir -p ~/.bashrc.d/scripts-needed' >> $bashrc
echo 'mkdir -p ~/.bashrc.d/scripts-enabled' >> $bashrc
echo 'mkdir -p ~/.bashrc.d/scripts-available' >> $bashrc
echo 'if [ -d ~/.bashrc.d ]; then' >> $bashrc
echo '    for needed in ~/.bashrc.d/scripts-needed/*.sh; do' >> $bashrc
echo '        [ -r "$needed" ] && source "$needed"' >> $bashrc
echo '    done' >> $bashrc                                                                                                                                                                    
echo '    unset needed' >> $bashrc
echo '    for file in ~/.bashrc.d/scripts-enabled/*.sh; do' >> $bashrc
echo '        [ -r "$file" ] && source "$file"' >> $bashrc
echo '    done' >> $bashrc
echo '    unset file' >> $bashrc
echo 'fi' >> $bashrc 
}

## EXECUTION ##
echo "### Creation Folders ###"
createdir
echo "### Adding brc-script for .bashrc ###"
modular-bashrc
echo [ brc-script installed ]

echo "##################################"
echo "        Small Introduction        "
echo "##################################"
echo "" 
echo "You can handle you script by adding in the $avfolder."
echo "Make sure that all the the script that you are adding are added in a function, otherwise their will be loaded at each open of the bash cli."
echo "You can start to handle all the script by writing the command brc-script, also you can refresh the bash with the command refresh-brc."
echo "You can start to create your own script by use the 'brc-script -c' command"
echo "To enable an available script (after you copied or created one in the scripts-available) by using 'brc-script -e' and the the index command that you need"
echo "You can also modify the existing script by the 'brc-script -m' command."
echo ""
echo "##################################"
echo "   Thanks for using this script.  "
echo "##################################"
echo " Visit my website www.simolinuxdesign.org to discover more plugin that i created!

