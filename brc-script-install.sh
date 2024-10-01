#!/bin/bash
mainfolder="/home/$(whoami)/.bashrc.d/"
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

    if [ ! -d "$mainfolder" ]; then 
        mkdir $mainfolder
        echo "[ Created $mainfolder ]"
    fi

    if [ ! -d "$mainfolder" ]; then 
        mkdir $mainfolder
        echo "[ Created $mainfolder ]"
    fi

}


# Modular Bashrc
mkdir -p ~/.bashrc.d/scripts-needed
mkdir -p ~/.bashrc.d/scripts-enabled
mkdir -p ~/.bashrc.d/scripts-available
if [ -d ~/.bashrc.d ]; then
    for needed in ~/.bashrc.d/scripts-needed/*.sh; do
        [ -r "$needed" ] && source "$needed"
    done                                                                                                                                                                                      
    unset needed
    for file in ~/.bashrc.d/scripts-enabled/*.sh; do
        [ -r "$file" ] && source "$file"
    done
    unset file

fi 

