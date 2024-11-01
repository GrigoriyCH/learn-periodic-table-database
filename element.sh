#!/bin/bash

# Command
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Query element information
  ELEMENT_INFO=$($PSQL "
    SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
    FROM elements 
    INNER JOIN properties USING(atomic_number)
    INNER JOIN types USING(type_id)
    WHERE atomic_number::text = '$1' 
    OR symbol = INITCAP('$1') 
    OR name = INITCAP('$1');
  ")

  # Check if element was found
  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    # Output element information
    IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_INFO"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
