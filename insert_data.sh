#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")
# Script to insert data from games.csv into worldcup database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != winner || $OPPONENT != opponent ]]
then
   # get team_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  
  # if not found
  if [[ -z $TEAM_ID || -z $TEAM2_ID ]]
then
   # insert team
  INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  INSERT_TEAM2_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  
fi
  # get new team_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  
fi
  # get winner_id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  # get opponent_id
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  # insert into games table
  INSERT_INTO_GAMES_RESULT="$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")"
  if [[ $INSERT_INTO_GAMES_RESULT == "INSERT 0 1" ]]
  then
  echo "Inserted into games, $YEAR $ROUND"
  fi

 
 
  
  done