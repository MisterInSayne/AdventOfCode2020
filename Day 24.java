import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.HashMap;



class Main {
  private HashMap<Point, Boolean> turnedTiles = new HashMap<Point, Boolean>();

  private void makeMove(String path) {
    Point pos = new Point(0,0);
    for (String dir: path.split("(?<=[ew])")) {
      switch(dir){
        case "e": pos.x++; break;
        case "w": pos.x--; break;
        case "ne": pos.x++;
        case "nw": pos.y++; break;
        case "sw": pos.x--;
        case "se": pos.y--; break;
      }
    }
    if(turnedTiles.containsKey(pos)){
      turnedTiles.remove(pos);
    }else{
      turnedTiles.put(pos, true);
    }
  }
  
  private ArrayList<String> readInput(String file) {
    ArrayList<String> input = new ArrayList<String>();
    try {
      Scanner inputData = new Scanner(new File(file));
      while (inputData.hasNextLine()) {
        input.add(inputData.nextLine());
      }
      inputData.close();
    }catch (FileNotFoundException e) { e.printStackTrace(); }
    return input;
  }
  
  private void simulateDay(){
    HashMap<Point, Integer> tagList = new HashMap<Point, Integer>();
    int[] offX = {1,0,-1,1,0,-1};
    int[] offY = {1,1,0,0,-1,-1};
    for(Point pos: turnedTiles.keySet()){
      for(int i = 0; i<6; i++){
        Point key = new Point(pos.x+offX[i],pos.y+offY[i]);
        int c = 0;
        if(tagList.containsKey(key)){ c = tagList.get(key); }
        tagList.put(key, c + 1);
      }
      if(!tagList.containsKey(pos)){ tagList.put(pos, 0); }
    }
    for(Point pos: tagList.keySet()){
      int tags = tagList.get(pos);
      if(tags == 2){
        turnedTiles.put(pos,true);
      }else if((tags > 2 || tags == 0) && turnedTiles.containsKey(pos)){
        turnedTiles.remove(pos);
      }
    }
  }
  
  public void simulateDays(int Days, Boolean output){
    int Day = 0;
    while(Day < Days){
      simulateDay();
      Day++;
      if(output && (Day < 10 || Day%10 == 0)){
        System.out.println("Day "+Day+": "+turnedTiles.size());
      }
      if(output && Day == 10){
        System.out.println("...");
      }
    }
  }

  public static void main(String[] args) {
    (new Main()).run();
  }

  public void run(){
    ArrayList<String> input = readInput("input.txt");
    for(String path: input){ makeMove(path); }
    System.out.println("Answer part 1: "+turnedTiles.size());
    simulateDays(100, true);
    System.out.println("Answer part 2: "+turnedTiles.size());
  }

  public class Point {
    public int x;
    public int y;

    public Point(int x, int y) {
      this.x = x;
      this.y = y;
    }

    public double getX() { return this.x; }
    public double getY() { return this.y; }

    @Override
    public boolean equals(Object obj) {
      if(obj.getClass()== this.getClass()){
        return ((Point)obj).x == this.x && ((Point)obj).y == this.y;
      }
      return false;
    }
    @Override
    public int hashCode(){
      return this.x * 31 + this.y;
    }
    @Override
    public String toString() {
        return ("(" + this.x + "," + this.y + ")"); 
    }
  }
}