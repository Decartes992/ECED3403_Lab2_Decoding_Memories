/*
Name: Iftekhar Rafi
ID: B00871031
Course: ECED 3403 Computer Architecture
Instructor: Larry Hughes

File Name: manager.c
File Purpose: This file contains the manager function which handles user input for memory display and calls the loadSRecord function to load S-Records from a file into memory.
*/

#include <stdio.h>
#include "loader.h"

// The manager function handles user input for memory display and loads S-Records from a file into memory
void manager(int argc, char* argv[]) {

    // If the number of command-line arguments is not correct, print a usage message and return
    if (argc != ARG_COUNT) {
        fprintf(stderr, "Error: XME file not detected.");
        getchar();
        return 0;
    }

    // Get the filename from the command-line arguments
    const char* filename = argv[1];

    // Declare variables for the start and end addresses, the memory choice, and the continue choice
    int start, end;
    char choice;
    char continueChoice;

    // Load the S-Record from the file
    loadSRecord(argv[1]);

    // Loop until the user chooses not to display another range
    do {
        // Prompt the user for the start address and read it as a hexadecimal number
        printf("Enter start address (in hex): ");
        scanf("%x", &start);

        // Prompt the user for the end address and read it as a hexadecimal number
        printf("Enter end address (in hex): ");
        scanf("%x", &end);

        // Prompt the user for the memory choice and read it as a character
        printf("Choose memory to display (I for IMEM, D for DMEM): ");
        scanf(" %c", &choice);

        // If the user chose IMEM, display the instruction memory and the decoded instructions
        if (choice == 'I' || choice == 'i') {
            printf("\nDisplaying Instruction Memory (IMEM):\n");
            displayMemory((unsigned char*)IMEM, start, end);

            printf("Displaying Decoded Instructions:\n");
            fetchInstructions();  // This should decode and display the instructions
        }

        // If the user chose DMEM, display the data memory
        else if (choice == 'D' || choice == 'd') {
            printf("Displaying Data Memory (DMEM):\n\n");
            displayMemory(DMEM, start, end);
        }
        // If the user made an invalid choice, print an error message
        else {
            printf("Invalid choice. Please choose 'I' for IMEM or 'D' for DMEM.\n");
        }

        // Prompt the user to display another range and read the choice as a character
        printf("Do you want to display another range? (Y for yes, N for no): ");
        scanf(" %c", &continueChoice);
        printf("\n");

    } while (continueChoice == 'Y' || continueChoice == 'y');  // Continue if the user chose yes
}
