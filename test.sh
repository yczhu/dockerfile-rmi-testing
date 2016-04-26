#!/bin/bash

# Check the client logs

if grep -q "Pong 0" client.out;
  then
    if grep -q "Pong 1" client.out; 
    then
      if grep -q "Pong 2" client.out;
        then
          if grep -q "Pong 3" client.out;
            then echo "4 Tests Completed, 0 Tests Failed";
          else echo "3 Tests Completed, 1 Tests Failed"
          fi
      else echo "2 Tests Completed, 2 Tests Failed" 
      fi
    else echo "1 Tests Completed, 3 Tests Failed"
    fi
  else echo "0 Tests Completed, 4 Tests Failed";
fi 
