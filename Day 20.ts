import { readFileSync } from 'fs';


function reverse(s:string):string{
  return s.split("").reverse().join("");
}

function rotateData(dataIn:string[], r:number):string[]{
  if(r%4==0)return dataIn;
  if(r%4==2){
    dataIn.reverse();
    for(let i in dataIn){
      dataIn[i]=reverse(dataIn[i]);
    }
    return dataIn;
  }
  var dataOut:string[] = [];
  for(let i=0; i<dataIn.length; i++){
    if(i==0){
      dataOut = dataIn[i].split("");
    }else{
      let split = dataIn[i].split("");
      if(r%4==3){
        for(let s=0;s<dataOut.length;s++){
          dataOut[s] = split[s]+dataOut[s];
        }
      }else{
        for(let s=0;s<dataOut.length;s++){
          dataOut[s] += split[s];
        }
      }
    }
  }
  if(r%4==1)dataOut.reverse();
  return dataOut;
}

function flipData(dataIn:string[], x:boolean):string[]{
  if(x){
    return dataIn.reverse();
  }else{
    for(let i in dataIn){
      dataIn[i]=reverse(dataIn[i]);
    }
    return dataIn;
  }
}

class imageTile {
  id: string;
  data: string[];
  actualData: string[];

  height: number;
  width: number;

  top: string;
  left: string;
  right: string;
  bottom: string;
  sides:string[];
  reverseSides:string[];
  
  done:boolean;
  connections:string[];

  printCycle:number;
  posCycle:number;
  pos:[number,number];
  relativePos:[number,number];

  constructor(id: string, data: string[]){
    this.id = id;
    this.data = data;
    this.printCycle=0;
    this.posCycle=0;
    this.done = false;
    this.connections=[];
    this.pos = [0,0];
    this.relativePos = [0,0];
    
    this.height = data.length;
    this.width = data[0].length;

    this.top = data[0];
    this.bottom = reverse(data[data.length-1]);
    this.left = "";
    this.right = "";

    this.actualData = [];

    for(var s of data){
      this.left = s.substring(0,1) + this.left;
      this.right += s.substring(this.width-1,this.width);
      this.actualData.push(s.substring(1,this.width-1));
    }
    this.actualData.pop();
    this.actualData.shift();
    this.sides=[this.top,this.right,this.bottom,this.left];
    this.reverseSides=[reverse(this.top),reverse(this.right),reverse(this.bottom),reverse(this.left)];
  }

  printOutline(){
    console.log("Tile "+this.id+":");

    console.log(this.top);
    let sp=" ".repeat(this.top.length-2);
    let l=this.left.length;
    for(let i=1; i<l-1; i++ ){
      console.log(this.left[i]+sp+this.right[l-(i+1)]);
    }
    console.log(reverse(this.bottom));
  }

  getOutline():string[]{
    var outlines:string[] = [];
    outlines.push(this.sides[0]);
    let sp=" ".repeat(this.sides[0].length-2);
    let l=this.sides[1].length;
    for(let i=1; i<l-1; i++ ){
      if(i==(l/2)-1){
        outlines.push(this.reverseSides[3][i]+
          " ".repeat(Math.floor((l-this.id.length-2)/2))+
          (this.id)+
          " ".repeat(Math.ceil((l-this.id.length-2)/2))+
          this.sides[1][i]);
      }else if(i==(l/2)){
        let x = this.relativePos[0]-lowestPos[0];
        let y = this.relativePos[1]-lowestPos[1];
        outlines.push(this.reverseSides[3][i]+
          " ".repeat(Math.floor((l-2)/2)-x.toString().length-1)+
          (x)+","+(y)+
          " ".repeat(Math.ceil((l-2)/2)-y.toString().length)+
          this.sides[1][i]);
      } else {
       outlines.push(this.reverseSides[3][i]+sp+this.sides[1][i])
      }
    }
    outlines.push(this.reverseSides[2]);
    return outlines;
  }

  findPos(){
    positionList = [];
    lowestPos = this.floodPosition(0,0,this.posCycle+1,false);
    lowestPos = this.floodPosition(0-lowestPos[0],0-lowestPos[1],this.posCycle+1,true);
  }
  
  floodPosition(x:number, y:number, cycle:number,setpos:boolean):[number, number]{
    this.posCycle = cycle;
    this.relativePos=[x,y];
    var lowest:[number, number] = [x,y];
    if(setpos){
      if(positionList[x] === void 0){
        positionList[x] =[];
      }
      positionList[x][y]=this.id;
      this.pos=[x,y];
    }
    for(let i=0; i<4; i++){
      if(i in this.connections){
        if(tileList[this.connections[i]].posCycle == cycle)continue;
        var other = tileList[this.connections[i]].floodPosition(x+((i-1)*((i+1)%2)),y+((2-i)*(i%2)), cycle, setpos);
        if(lowest[0] > other[0])lowest[0]=other[0];
        if(lowest[1] > other[1])lowest[1]=other[1];
      }
    }
    return lowest;
  }
  
  getPos():[number, number]{
    return [this.relativePos[0]-lowestPos[0],this.relativePos[1]-lowestPos[1]]
  }

  test(other: imageTile):boolean{
    let otherSides = other.getSides();
    var found = false;
    var reverse = false;
    var place:number = 0;
    var otherplace:number = 0;
    for(var o in otherSides){
      if(o in other.connections)continue;
      var otherSide = otherSides[o]
      for(var s in this.sides){
        if(this.connections[s] !== void 0)continue;
        if(otherSide==this.sides[s]){
          reverse=true;
          found=true;
        }
        if(otherSide==this.reverseSides[s]){
          found=true;
        }
        if(found){
          place = Number(s);
          otherplace = Number(o);
          break;
        }
      }
      if(found)break;
    }
    if(found){
      if(DEBUG)console.log("  "+this.id+"-"+other.id+": "+place+" - "+otherplace+" - "+reverse);
      if(Math.abs(place-otherplace)!=2){
        if(DEBUG)console.log("    "+other.id+" should rotate.");
        other.rotate(((((otherplace-place)+6)%4)));
      }
      if(reverse){ other.flip(place%2==1); }
      this.connections[place] = other.id;
      other.connections[(place+2)%4]=this.id;
    }
    return found;
  }

  rotate(r: number){
    for(let i=0; i<r; i++){
      this.sides.push(this.sides.shift() as string);
      this.reverseSides.push(this.reverseSides.shift() as string);
    }
    this.actualData = rotateData(this.actualData,r);
  }

  flip(x:boolean){
    if(x){
      let newSides = [this.reverseSides[2],this.reverseSides[1],this.reverseSides[0],this.reverseSides[3]];
      this.reverseSides = [this.sides[2],this.sides[1],this.sides[0],this.sides[3]];
      this.sides = newSides;
    }else{
      let newSides = [this.reverseSides[0],this.reverseSides[3],this.reverseSides[2],this.reverseSides[1]];
      this.reverseSides = [this.sides[0],this.sides[3],this.sides[2],this.sides[1]];
      this.sides = newSides;
    }
    this.actualData = flipData(this.actualData,x);
  }

  findConnections(maxdepth:number){
    if(this.done)return;
    if(DEBUG)console.log("looking for: "+this.id);
    for(let tile of Object.values(tileList)){
      if(tile.id==this.id)continue;
      if(this.test(tile)){
        if(DEBUG)printCurrent();
      }
    }
    this.done = true;

    if(maxdepth>0){
      for(let c of this.connections){
        if(c === void 0)continue;
        var other = tileList[c];
        if(!other.done)other.findConnections(maxdepth-1);
      }
    }
    
  }

  getSides(){ return this.sides; }
  getReverseSides(){ return this.reverseSides; }
}


function printCurrent(){
  tileList[puzzleIDs[fi]].findPos();
  for(var x in positionList){
    var outlines:string[] = [];
    var lasty = -1;
    for(var y in positionList[x]){
      let newLines = tileList[positionList[x][y]].getOutline();
      for(let i in newLines){
        if(outlines[i] === void 0)outlines[i]="";
        if(Number(y)-(lasty+1) > 0){
          outlines[i] +=" ".repeat(width*(Number(y)-(lasty+1)));
        }
        outlines[i] += newLines[i];
      }
      lasty = Number(y);
    }
    for(var line of outlines){
      console.log(line);
    }
  }
  console.log("");
  console.log("--------------------------------------------------------------------");
  console.log("");
}


function printActualData(){
  tileList[puzzleIDs[fi]].findPos();
  var dataList:string[]=[];
  for(var x in positionList){
    var outlines:string[] = [];
    var lasty = -1;
    for(var y in positionList[x]){
      let newLines = tileList[positionList[x][y]].actualData;
      for(let i in newLines){
        if(outlines[i] === void 0)outlines[i]="";
        if(Number(y)-(lasty+1) > 0){
          outlines[i] +=" ".repeat((width-2)*(Number(y)-(lasty+1)));
        }
        outlines[i] += newLines[i];
      }
      lasty = Number(y);
    }
    for(var line of outlines){
      dataList.push(line);
    }
  }
  rows = positionList.length;
  columns = positionList[0].length;

  let regexp: RegExp = new RegExp('\#(.{'+((columns*(width-2))-18)+'})\#(.{4})\#\#(.{4})\#\#(.{4})\#\#\#(.{'+((columns*(width-2))-18)+'})\#(..)\#(..)\#(..)\#(..)\#(..)\#','gs');

  //dataList = flipData(dataList,true);
  console.log("");
  console.log("");
  let answer:number=0;
  var found = false;
  for(let r=0;r<4;r++){
    if(r!=0){dataList = rotateData(dataList,1);}
    for(let f=0;f<4;f++){
      if(f!=0){dataList = flipData(dataList,f%2==1);}
      let textdata:string = dataList.join('\n');
      if(regexp.test(textdata)){
        //textdata = textdata.replace(regexp,"O$1O$2OO$3OO$4OOO$5O$6O$7O$8O$9O$10O");
        while(regexp.test(textdata)){
          textdata = textdata.replace(regexp,"O$1O$2OO$3OO$4OOO$5O$6O$7O$8O$9O$10O");
        }
        textdata = textdata.replace(/(O+)/g,"\x1b[32m$1\x1b[34m");
        //textdata = textdata.replace(regexp,"\x1b[32mO\x1b[34m$1\x1b[32mO\x1b[34m$2\x1b[32mOO\x1b[34m$3\x1b[32mOO\x1b[34m$4\x1b[32mOOO\x1b[34m$5\x1b[32mO\x1b[34m$6\x1b[32mO\x1b[34m$7\x1b[32mO\x1b[34m$8\x1b[32mO\x1b[34m$9\x1b[32mO\x1b[34m$10\x1b[32mO\x1b[34m");
        console.log("\x1b[34m"+textdata+"\x1b[0m");
        answer = (textdata.match(/#/g) || []).length;
        found = true;
        break;
      }
    }
    if(found)break;
  }
  if(!found){
    console.log("Maybe we should flip it?");
  }

  var sum:number = Number(positionList[0][0])*Number(positionList[0][columns-1])*Number(positionList[rows-1][0])*Number(positionList[rows-1][columns-1]);
  console.log("");
  console.log("");
  console.log("Answer part 1: "+sum);
  console.log("Answer part 2: "+answer);
}

function testData(){
  tileList[puzzleIDs[fi]].findConnections(100);
  printActualData();
}

let input = readFileSync('./input.txt').toString('utf-8');

let DEBUG:boolean = false;
let fi:number = 0;

var lowestPos:[number,number] = [0,0];
var positionList:string[][] = [];
var tileList:{[key:string]:imageTile;} = {};
var puzzleIDs:string[] = [];
var initialized = false;
var rows:number = 0;
var columns:number = 0;
var height:number = 0;
var width:number = 0;
function readData(){
  let lines = input.split("\n")
  var data:string[] = [];
  var start = true;
  var currentID:string = "0";
  for(var l in lines ){
    if(lines[l]==""){
      tileList[currentID] = new imageTile(currentID, data);
      puzzleIDs.push(currentID)
      start=true;
      height = data.length;
      width = data[0].length;
      data = [];
      continue;
    }else if(start){
      currentID = lines[l].substring(5,lines[l].length-1);
      start=false;
      continue;
    }
    data.push(lines[l]);
  }
}

readData();
testData();