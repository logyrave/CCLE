#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE 100000

// If you don't understand what's below do not use 
// It will not fix the databse it will anhilate it 

int main(int argc, char* argv[]) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    FILE* in_file = fopen(argv[1], "r");
    if (!in_file) {
        perror("Failed to open input file");
        return 1;
    }

    FILE* out_file = fopen(argv[2], "w");
    if (!out_file) {
        perror("Failed to open output file");
        fclose(in_file);
        return 1;
    }

    char buffer[MAX_LINE];
    size_t n_read;

    while ((n_read = fread(buffer, 1, sizeof(buffer) - 1, in_file)) > 0) {
        buffer[n_read] = '\0';
        char* ptr = buffer;

        while ((ptr = strstr(ptr, "PR-")) != NULL) {
            // pattern matching
            if (ptr != buffer && *(ptr - 1) != '\n') {
                fputc('\n', out_file);
            }
            // pattern writting
            fwrite(ptr, 1, n_read - (ptr - buffer), out_file);
            break;  // in and out
        }

        // to change in order to deal with the unmatch case
        if (!ptr) {
            fwrite(buffer, 1, n_read, out_file);
        }
    }

    fclose(in_file);
    fclose(out_file);
    return 0;
}