#include <fstream>
#include <string>
#include <string.h>
#include <iostream>

using namespace std;

void getInput(int cups[9], string file){
  string input;
  if(file == "dump"){
    input="389125467";
  }else if(file == "stdin"){
    cin >> input;
  }else{
    ifstream inputfile;
    inputfile.open (file);
    getline (inputfile,input);
    inputfile.close();
  }
  //cout << input << '\n';
  for (int i = 0; i < 9; i++) { cups[i] = input[i]-48; }
}


void runGame(int *startingcups, int rounds, int size, int part){
  int *cups = new int[size];
  int i;
  cups[0]=0;
  for(i = 0; i < min(size,8); i++){
    int n = i+1;
    cups[startingcups[i]] = startingcups[n];
  }
  for(i = 10; i < size; i++){
    cups[i] = i+1;
  }
  if(size == 9){
    cups[startingcups[8]] = startingcups[0];
  }else{
    cups[startingcups[8]] = 10;
    cups[size] = startingcups[0];
  }

  int current = startingcups[0];
  for(int round = 0; round < rounds; round++){
    int next = current;
    if(--next==0)next=size;
    while(cups[current]==next||cups[cups[current]]==next||cups[cups[cups[current]]]==next){
      if(--next==0)next=size;
    }
    int swap = cups[cups[cups[cups[current]]]];
    cups[cups[cups[cups[current]]]] = cups[next];
    cups[next] = cups[current];
    cups[current] = swap;
    current = cups[current];
  }

  cout << "Answer Part "<<part<<": ";
  int start = ((int*) memchr(cups, 1, size*sizeof(int)))-cups;
  if(part == 1){
    int nextcup = 1;
    while((nextcup = cups[nextcup]) != 1){ cout << nextcup; }
  } else {
    cout << cups[1] << '*' << cups[cups[1]] << '=' << ((int64_t)cups[1])*((int64_t)cups[cups[1]]);
  }
  cout << '\n';
  
}

int main() {
  int startingcups[9];

  //getInput(startingcups, "input.txt");
  //getInput(startingcups, "stdin");
  getInput(startingcups, "dump");

  //runGame(startingcups, 10, 9, 1);
  runGame(startingcups, 100, 9, 1);
  runGame(startingcups, 10000000, 1000000, 2);
  
  return 0;
}