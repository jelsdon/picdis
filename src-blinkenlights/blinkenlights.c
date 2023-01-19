/*
 * File:   blinkenlights.c
 * Author: James Elsdon
 *
 */

#pragma config FOSC = EXTRCCLK // Oscillator Selection bits (INTOSC oscillator: CLKOUT function on RA4/OSC2/CLKOUT pin, I/O function on RA5/OSC1/CLKIN)
#pragma config WDTE = OFF       // Watchdog Timer Enable bit (WDT disabled)
#pragma config PWRTE = OFF      // Power-up Timer Enable bit (PWRT disabled)
#pragma config MCLRE = ON       // MCLR Pin Function Select bit (MCLR pin function is MCLR)
#pragma config CP = OFF         // Code Protection bit (Program memory code protection is disabled)
#pragma config CPD = OFF        // Data Code Protection bit (Data memory code protection is disabled)
#pragma config BOREN = ON       // Brown Out Detect (BOR enabled)
#pragma config IESO = ON        // Internal External Switchover bit (Internal External Switchover mode is enabled)
#pragma config FCMEN = ON       // Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is enabled)

#define _XTAL_FREQ 4000000
#define RANGE 40
#include <xc.h>

unsigned int waitTime=0;
void main(void) {
    TRISC = 0x00;
    while(1) {
        RC2 = 1;
        __delay_ms(5000);
        RC2 = 0;
        __delay_ms(5000);
   }
  return;
}
