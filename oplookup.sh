function SRName() {
  local address=$1

  case $address in
  00)
    echo -n "INDF"
    ;;
  01)
    echo -n "TMR0"
    ;;
  03)
    echo -n "STATUS"
    ;;
  04)
    echo -n "FSR"
    ;;
  05)
    echo -n "PORTA"
    ;;
  07)
    echo -n "PORTC"
    ;;
  *)
    # TODO
    echo -n "0x$address"
    ;;
  esac

}

function bin2hex() {
  local bin=$1
  printf '%02x\n' "$((2#$bin))"

}

function ADDLW() {
  # w <- k+W
  local code=$1
  local k=${code:6:8}
  k=`bin2hex $k`

  echo "ADDLW 0x$k"
}

function BCF() {
  # Clear bit b of f
  local code=$1
  local b=${code:4:3}
  local f=${code:7:7}
  b=`bin2hex $b`
  f=`bin2hex $f`
  f=`SRName $f`

  echo "BCF $f,0x$b"
}

function BSF() {
  # Set bit b of f
  local code=$1
  local b=${code:4:3}
  local f=${code:7:7}
  b=`bin2hex $b`
  f=`bin2hex $f`
  f=`SRName $f`

  
  echo "BSF $f,0x$b"

}

function CLRF() {
  # dest <- 0
  local code=$1
  local f=${code:7:7}
   f=`bin2hex $f`
   f=`SRName $f`
   echo "CLRF $f"
}

function DECFSZ() {
  # dest <- f-1 then skip if zero
  local code=$1
  local f=${code:7:7}
  local d=${code:6:1}
  f=`bin2hex $f`

  case $d in
    0)
      d='W'
      ;;
    1)
      d='f'
      ;;
    *)
      ;;
  esac

  echo "DECFSZ 0x$f,$d"
}

function GOTO() {
  # Jump to address k
  local code=$1
  local k=${code:3:11}
  k=`bin2hex $k`

  echo "GOTO 0x$k"
}

function MOVLW() {
  # W <- k
  local code=$1
  local k=${code:6:8}
  k=`bin2hex $k`

  echo "MOVLW 0x$k"
}

function MOVWF() {
  # f <- W
  local code=$1
  local f=${code:7:7}
  f=`bin2hex $f`

  echo "MOVWF 0x$f"
}

function bin2op() {
  code="$1"

  # Drop first two MSB to make 14bit
  code=`sed 's/^.\{2\}//' <<< $code`

  case $code in
   00000000000000)
     # No operation (MOVW 0,W)
     echo "NOP"
     ;;
   00000000001000)
     # Return from subroutine, W unmodified
     echo "RETURN"
     ;;
   00000000001001)
     # Return from interrupt
     echo "RETFIE"
     ;;
   00000001100010)
     # Copy W to OPTION register (deprecated)
     echo "OPTION"
     ;;
   00000001100011)
     # Go into standby mode
     echo "SLEEP"
     ;;
   00000001100100)
     # Restart watchdog timer
     echo "CLRWDT"
     ;;
   0000001*)
     MOVWF $code
     ;;
   000001*)
     CLRF $code
     ;;
   000010*)
     # dest <- f-W (dest <- f + ~W+1)
     echo "SUBWF f,d"
     ;;
   000011*)
     # dest <- f-1
     echo "DECF f,d"
     ;;
   000100*)
     # dest <- f | W, logical inclusive or
     echo "IORWF f,d"
     ;;
   000101*)
     # dest <- f & W, logical and
     echo "ANDWF f,d"
     ;;
   000110*)
     # dest <- f ^ W, logical exclusive or
     echo "XORWF f,d"
     ;;
   000111*)
     # dest <- f+W
     echo "ADDWF f,d"
     ;;
   001000*)
     # dest <- f
     echo "MOVF f,d"
     ;;
   001001*)
     # dest <- ~f, bitwise complement
     echo "COMF f,d"
     ;;
   001010*)
     # dest <- f+1
     echo "INCF f,d"
     ;;
   001011*)
     DECFSZ $code
     ;;
   001100*)
     # dest <- CARRY <<7 | f>>1, rotate right through carry
     echo "RRF f,d"
     ;;
   001101*)
     # dest <- f<<1 | CARRY, rotate left through carry
     echo "RLF f,d"
     ;;
   001110*)
     # dest <- f<<4 | f >>4, swap nibbles
     echo "SWAPF f,d"
     ;;
   001111*)
     # dest <- f+1, then skip if zero
     echo "INCFSZ f,d"
     ;;
   0100*)
     BCF $code
     ;;
   0101*)
     BSF $code
     ;;
   0110*)
     # Skip if bit b of f is clear
     echo "BTFSC f,b"
     ;;
   0111*)
     # Skip if bit b of f is set
     echo "BTFSS f,b"
     ;;
   100*)
     # Call subroutine 
     echo "CALL k"
     ;;
   101*)
     GOTO $code
     ;;
   1100*)
     MOVLW $code
     ;;
   1101*)
     # W <- k, then return from subroutine
     echo "RETLW k"
     ;;
   111000*)
     # W <- k | W, bitwise logical or
     echo "IORLW k"
     ;;
   111001*)
     # W <- k & W, bitwise and
     echo "ANDLW k"
     ;;
   111010*)
     # W <- k^W, bitwise exclusive or
     echo "XORLW k"
     ;;
   11110*)
     # W <- k-W (dest <- k+~W+1)
     echo "SUBLW k"
     ;;
   11111*)
     ADDLW $code
     ;;
   *)
     echo "NOT Implemented $code" 
   esac


}
