#!/bin/bash

# Initial variables

roll() {
    # Argument1 := string with 'ndn' pattern to describe how many dice to roll and how many faces the dice have
    # Argument2 := empty variable to store the roll results in
    
    # Input Arguments Validation
    if [[ "$#" != 2 ]]; then
	echo "Wrong number of arguments for roll. The roll function takes 2 argument." 1>&2
	return 1
    fi

    if [[ ! "$1" =~ ^[0-9]{1,3}d[0-9]{1,3}$ ]]; then
	echo "Invalid argument. The roll function requires its first argument to follow this pattern: 'ndn' where number can be any number from 1-999." 1>&2
	return 1
    fi

    # Variable Assignment
    local -n dice=$2
    local num_of_dice=$(echo $1 | sed s/d.*//)
    local num_of_faces=$(echo $1 | sed s/.*d//)

    # Computed Variables Validation
    if [[ ! -z "${dice+x}" ]]; then
	echo "Invalid argument. The roll function requires an empty variable as its second argument." 1>&2
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

fate_check() {
    # Argument1 := chaos factor: number from 3 to 6
    # Argument2 := odds: number from -4 to 4
    # Argument3 := result disposition: "g" or "b" for good or bad

    # Input Arguments Validation
    if [[ "$#" != 3 ]]; then
	echo "Wrong number of arguments for fate_check. The fate_check function takes 2 argument." 1>&2
	return 1
    fi

    if [[ ! "$1" =~ [3-6] ]]; then
	echo "Invalid argument. The fate_check function requires its first argument (chaos factor) to be a number from 3-6." 1>&2
	return 1
    fi

    if [[ ! "$2" =~ ^-?[0-4]$ ]]; then
	echo "Invalid argument. The fate_check function requires its second argument (odds) to be a number from -4 to 4." 1>&2
	return 1
    fi
    
    if [[ ! "$3" =~ ^[g|G|b|B]$ ]]; then
	echo "Invalid argument. The fate_check function requires its third argument (result disposition) to be one of these characters {G, g, B, b}." 1>&2
	return 1
    fi

    # Print Arguments
    echo "chaos_factor: $1"
    echo "odds: $2"
    echo "result_disposition: $3"
    echo "---------"

    # Odds Modifier
    local -i odds_modifier=$(($2 * 2))

    # Chaos Factor Modifier
    local -i cf_modifier
    case "$1" in
	[3])
	    cf_modifier=2
	    case "$3" in
		[Bb]) cf_modifier=$((- $cf_modifier));;
	    esac
	    ;;
	[45]) cf_modifier=0;;
	[6]) cf_modifier=2
	    case "$3" in
		[Gg]) cf_modifier=$((- $cf_modifier));;
	    esac
	    ;;
    esac

    # Fate Check
    roll 2d10 fate_check_rolls
    local -i fate_check_total=0
    for i in "${fate_check_rolls[@]}"; do
	fate_check_total+=$i
    done
    fate_check_result=$(( $fate_check_total + $odds_modifier + $cf_modifier ))

    # Result

    echo "odds_modifier: $odds_modifier"
    echo "cf_modifier: $cf_modifier"
    echo "fate_check_total: $fate_check_total"
    echo "total: $fate_check_result"
    echo "----- Answer -----"
    
    if (( 10 < $fate_check_result )); then
	echo "yes"
    else
	echo "no"
    fi
}

fate_check $1 $2 $3
