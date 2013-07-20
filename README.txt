Here is my 7400 competition project, a CPLD based 8x8 game-of-life.

http://www.youtube.com/watch?v=2Ykv4kL7CUk&feature=youtu.be

Algorithm:
The simple game-of-life algorithm use a double-buffered memory in the size of the playing field. memory B is updated based on the content of memory A, and then either memory B is copied back into A, or the next generation is updating memory A based on memory B. When we look closer, however, we see that we only need to double buffer slightly more than one row (one row plus one cell), because the row below and the cell to the right of the center cell are yet to be updated.
The actual algorithm can be understood by looking at the picture below:
A 64 bit cyclic shift register is shifted to the right on every cycle. cell 0 is always the center cell, and a 6 bit row/column counter tracks the logical position of this cell. The neighbouring cells are collected, taking into account the playing field edges (we dont wrap around), and the resulting nine bits are summed. The sum output and current cell value are used to calculate the new cell value. The output value is then pushed into a shift register so that the new value won't affect the remaining calculation for this generation. The shift register replaces the old value at the point where it can no longer affect current gen calculations.
New starting patters can be entered by a joystick that moves up/down/left/right and a center button that toggles the current cell value.
The next gen is calculated by pressing a switch.

Implementation:
The project was coded in Verilog, using many small modules. The reason for that was that I wanted to be able to easily fit it into multiple XC9572XL boards I had. The naive approach would have been to put the large data shift register in one device, and the rest of the logic in a 2nd device, but this turned out to be impossible due to lack of I/O's in the other device. I ended up parametrically splitting the data array between the two devices so I can easily balance a few macorcells here or there in each device, if the need arises. I also made sure the design fits in an XC2C128 device I had.
The design itself is fully parameterized, and changing the X,Y parameter at the top level will infer the correct logic for any size chosen. Two extra redundant parameters, LOG2X and LOG2Y were added because Icarus Verilog does not support constant functions yet (which would have enabled us to calculate the LOG2 value within each block).
A test bench was prepared that generated a test pattern, and watched the LED output signals to reconstruct the display on each generation. The output was then displayed.

A third device was added for side tasks such as debouncing the input switches, dividing the original clock, and leaving room for a future capacitive touch input.

Modules:
life_xc9572xl_1.v, life_xc9572xl_2.v :
Top level netlists, containing nothing but instances of lower level modules. Implementation is trivial, since every two signals that needs to be connected between any modules share the exact same name everywhere.

life_data_high.v, life_data_low.v :
These files contains the data shift register, and also supports modifying the data based on the input switch (for entering a new starting position). life_data_high also contains the new cell input.

life_cnt.v:
This 6 bit counter keeps track of the current cell being processed. This value is used for display refresh and for tracking the board boundaries since we don't wraparound (and even if we did wraparound, we would need to take different cells when we reach the board edge). This counter runs freely whether we advance to the next generation or not. When the counter wraps around we also calculate a separate flag that tells us whether to update the next gen or not.
In addition, it generates a flip signal that is active only when the counter is 0, to ensure that the cursor always points to the same location when it is not moving.

life_cursor.v :
keeps track of the location of the current cell to be entered, by watching the up/down/left/right inputs from the joystick.
It also contains the same flip signal as life_cnt (for the other CPLD).

life_neighbour.v:
Takes the value of the neighbouring cells as an input, and masks those that are at the edge of the board.

life_sum.v:
Takes the masked neighbour values, and sums them up in two stages. First 3 groups of 3 inputs are summed in parallel, and then a sum of these three, 2-bit numbers, is summed again. Since the result can only be in the range 0-9, we drop the MSB since the only ambiguous values 0/8 or 1/9 both yields a cell value of 0.

life_pipe.v:
Takes the num result, and pipes it for X+1 stages until it can be pushed back into the main data shift register.

life_row:
Generate a 1-hot value for the LED matrix driver based on the counter value.

life_col:
Sample the current line for the LED display every time the counter moves to a new row.

cap_touch:
This is the entire 3rd support CPLD that handles auxiliary functions:
clock generation (dividing main clock by 1023 for the other CPLD), and further dividing the result by 127 for the debouncing logic.
Reading keys, debouncing them, and outputting only a single pulse on the falling edge of the slower output clock.
In the future, this will be used for reading the capacitive touch sensor.

Board construction:
The design was build on a prototype board, with 3 XC9572XL breakout boards from seeed (these are the cheap v1 boards with one missing I/O). The boards (and all other components) were soldered to the board in a few places just to hold them still, and the actual connections were all done via wire-wrap. In addition to the breakout boards, we also have onboard:
1 Oscillator socket
USB type B socket for 5V
A digital thumb joystick (the one seeed is selling).
ULN2803A for the low-side LED driver.
74LS245 for the high side LED driver (A 74LS244 is fine, but I hate its pinout)
8 series resistors for limiting the LED current.
One 8x8 LED matrix
Pins for hooking up a TI Capacitive touch booster pack that I intened to use as an input instead of the joystick (still not working, to be handled by the 3rd CPLD).

Due to lack of time, and my limited Eagle experience (I'm an ASIC guy on my day job) I had no time to add a schematic.
The connections can be easily inferred from the UCF files that dscribes the CPLD pin names.
pins with identical names on different CPLDs should be connected.
The row<n> pins drive a ULN2803A darlington sink driver.
The col<n> pins drive a 74LS245 as a source driver. (enable is permanently on, and direction is fixed from B to A).
The 74LS245 is driving the 8x8 LED matrix through series resistors.  A high value of 1.1K was chosen since it was bright enough, and limited the total currrent. The resistors are mounted below the 8x8 LED matrix so they are not visible on the picture.
A 23MHz oscillator is driving the cap_touch CPLD.
The mini-joystick is driving the key_XXX pins on the cap_touch CPLD (common pin is grounded, and there are pullups for every input.

Final words:
The board was simulated using Icarus Verilog
The Open Logic Sniffer with Jawi's client was used for actual HW testing.
A Bus Pirate v3a was used for programming the XSVF files.
