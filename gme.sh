#!/bin/bash

# Initial variables

roll() {
    # Input Arguments Validation
    if [[ "$#" != 2 ]]; then
	echo "Wrong number of arguments for roll. Roll takes 2 argument." 1>&2
	return 1
    fi

    if [[ ! "$1" =~ ^[0-9]{1,3}d[0-9]{1,3}$ ]]; then
	echo "Invalid argument. The roll command requires its first argument to follow this pattern: 'ndn' where number can be any number from 1-999." 1>&2
	return 1
    fi

    # Variable Assignment
    local -n dice=$2
    local num_of_dice=$(echo $1 | sed s/d.*//)
    local num_of_faces=$(echo $1 | sed s/.*d//)

    # Computed Variables Validation
    if [[ ! -z "${dice+x}" ]]; then
	echo "Invalid argument. The roll command requires an empty variable as its second argument." 1>&2
	return 1
    fi
    
    if (( num_of_dice == 0 )); then
	echo "Invalid argument. 0 is not a valid number of dice." 1>&2
	return 1;
    fi

    if (( num_of_faces == 0 )); then
	echo "Invalid argument. 0 is not a valid number of faces for a die." 1>&2
	return 1;
    fi

    for (( i=0; i < num_of_dice; i++ )); do
	dice[$i]=$(( ( RANDOM % num_of_faces ) + 1 ))
    done
}

face_chekc() {
    echo "Start fatecheck"
}

