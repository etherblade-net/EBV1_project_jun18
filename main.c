/*Ethernet hardware encapsulator demonstration software (ver2.1) Dec.2016
* Developer: V.Efimov
* https://www.linkedin.com/in/vladimir-efimov
* Shared FIFO buffer code obtained from:
* https://stratifylabs.co/embedded%20design%20tips/2013/10/02/Tips-A-FIFO-Buffer-Implementation/
*/
#include <xuartlite_l.h>
#include <xintc_l.h>
#include <xparameters.h>
#include <xil_io.h>
#include <stdlib.h>
#include <string.h>

/* Shared FIFO buffer structure is defined.
* The FIFO buffer is used to exchange data between ISR and the main program.
*/
typedef struct {
	char *buf;
	int head;
	int tail;
	int size;
} fifo_t;


/* "fifo_init" initializes the shared FIFO buffer with the given
* size and head/tail counters.
*/
void fifo_init(fifo_t *f, char *buf, int size) {
	f->head = 0;
	f->tail = 0;
	f->size = size;
	f->buf = buf;
}


/* "fifo_write" to be used in the ISR that copyes nbytes of data
* from 'buf' to the shared FIFO buffer.
* If the head runs into the tail (FULL condition) then not all bytes will be written
* The number of bytes written is returned.
*/
int fifo_write(fifo_t *f, const void *buf, int nbytes) {
	int i;
	const char *p;
	p = buf;
	for (i=0; i < nbytes; i++){
		//first check to see if there is space in the buffer
		if ((f->head + 1 == f->tail) || ((f->head + 1 == f->size) && (f->tail == 0))) {
			return i;
		} else {
			f->buf[f->head] = *p++;
			f->head++;
			if (f->head == f->size) {	//check for wrap-around
				f->head = 0;
				}
			}
		}
		return nbytes;
}


/* "fifo_read" to be used in the main program that copyes nbytes of data
* from shared FIFO buffer to 'buf'.
* If the tail has reached the head (EMPTY condition), not all bytes are read.
* The number of bytes read is returned.
*/
int fifo_read(fifo_t *f, void *buf, int nbytes) {
	int i;
	char *p;
	p = buf;
	for (i=0; i < nbytes; i++){
		if (f->tail != f->head) {		//see if any data is available
			*p++ = f->buf[f->tail]; 	//grab a byte from the buffer
			f->tail++;					//increment the tail
			if (f->tail == f->size) {	//check for wrap-around
				f->tail = 0;
			}
		} else {
			return i;					//number of bytes read
		}
	}
	return nbytes;
}

extern fifo_t *uart_fifo;
void uart_int_handler(void *baseaddr_p) {
	char rdchar;
	/* till uart hardware FIFO is empty */
	while (!XUartLite_IsReceiveEmpty(XPAR_AXI_UARTLITE_0_BASEADDR)) {
		rdchar = XUartLite_RecvByte(XPAR_AXI_UARTLITE_0_BASEADDR);
		fifo_write(uart_fifo, &rdchar, 1);
	}
}

void print_banner() {
	print("\033[2J"); // Clear the screen
    print("\n\r******************************************************");
    print("\n\r*                  EtherBlade Ver.1                  *");
    print("\n\r*           demonstration software (rev1.0)          *");
    print("\n\r******************************************************\r\n");
    print("*\r\n");
    print("Command format(HEX) - :OBAAAADDDD\r\n");
    print("Start new command with ':';\r\n");
    print("O-opcode(4bit), B-memory block(4bit), AAAA-address(16bit), DDDD-data(16bit);\r\n");
    print("Type '?' for this menu.\r\n");
    print("\r\n");
}

/* Allocating memory for the temporary characters storage and memory for shared FIFO buffer
* structure that uses that characters storage memory.
*/
char fifostring[300];
fifo_t *uart_fifo;

int main(void)
{
int cnt;
int charnum = 0;
char displaychar;
char badchar;				//Incorrectly entered char

char hex_char[11];              // hex input string
char hexopcode_char[2];			// opcode symbol from hex
char hexmemblock_char[2];		// memory block from hex
char hexmemoffset_char[5];		// memory block offset
char hexmemdata_char[5];		// write data from hex

int hexopcode_int;
int hexmemblock_int;
int hexmemoffset_int;
int hexmemdata_int;

uint32_t fullrwaddress;
uint8_t notokey;
u32 regvalue;

	/* Initialize shared FIFO buffer */
	fifo_init(uart_fifo, fifostring, 300);

	/* Enable MicroBlaze exception */
   microblaze_enable_interrupts();

	/* Connect uart interrupt handler that will be called when an interrupt
	* for the uart occurs*/
	XIntc_RegisterHandler(XPAR_INTC_0_BASEADDR,XPAR_AXI_INTC_0_AXI_UARTLITE_0_INTERRUPT_INTR,(XInterruptHandler)uart_int_handler,(void *)XPAR_AXI_UARTLITE_0_BASEADDR);

	/* Start the interrupt controller */
	XIntc_MasterEnable(XPAR_INTC_0_BASEADDR);

	/* Enable uart interrupt in the interrupt controller */
	XIntc_EnableIntr(XPAR_INTC_0_BASEADDR, XPAR_AXI_UARTLITE_0_INTERRUPT_MASK);

	/* Enable Uartlite interrupt */
	XUartLite_EnableIntr(XPAR_AXI_UARTLITE_0_BASEADDR);

	print_banner();
	/* Reading key inputs from shared FIFO buffer and processing them */
	while (1) {
	charnum = 0;
	while (charnum < 10) {
		cnt = fifo_read(uart_fifo, &displaychar, 1);
		if ( cnt == 1 ) {
			switch(displaychar) {
						case 13:
							//ignore enter
							break;
						case 10:
							//ignore newline
							break;
						case ':':
							//startnewinputline
							charnum = 0;
							xil_printf("\r>");
							break;
						case '?':
							//print banner
							charnum = 0;
							print_banner();
							break;
						default:
							//read other character
								hex_char[charnum] = displaychar;
								charnum++;
								xil_printf("%c", displaychar);
						break;
								}
						}
					}
	hex_char[11] = '\0';
	xil_printf("\r\n");
	xil_printf("INFO: Parsing: %s;\r\n", hex_char);
	//PARSING DATA HERE
	badchar = hex_char[strspn(hex_char, "0123456789abcdefABCDEF")];
	if (badchar != 0) {
	xil_printf("ERROR: Invalid non-hex symbol provided: %c; \r\n", badchar);
	}
	else
	{
	notokey = 0;
	memcpy(&hexopcode_char, &hex_char[0], 1);
	hexopcode_char[2] = '\0';
	memcpy(&hexmemblock_char, &hex_char[1], 1);
	hexmemblock_char[2] = '\0';
	memcpy(&hexmemoffset_char, &hex_char[2], 4);
	hexmemoffset_char[4] = '\0';
	memcpy(&hexmemdata_char, &hex_char[6], 4);
	hexmemdata_char[4] = '\0';
	xil_printf("INFO: CHAR.OPC-MEMBLK-MEMOFST-DTA: %s-%s-%s-%s;\r\n", hexopcode_char, hexmemblock_char, hexmemoffset_char, hexmemdata_char);

	hexopcode_int = (int)strtol(hexopcode_char, NULL, 16);
	hexmemblock_int = (int)strtol(hexmemblock_char, NULL, 16);
	hexmemoffset_int = (int)strtol(hexmemoffset_char, NULL, 16);
	hexmemdata_int = (int)strtol(hexmemdata_char, NULL, 16);

	xil_printf("INFO: NUM.OPC-MEMBLK-MEMOFST-DTA: 0x%08x-0x%08x-0x%08x-0x%08x;\r\n", hexopcode_int, hexmemblock_int, hexmemoffset_int, hexmemdata_int);

	switch(hexmemblock_int) {
							case 0x0:
								fullrwaddress = XPAR_AXI_BRAM_CTRL_1_S_AXI_BASEADDR + hexmemoffset_int;
								break;
							case 0x1:
								fullrwaddress = XPAR_AXI_BRAM_CTRL_2_S_AXI_BASEADDR + hexmemoffset_int;
								break;
							default:
								//Unknown memory block
								xil_printf("ERROR: Unknown memory block provided: 0x%08x; \r\n", hexmemblock_int);
								notokey = 1;
							break;
									}
	xil_printf("INFO: Final Address-0x%08x;\r\n", fullrwaddress);

	if (notokey == 0) {
	switch(hexopcode_int) 	{
								case 0x0:
									//write
									Xil_Out32(fullrwaddress, hexmemdata_int);
									xil_printf("OK: WRITE DATA: 0x%08x to ADDRESS: 0x%08x;\r\n", hexmemdata_int, fullrwaddress);
									break;
								case 0x1:
									//read
									regvalue = Xil_In32(fullrwaddress);
									xil_printf("OK: READ DATA VALUE: 0x%08x from ADDRESS: 0x%08x;\r\n", regvalue, fullrwaddress);
									break;
								default:
									//Unknown opcode provided
									xil_printf("ERROR: Unknown opcode provided: 0x%08x; \r\n", hexopcode_int);
								break;
							}
					}
	}
	}
	return 0;
}
