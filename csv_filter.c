#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_BUFFER 1000000
#define MAX_IDS 100000

int is_in_list(const char* value, char** list, int list_size) {
    for (int i = 0; i < list_size; ++i) {
        if (strcmp(value, list[i]) == 0) {
            return 1;
        }
    }
    return 0;
}

int main(int argc, char* argv[]) {
    if (argc < 4) {
        fprintf(stderr, "Usage: %s <csv_file> <id_list_file> <output_file>\n", argv[0]);
        return 1;
    }

    FILE* id_file = fopen(argv[2], "r");
    if (!id_file) {
        perror("Failed to open id list file");
        return 1;
    }


    char** id_list = malloc(MAX_IDS * sizeof(char*));
    int id_count = 0;
    char line[MAX_BUFFER];

    while (fgets(line, sizeof(line), id_file)) {
        line[strcspn(line, "\n")] = 0;
        if (strlen(line) > 0) {
            id_list[id_count++] = strdup(line);
        }
    }
    fclose(id_file);



    FILE* csv_file = fopen(argv[1], "r");
    if (!csv_file) {
        perror("Failed to open CSV file");
        return 1;
    }

    FILE* out_file = fopen(argv[3], "w");
    if (!out_file) {
        perror("Failed to open output file");
        return 1;
    }

    // bypass the missing \n for fgets
    size_t n_read = fread(line, 1, sizeof(line) - 1, csv_file);
    line[n_read] = '\0';

    
    // pseudo line for PR- pattern recognition
    char* cursor = line;

    // header
    char* first_pr = strstr(cursor, "PR-");
    if (first_pr) {
        fwrite(cursor, 1, first_pr - cursor, out_file);
        fputc('\n', out_file);
        cursor = first_pr;
    }

    while ((cursor = strstr(cursor, "PR-")) != NULL) {
        // fetch next occurency 
        char* next_pr = strstr(cursor + 3, "PR-");

        // ID extraction after comma
        char* id_start = cursor - 1;
        while (id_start > line && *id_start != ',') {
            id_start--;
        }
        if (*id_start == ',') id_start++;

        // check extracted id with id_list
        char id[100];
        sscanf(id_start, "%99[^,]", id);

        if (is_in_list(id, id_list, id_count)) {
            size_t len = next_pr ? (next_pr - cursor) : strlen(cursor);
            fwrite(cursor, 1, len, out_file);
            fputc('\n', out_file);
        }

        if (!next_pr) break;  // end
        cursor = next_pr;
    }
    for (int i = 0; i < id_count; ++i) {
        free(id_list[i]);
    }
    free(id_list);
    fclose(csv_file);
    fclose(out_file);
    return 0;
}