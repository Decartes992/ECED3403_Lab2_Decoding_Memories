/*
Name: Iftekhar Rafi
ID: B00871031
Course: ECED 3403 Computer Architecture
Instructor: Larry Hughes

File Name: srecord.c
File Purpose: This file contains the function to load S-Records from a file and store them in memory.
*/
#include <stdio.h>
#include "loader.h"

void loadSRecord(const char* filename) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        perror("Error opening file");
        return;
    }

    char line[LINE_SIZE];
    while (fgets(line, sizeof(line), file)) {
        if (line[0] != 'S') continue; // Not an S-Record

        int count, address, loopCount;
        sscanf(line + BYTE_SIZE, "%2x%4x", &count, &address);
        loopCount = (count - 3) * BYTE_SIZE;
        if (line[ADDRESS_SHIFT] == '0') {
            // S0 record: header
            printf("Header (ASCII): ");
            for (int i = 0; i < loopCount; i += BYTE_SIZE) {
                unsigned int byte;
                sscanf(line + HEADER_START + i, "%2x", &byte);
                printf("%c", byte);
            }
            printf("\n");
            printf("Header (Bytes): ");
            for (int i = 0; i < loopCount + BYTE_SIZE; i += BYTE_SIZE) {
                unsigned int byte;
                sscanf(line + HEADER_START + i, "%2x", &byte);
                printf("%02X ", byte);
            }
            printf("\n");
        }
        else if (line[ADDRESS_SHIFT] == '1') {
            // S1 record: IMEM data
            for (int i = 0; i < loopCount; i += ASCII_SIZE) {
                unsigned int data;
                sscanf(line + HEADER_START + i, "%4x", &data);
                IMEM[(address >> IMEM_SHIFT) + (i >> BYTE_SIZE)] = (data >> DATA_SHIFT) | ((data & BYTE_MASK) << DATA_SHIFT); // Correctly handle high and low byte
            }
        }
        else if (line[ADDRESS_SHIFT] == '2') {
            // S2 record: DMEM data
            for (int i = 0; i < count - 3; i++) {
                unsigned int data;
                sscanf(line + HEADER_START + i * BYTE_SIZE, "%2x", &data);
                DMEM[address++] = data;
            }
        }
        else if (line[ADDRESS_SHIFT] == '9') {
            // S9 record: starting address
            printf("Starting address: %04X\n\n", address);
        }
    }
    fclose(file);
}
