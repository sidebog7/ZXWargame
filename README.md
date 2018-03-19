# ZXWargame
Wargame based on the Input type-in but in assembler

The basic version kicks off in this issue [Input](https://archive.org/details/Input_Vol_4_No_40_1997_Marshall_Cavendish_GB)

## Compiling
To compile use [Pasmo](http://pasmo.speccy.org/) and the following command line:

`pasmo -d --tapbas Wargame.asm Wargame.tap > wgdebug.asm`

This creates a .tap file called Wargame and also outputs debug ASM code to wgdebug.asm
