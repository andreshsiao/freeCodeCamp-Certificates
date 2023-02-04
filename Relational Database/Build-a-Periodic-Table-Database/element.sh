#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # check if argument is a valid atomic number
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
    if [[ -z $ELEMENT_NAME ]]
    then
      echo "I could not find that element in the database."
      exit
    else
      ELEMENT_ATOMIC_NUMBER=$1
      ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER ")
    fi
  else
    # check if argument is a valid element name
    ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
    if [[ -z $ELEMENT_ATOMIC_NUMBER ]]
    then
      # check if argument is a valid element symbol
      ELEMENT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
      if [[ -z $ELEMENT_ATOMIC_NUMBER ]]
      then
        echo "I could not find that element in the database."
        exit
      else
        ELEMENT_SYMBOL=$1
        ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
      fi
    else
      ELEMENT_NAME=$1
      ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
    fi
  fi
  ELEMENT_TYPE=$($PSQL "SELECT type FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
  ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
  ELEMENT_MELT=$($PSQL "SELECT melting_point_celsius FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
  ELEMENT_BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties LEFT JOIN types USING(type_id) WHERE atomic_number = $ELEMENT_ATOMIC_NUMBER")
  echo "The element with atomic number $ELEMENT_ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELT celsius and a boiling point of $ELEMENT_BOIL celsius."
else
  echo Please provide an element as an argument.
fi

