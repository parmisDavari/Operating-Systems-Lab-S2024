#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "stat.h"

#define MAX_INPUTS 7
#define FILENAME "sdvar_result.txt"

double sqrt_approx(double x) {
    if (x == 0) return 0;

    double result = x;
    double epsilon = 0.000001;

    while ((result * result - x) > epsilon) {
        result = 0.5 * (result + x / result);
    }

    return result;
}

double cal_mean(int numbers[], int len) {
    double sum = 0;
    for (int i = 0; i < len; ++i) {
        sum += numbers[i];
    }
    return sum / len;
}

double cal_standard_deviation(int numbers[], int len, double mean) {
    double sum = 0;
    for (int i = 0; i < len; ++i) {
        sum += ((numbers[i] - mean) * (numbers[i] - mean));
    }
    return sqrt_approx(sum / len);
}

double cal_variance(int numbers[], int len, double mean) {
    double sum = 0;
    for (int i = 0; i < len; ++i) {
        sum += ((numbers[i] - mean) * (numbers[i] - mean));
    }
    return sum / len;
}

int main(int argc, char *argv[]) {
    int inputNumbers[MAX_INPUTS];
    int upperMeanNumbers[MAX_INPUTS], j = 0;
    int lowerMeanNumbers[MAX_INPUTS], k = 0;
    int len = argc - 1;

    if (argc > 8) {
        printf(2, "Error: number of args...\n");
        exit();
    }

    for (int i = 0; i < len; ++i) {
        inputNumbers[i] = atoi(argv[i + 1]);
    }

    double meanAll = cal_mean(inputNumbers, len);

    for(int i = 0; i < len; ++i) {
        if (inputNumbers[i] <= meanAll) {
            lowerMeanNumbers[j++] = inputNumbers[i];
        }
        else {
            upperMeanNumbers[k++] = inputNumbers[i];
        }
    }

    double standardDeviation = cal_standard_deviation(lowerMeanNumbers, j, cal_mean(lowerMeanNumbers, j));
    double variance = cal_variance(upperMeanNumbers, k, cal_mean(upperMeanNumbers, k));

    unlink(FILENAME);

    int fd = open(FILENAME, O_CREATE | O_WRONLY);
    if(fd < 0) {
        printf(2, "Error opening file...\n");
        exit();
    }
    
    printf(fd, "%d %d %d\n", (int)meanAll, (int)standardDeviation, (int)variance);
    
    close(fd);

    exit();
}
