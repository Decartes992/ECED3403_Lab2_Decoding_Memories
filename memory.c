/*
Name: Iftekhar Rafi
ID: B00871031
Course: ECED 3403 Computer Architecture
Instructor: Larry Hughes

File Name: memory.c
File Purpose: This file contains the memory arrays and a function to display a range of memory.
*/

#include <stdio.h>
#include "loader.h"

// Define a 64 KiB word-addressable instruction memory array
unsigned short IMEM[IMEM_SIZE / 2];

// Define a 64 KiB byte-addressable data memory array
unsigned char DMEM[DMEM_SIZE];

// Function to display a range of memory
void displayMemory(unsigned char* memory, int start, int end) {
    // Loop from the start to the end of the memory range
    for (int i = start; i < end; i += HEX_BASE) {

        // Print the memory address
        printf("%04X: ", i);

        // Loop through each byte in the current memory word
        for (int j = 0; j < HEX_BASE; j++) {

            // If the current byte is within the memory range, print its value
            if (i + j < end) {
                printf("%02X ", memory[i + j]);
            }
            // Otherwise, print a placeholder
            else {
                printf("   ");
            }
        }

        printf(" ");

        // Loop through each byte in the current memory word again
        for (int j = 0; j < HEX_BASE; j++) {
            // If the current byte is within the memory range
            if (i + j < end) {
                unsigned char c = memory[i + j];
                // If the byte is a printable ASCII character, print it
                if (c >= ASCII_PRINTABLE_START && c <= ASCII_PRINTABLE_END) {
                    printf("%c", c);
                }
                // Otherwise, print a placeholder
                else {
                    printf(".");
                }
            }
            // If the current byte is outside the memory range, print a placeholder
            else {
                printf(" ");
            }
        }
        // Print a newline to separate memory words
        printf("\n");
    }
    // Print an extra newline for readability
    printf("\n");

    // Wait for the user to press enter before continuing
    getchar();
}
