#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  if [[ $1 =~ ^[1-7]$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
      exit 0
    else
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
    fi
  elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]
  then
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
    if [[ -z $SYMBOL ]]
    then
      echo "I could not find that element in the database."
      exit 0
    else
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
    fi
  else
    NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
    if [[ -z $NAME ]]
    then
      echo "I could not find that element in the database."
      exit 0
    else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
    fi
  fi
  TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi