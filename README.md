# WIP picdis
PIC disassembler (14bit) 

Given
```
:02000000FC2FD3
:100FB40083168701831207151A30F2005E30F100A0
:100FC4006E30F000F00BE42FF10BE42FF20BE42F62
:100FD4000000831207111A30F2005E30F1006E3007
:100FE400F000F00BF32FF10BF32FF20BF32F0000B3
:0C0FF400DC2F0028F301F4018301DA2F48
:08400000FF3FFF3FFF3FFF3FC0
:02400E00F73F7A
:00000001FF
```

```sh
$ ./picdis.sh 
Program data
| line:    1 | address:    0 || 0010111111111100 |GOTO 7fc
Program data
| line: 2011 | address:  7da || 0001011010000011 |BSF STATUS,0x05
| line: 2012 | address:  7db || 0000000110000111 |CLR f,d
| line: 2013 | address:  7dc || 0001001010000011 |BCF f,b
| line: 2014 | address:  7dd || 0001010100000111 |BSF PORTC,0x02
| line: 2015 | address:  7de || 0011000000011010 |MOVLW k
| line: 2016 | address:  7df || 0000000011110010 |MOVWF f
| line: 2017 | address:  7e0 || 0011000001011110 |MOVLW k
| line: 2018 | address:  7e1 || 0000000011110001 |MOVWF f
Program data
| line: 2019 | address:  7e2 || 0011000001101110 |MOVLW k
| line: 2020 | address:  7e3 || 0000000011110000 |MOVWF f
| line: 2021 | address:  7e4 || 0000101111110000 |DECFSZ f,d
| line: 2022 | address:  7e5 || 0010111111100100 |GOTO 7e4
| line: 2023 | address:  7e6 || 0000101111110001 |DECFSZ f,d
| line: 2024 | address:  7e7 || 0010111111100100 |GOTO 7e4
| line: 2025 | address:  7e8 || 0000101111110010 |DECFSZ f,d
| line: 2026 | address:  7e9 || 0010111111100100 |GOTO 7e4
Program data
| line: 2027 | address:  7ea || 0000000000000000 |NOP
| line: 2028 | address:  7eb || 0001001010000011 |BCF f,b
| line: 2029 | address:  7ec || 0001000100000111 |BCF f,b
| line: 2030 | address:  7ed || 0011000000011010 |MOVLW k
| line: 2031 | address:  7ee || 0000000011110010 |MOVWF f
| line: 2032 | address:  7ef || 0011000001011110 |MOVLW k
| line: 2033 | address:  7f0 || 0000000011110001 |MOVWF f
| line: 2034 | address:  7f1 || 0011000001101110 |MOVLW k
Program data
| line: 2035 | address:  7f2 || 0000000011110000 |MOVWF f
| line: 2036 | address:  7f3 || 0000101111110000 |DECFSZ f,d
| line: 2037 | address:  7f4 || 0010111111110011 |GOTO 7f3
| line: 2038 | address:  7f5 || 0000101111110001 |DECFSZ f,d
| line: 2039 | address:  7f6 || 0010111111110011 |GOTO 7f3
| line: 2040 | address:  7f7 || 0000101111110010 |DECFSZ f,d
| line: 2041 | address:  7f8 || 0010111111110011 |GOTO 7f3
| line: 2042 | address:  7f9 || 0000000000000000 |NOP
Program data
| line: 2043 | address:  7fa || 0010111111011100 |GOTO 7dc
| line: 2044 | address:  7fb || 0010100000000000 |GOTO 0
| line: 2045 | address:  7fc || 0000000111110011 |CLR f,d
| line: 2046 | address:  7fd || 0000000111110100 |CLR f,d
| line: 2047 | address:  7fe || 0000000110000011 |CLR f,d
| line: 2048 | address:  7ff || 0010111111011010 |GOTO 7da
Program data
| line: 8193 | address: 2000 || 0011111111111111 |ADDLW k
| line: 8194 | address: 2001 || 0011111111111111 |ADDLW k
| line: 8195 | address: 2002 || 0011111111111111 |ADDLW k
| line: 8196 | address: 2003 || 0011111111111111 |ADDLW k
Program data
| line: 8200 | address: 2007 || 0011111111110111 |ADDLW k
EOF
```

## TODO

1. Complete opcodes
2. Complete register lookups
3. Remove input file hardcoding
4. Create common functions / code cleanup
