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
- `tone` is kept as a basic triangle wave, now taking direct data from siren instead of wail, which was no longer needed for our project.
- `dac_if` will also be one of the lowest and be used as a digital to analog converter.
- `siren` is the top of our hiearchy. We use siren to directly send data to tone, having the pitch be the value input by our keypad. Siren also sends the data to hexcalc to start taking the input from the keypad, as well as calling vga_top to initialize the display. The data from keypad is sent directly here, distributing the value directly to both generating audio and video.

## Part 2 - Input from keypad
- We would use Lab 4 as our main source of reference, of how to use the hex keypad.
- `leddec 16` we take the output of data from the keypad and instead change the base code to output to a display based on the pitch that the key is mapped to.
- `keypad` we don't need to touch, but outputs the state of each button
- `hexcalc` Originally we modified this code to collect inouts for both addition and subraction. We change this to instead send to siren as a replacement, solely using the addition programming. We have also added a 3 digit limiter for the input using a counter system, similar to the 4 digit limiter we made for the original lab

## Part 3 - Mapping to Display
- We would use Lab 3 as our main source of reference, of understanding how to code different colors/shapes as a visual on a monitor.
- `vga_top` is modified to take the keypad input and send it to ball
- `Vga_sync` included but not modified
- `clk_wiz` files are also included but not modified
- `ball` generates both the color and position of a ball, which we modify to instead react based on inputs from `hexcalc`. We generate a veritcal green bar on the screen (which is now entirely black). This bar's x position is determined by the value of the hexpad input, moving it further right the higher the number.

## Visualization of Project Hiearchy
![image](https://github.com/user-attachments/assets/71854ab0-ccc3-4f93-9433-6f799e2e7a87)

## Code Running

  ![53C5EEE6-0DF2-4203-BC3A-3016EC2918F5_1_105_c](https://github.com/user-attachments/assets/d167631a-eb51-4a2c-88c3-33d9071eb7f2)

