#!/bin/bash
# PIC mid-range (14 bit) disassembler
#
# James Elsdon
# 2023 WIP
#
source oplookup.sh

BYTES=0
OPCODES=0

function readBytes() {
  bytes=$1 
  BYTES=$((16#$bytes))
}

function parseAddress() {
  address=$1

  # convert to decimal
  address=$((16#$address))

  # Divide by 2
  address=$(($address/2))
  echo $address

}

function dataType() {
  dType=$1

  case $dType in
  00)
    #echo "Program data"
    ;;
  01)
    echo "EOF"
    ;;
  04)
    echo "Extended address"
    ;;
  *)
    echo "ERROR" 
  esac
}

function parseOpCodes() {
  opCodes=$1

  # Reorder address
  opCodes=${opCodes:2:2}${opCodes:0:2}

  # convert to binary
  OPCODES=`echo "ibase=16; obase=2 ; $opCodes"  |bc  | xargs printf '%016d\n'`

  echo -n "$OPCODES |"
  bin2op $OPCODES
}

function validateChecksum() {
  checkSum=$1

  checkSumCode=${checkSum:0-2}
  checkSum=${checkSum::-2}

  store=0
  for i in $(fold -w2 <<< $checkSum); do
    store=`printf "0x%X" $((0x$i + $store))`
  done

  store=`sed 's/^.\{2\}//' <<< $store`
  BIN=$(echo "obase=2; ibase=16; $store" | bc)
  BIN=$(printf "%08d\n" $BIN)
  BIN=$(tr 01 10 <<< $BIN)
  BIN=`echo $((2#$BIN))`
  BIN=`echo $(($BIN + 1))`
  BIN=`echo "obase=16; ibase=10; $BIN" |bc`
  BIN=${BIN:0-2}

  if ! [ $BIN == $checkSumCode ]
  then
    echo "checksum failed $BIN != $checkSumCode" 
  fi

}

function parseFuses() {
  local fuses=$1

  # Reorder address
  fuses=${fuses:2:2}${fuses:0:2}

  # convert to binary
  fuses=`echo "ibase=16; obase=2 ; $fuses"  |bc  | xargs printf '%016d\n'`

  echo -n "$fuses |Fuses: "

  echo -n "FOSC="
  case ${fuses:13:3} in
    000)
      echo -n "LP"
      ;;
    001)
      echo -n "XP"
      ;;
    010)
      echo -n "HS"
      ;;
    011)
      echo -n "EC"
      ;;
    100)
      echo -n "INTOSIO"
      ;;
    101)
      echo -n "INTOSC"
      ;;
    110)
      echo -n "RCIO"
      ;;
    111)
      echo -n "RC"
      ;;
    *)
      ;;
  esac

  echo -n " WDTE="
  case ${fuses:12:1} in
    0)
      echo -n "Disabled"
      ;;
    1)
      echo -n "Enabled"
      ;;
    *)
      ;;
  esac

  echo -n " PWRTE="
  case ${fuses:11:1} in
    0)
      echo -n "Enabled"
      ;;
    1)
      echo -n "Disabled"
      ;;
    *)
      ;;
  esac

  echo -n " MCLRE="
  case ${fuses:10:1} in
    0)
      echo -n "RA3/MCLR-is-IO"
      ;;
    1)
      echo -n "RA3/MCLR-is-MCLR"
      ;;
    *)
      ;;
  esac

  echo -n " CP="
  case ${fuses:9:1} in
    0)
      echo -n "Enabled"
      ;;
    1)
      echo -n "Disabled"
      ;;
    *)
      ;;
  esac

  echo -n " CPD="
  case ${fuses:8:1} in
    0)
      echo -n "Enabled"
      ;;
    1)
      echo -n "Disabled"
      ;;
    *)
      ;;
  esac

  echo -n " BODEN="
  case ${fuses:6:2} in
    00)
      echo -n "Disabled"
      ;;
    01)
      echo -n "SBODEN"
      ;;
    10)
      echo -n "Enabled,Disabled-in-sleep"
      ;;
    11)
      echo -n "Enabled"
      ;;
    *)
      ;;
  esac

  echo -n " IESO="
  case ${fuses:5:1} in
    0)
      echo -n "Disabled"
      ;;
    1)
      echo -n "Enabled"
      ;;
    *)
      ;;
  esac

  echo -n " FCMEN="
  case ${fuses:4:1} in
    0)
      echo -n "Disabled"
      ;;
    1)
      echo -n "Enabled"
      ;;
    *)
      ;;
  esac

  echo
}

while read -r line
do
  if ! [[ $line =~ ^: ]]; then
    echo "Bad line $line"
    continue
  fi
  
  #echo $line
  line=`sed 's/^.\{1\}//' <<< $line`
  validateChecksum $line

  readBytes ${line:0:2}
  line=`sed 's/^.\{2\}//' <<< $line`

  address=`parseAddress ${line:0:4}`
  line=`sed 's/^.\{4\}//' <<< $line`

  dataType ${line:0:2}
  line=`sed 's/^.\{2\}//' <<< $line`

  for (( byte_num=0; byte_num < BYTES; byte_num+=2 ))
  do
    hexAddress=`printf '%4x\n' $address`
    (( address++ ))
    lineAddress=`printf '%4d\n' $address`
    echo -n "| line: $lineAddress | address: $hexAddress | "

    if [[ $lineAddress -gt 2048 ]]
    then
      if [[ $lineAddress -eq 8200 ]]
      then
        parseFuses ${line:0:4} 
      elif [[ $lineAddress -gt 8192 ]] && [[ $line -lt 8196 ]]
      then
        echo "ID Locations"
      fi
    else
      parseOpCodes ${line:0:4}
      line=`sed 's/^.\{4\}//' <<< $line`
    fi
  done

done < blinkenlights.X.production.hex
