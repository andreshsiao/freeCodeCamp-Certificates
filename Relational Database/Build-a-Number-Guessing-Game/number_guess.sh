#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=guessing_number -t --no-align -c"



WELCOME_PAGE () {
  echo "Enter your username:"
  read USERNAME
  USERNAME_RESULT=$($PSQL "SELECT user_name FROM users WHERE user_name='$USERNAME'")
  if [[ -z $USERNAME_RESULT ]]
  then
    INSERT_NEW_USER=$($PSQL "INSERT INTO users(user_name) VALUES('$USERNAME')")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    BEST_GAME=1001
    GAME_PLAYED=0
  else
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE user_name='$USERNAME'")
    BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE user_name='$USERNAME'")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
  NUM=$(( $RANDOM % 1000 + 1 ))
  GUESS_COUNT=0
  echo "Guess the secret number between 1 and 1000:"
  GUESS_PAGE
}

GUESS_PAGE () {
  
  read GUESS_NUM
  GUESS_COUNT=$(( $GUESS_COUNT + 1 ))
  if [[ ! $GUESS_NUM =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    GUESS_PAGE
  else
    if [[ $GUESS_NUM -gt $NUM ]]
    then
      echo "It's lower than that, guess again:"
      GUESS_PAGE
    elif [[ $GUESS_NUM -lt $NUM ]]
    then
      echo "It's higher than that, guess again:"
      GUESS_PAGE
    else
      GAMES_PLAYED=$(( $GAMES_PLAYED + 1 ))
      UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE user_name='$USERNAME'")
      if [[ $GUESS_COUNT -lt $BEST_GAME ]]
      then
        UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game = $GUESS_COUNT WHERE user_name='$USERNAME'")
      fi
      echo "You guessed it in $GUESS_COUNT tries. The secret number was $NUM. Nice job!"
    fi
  fi
}

WELCOME_PAGE