#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~"
echo -e "\n~~~ What can I do for you today? ~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  LIST_SERVICES=$($PSQL "SELECT * FROM services")
  echo "$LIST_SERVICES" | while read SERVICE_ID BAR NAME
  do
    ID=$(echo $SERVICE_ID | sed 's/ //g')
    SERVICE=$(echo $NAME | sed 's/ //g')
    echo "$ID) $SERVICE"
  done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT_MENU ;;
    2) APPOINTMENT_MENU ;;
    3) APPOINTMENT_MENU ;;
    4) EXIT ;;
    *) MAIN_MENU "Invalid service. What can I do for you today?" ;;
  esac
}

APPOINTMENT_MENU() {
  echo -e "\nCan I get your phone number?"
  read CUSTOMER_PHONE
  CHECK_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CHECK_CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have your record, what is your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_NAME=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")


  echo -e "\nWhat time would you like to have your appointment?"
  read SERVICE_TIME
  INSERT_APPOINTMENT_TIME=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  
  if [[ $INSERT_APPOINTMENT_TIME == "INSERT 0 1" ]]
  then
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU