using System;

class MainClass {

  public static long getLoopCycle(long key){
    long loop = 0;
    long value = 1;
    int subjectNr = 7;
    while(value != key && loop < 100000000){
      value *= subjectNr;
      value = value%20201227;
      loop++;
    }
    Console.WriteLine(value);
    Console.WriteLine(loop);
    return loop;
  }
  public static long getEncryption(long subjectNr, long loop){
    long value = 1;
    for(long i = 0; i<loop; i++){
      value *= subjectNr;
      value = value%20201227;
    }
    Console.WriteLine(value);
    return value;
  }

  public static void decryptKey(long keyA, long keyB){

    long LoopA = getLoopCycle(keyA);
    long LoopB = getLoopCycle(keyB);
    
    long encryptionA = getEncryption(keyB, LoopA);
    long encryptionB = getEncryption(keyA, LoopB);
  }

  public static void Main (string[] args) {
    string[] Keys = System.IO.File.ReadAllText(@"input.txt").Split('\n');
    Console.WriteLine("Hello World");
    
    decryptKey(long.Parse(Keys[0]), long.Parse(Keys[1]));
  }
}