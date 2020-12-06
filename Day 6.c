#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

int main(void) {
  FILE* file = fopen("data.txt","r");
  if(!file){
    perror("not good");
    return EXIT_FAILURE;
  }
  int sum = 0;
  bool letters[26];
  int lastC;
  int c;
  int count = 0;
  memset(letters, false, 26);
  
  while((c = getc(file)) != EOF){
    if(c == 10 && lastC == 10){
      sum += count;
      count = 0;
      memset(letters, false, 26);
    }else if(c >= 97 && c <= 122){
      if(letters[c-97] == true){
        letters[c-97] = true;
        count++;
      }
    }
    lastC = c;
  }
  sum += count;
  printf("Sum: %d ", sum);
  fclose(file);
  return 0;
}

// ------------------------------ PART 2 ------------------------------
#include <stdio.h>
#include <stdlib.h>

int main(void) {
  FILE* file = fopen("data.txt","r");
  if(!file){
    perror("not good");
    return EXIT_FAILURE;
  }
  int sum = 0;
  int letters[26];
  int lastC;
  int c;
  int count = 0;

  while((c = getc(file)) != EOF){
    if(c == 10 && lastC == 10){
      for (int i = 0; i < 26; i++){
        if(letters[i]==count){
          sum++;
        }
        letters[i] = 0;
      }
      count = 0;
    }else if(c >= 97 && c <= 122){
      letters[c-97]++;
    }else if(c == 10){
      count++;
    }
    lastC = c;
  }
  count++;
  for (int i = 0; i < 26; i++)
    if(letters[i]== count)
      sum++;
  printf("Sum: %d ", sum);
  fclose(file);
  return 0;
}