#include <stdio.h>

// Define the memory location as a constant
#define MEM_LOC 0x02001000

// Define the pointer to the memory location
#define PTR_TO_MEM_LOC ((volatile unsigned int *)MEM_LOC)

int main() {
    while(1) {
    // Use the defined pointer to assign the value 1 to the memory location
    *PTR_TO_MEM_LOC = 1;
    }
    return 0;
}