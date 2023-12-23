/* used for debugging */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void print_all_args(int count, char **args) {
    printf("%d argument(s):\n", count);
    for (int i = 0; i < count; i++) {
        printf("`%s`\n", args[i]);
    }
}

int main(int argc, char **argv) {
    print_all_args(argc - 1, argv + 1);
}
