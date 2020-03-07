#!/bin/bash

# Initial variables

roll() {
    if [[ $# != 1 ]]; then
	echo "Wrong number of arguments for roll. Roll only takes 1 argument." 1>&2;
	return 1;
    fi

    if [[ ! $1 =~ ^[0-9]{1,3}d[0-9]{1,3}$ ]]; then
	echo "Invalid argument. The roll command requires argument requires this pattern 'ndn' where number can be any number from 1-999." 1>&2;
	return 1;
    fi

    num_of_dice=$(echo $1 | sed s/d.*//);
    num_of_faces=$(echo $1 | sed s/.*d//);

    if (( num_of_dice == 0 )); then
	echo "Invalid argument. 0 is not a valid number of dice." 1>&2;
	return 1;
    fi

    if (( num_of_faces == 0 )); then
	echo "Invalid argument. 0 is not a valid number of faces for a die." 1>&2;
	return 1;
    fi

    echo "rolled: $1";
    echo "number of dice: $num_of_dice";
    echo "number of faces: $num_of_faces";

    echo "Result:";

    for (( i=1; i <= num_of_dice; i++ )); do
	echo $(( ( RANDOM % num_of_faces ) + 1 ));
    done
}


roll "$1";

