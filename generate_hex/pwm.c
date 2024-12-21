#include <stdio.h>
#include <stdint.h>

// Define the memory location as a constant
#define MEM_LOC 0x02001000

// Define the pointer to the memory location
#define PTR_TO_MEM_LOC ((volatile unsigned int *)MEM_LOC)

int main() {
    while(1) {
        *PTR_TO_MEM_LOC = 1;
        for (uint32_t i = 0; i < 5; i++) {
            *PTR_TO_MEM_LOC = *PTR_TO_MEM_LOC * i;
        }
    }
    return 0;
}
