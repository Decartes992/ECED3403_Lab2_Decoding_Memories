/*
Name: Iftekhar Rafi
ID: B00871031
Course: ECED 3403 Computer Architecture
Instructor: Larry Hughes

File Name: loader.c
File Purpose: This file contains the main function which calls the manager function with command line arguments.
*/

#include <stdio.h>
#include "loader.h"

int main(int argc, char* argv[]) {
    manager(argc, argv);
    return 0;
}
