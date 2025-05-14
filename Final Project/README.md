# Final Project - Audio Spectrum Visualizer

By: Thomas Carchietta and Tejal Dhiman

## Overview
Our plan for our final VHDL project is to incorporate the Hex keypad and speaker alongside the NEXYS A7 board.
After understanding the past labs, we decided to create a tone, map it to 1 on the keypad, and then pitch up the tone for each subsequent number.
Depending on which key is pressed on the pad, we will map it to a frequency that will show up in the form of color/shape on a graph using a monitor.

## Planning Stage
To begin planing, we looked through the past labs in order to understand which files we could work with and understand how we would map each aspect of the project to each vhdl file.
We would then create a top-most file that would call on these past files to combine them together.
By incorporating our learned knowledge, given files, edited files from Labs 3, 4, and 5, as well as creating our own vhdl code to coincide with the others, we should be able to step by step include each of these ideas to create an audio spectrum visualizer. 

## Part 1 - Generating tone
- We would use lab 5 as our main source of reference, and we take lab 5 files to begin.
- `tone` will be our lowest file in the hierarchy, and we build the rest of our project on this file.
- `dac_if` will also be one of the lowest and be used as a digital to analog converter.
- `siren` will be highest in hierarchy, and will call wail in order to manipulate the tone, and use `dac_if` to convert it from a digital to analog signal.

## Part 2 - Input from keypad
- We would use Lab 4 as our main source of reference, of how to use the hex keypad.
- `leddec 16` we take the output of data from the keypad and instead change the base code to output to a display based on the pitch that the key is mapped to.
- `keypad` we don't need to touch, but outputs the state of each button
- `hexcalc` Originally we modified this code to collect inouts for both addition and subraction. We change this to instead send to siren as a replacement.

## Part 3 - Mapping to Display
- We would use Lab 3 as our main source of reference, of understanding how to code different colors/shapes as a visual on a monitor.
- Calling the previous `leddec.vhd` file here.
- `Vga_sync` included but not modified
- `clk_wiz` files are also included but not modified
- `ball` generates both the color and position of a ball, which we modify to instead react based on inputs from `hexcalc`
- `TBD` is our top most file. It calls on both `hexcalc` as well as `siren` to run them simultaneously.

## Code Running

  ![53C5EEE6-0DF2-4203-BC3A-3016EC2918F5_1_105_c](https://github.com/user-attachments/assets/d167631a-eb51-4a2c-88c3-33d9071eb7f2)

