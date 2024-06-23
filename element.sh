#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]; then
    if ! [[ $1 =~ ^[0-9]+$ ]]; then
        ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
                         FROM elements e 
                         INNER JOIN properties p USING(atomic_number) 
                         INNER JOIN types t ON p.type_id=t.type_id 
                         WHERE e.symbol='$1' OR e.name='$1'")
    else
        ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius 
                         FROM elements e 
                         INNER JOIN properties p USING(atomic_number) 
                         INNER JOIN types t ON p.type_id=t.type_ 
                         WHERE e.atomic_number=$1")
    fi

    if [[ -z $ELEMENT ]]; then
        echo "I could not find that element in the database."
    else
        IFS='|' read -r -a element_array <<< "$ELEMENT"
        for ((i = 0; i < ${#element_array[@]}; i++)); do
            element_array[$i]=$(echo ${element_array[$i]} | sed -e 's/^ *//g' -e 's/ *$//g')
        done
        echo "The element with atomic number ${element_array[0]} is ${element_array[1]} (${element_array[2]}). It's a ${element_array[3]}, with a mass of ${element_array[4]} amu. ${element_array[1]} has a melting point of ${element_array[5]} celsius and a boiling point of ${element_array[6]} celsius."
    fi
else
    echo "Please provide an element as an argument."
fi
