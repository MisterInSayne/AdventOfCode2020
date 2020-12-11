import Swift


class Seat {
    var occupied = false
    var testOccupied = false
    var neighbours = [Seat]()
    var nearest = [Seat]()
    var isFloor = false
    var Cycle = 0
    
    func step(part: Int, cycle: Int) -> Bool{
        if(isFloor){return false}
        if(cycle != Cycle){
            testOccupied = occupied
            Cycle = cycle
        }
        var adj = 0
        if(part==1){
            for neighbour in neighbours {
                if(neighbour.check(cycle:cycle)){adj+=1}
            }
        }else{
            for neighbour in nearest {
                if(neighbour.check(cycle:cycle)){adj+=1}
            }
        }
        if(testOccupied){
            if((adj >= 4 && part == 1) || (adj >= 5 && part == 2)){
                occupied = false
            }
        }else{
            if(adj == 0){
                occupied = true
            }
        }
        return !(testOccupied == occupied) // no change
    }
    
    func check(cycle: Int) -> Bool{
        if(isFloor){return false}
        if(cycle != Cycle){
            testOccupied = occupied
            Cycle = cycle
        }
        return testOccupied
    }
    
    func link(other: Seat){
        neighbours.append(other)
        other.neighbours.append(self)
    }
    
    func linkNearest(other: Seat){
        nearest.append(other)
        other.nearest.append(self)
    }
    
    func getChar() -> String{
        if(isFloor){return "."}
        if(occupied){return "#"}
        return "L"
    }
    
    init(){}
    init(floor: Bool){
        isFloor = floor
    }
    init(c: Character){
        if(c == "#"){
            occupied = true
            testOccupied = true
        }else if(c == "."){
            isFloor = true
        }
    }
}


class SeatManager{
    var Seats = [Seat]()
    var width = 0
    var height = 0
    var Cycle = 0
    var Silent = false;
    var chairs = 0
    var Part=1
    
    func addSeat(c: Character, x: Int, y: Int){
        if(c == "."){
            Seats.append(Seat(floor:true))
        }else{
            chairs+=1
            let seat = Seat(c:c)
            Seats.append(seat)
            linkDirection(x:x,y:y,dX:-1,dY:-1,seat:seat)
            linkDirection(x:x,y:y,dX:-1,dY:0,seat:seat)
            linkDirection(x:x,y:y,dX:-1,dY:+1,seat:seat)
            linkDirection(x:x,y:y,dX:0,dY:-1,seat:seat)
        }
    }
    
    func linkDirection(x:Int,y:Int,dX:Int,dY:Int,seat:Seat){
        var d=1
        while true{
            let pox = x+(dX*d)
            let poy = y+(dY*d)
            if(seatExists(x:pox,y:poy)){
                let testSeat = getSeat(x:pox,y:poy)
                if(!testSeat.isFloor){
                    seat.linkNearest(other:testSeat)
                    if(d==1){seat.link(other:testSeat)}
                    break;
                }
            }else{ break; }
            d+=1
        }
    }
    
    func getSeat(x: Int, y: Int) -> Seat {
        return Seats[(x*width)+y]
    }
    
    func seatExists(x: Int, y: Int) -> Bool{
        if(x < 0 || x > height || y < 0 || y >= width){return false}
        if(!Seats.indices.contains((x*width)+y)){return false}
        return true
    }
    
    func step() -> Bool{
        if(!Silent){print("----------------------[ Cycle",String(Cycle),"]----------------------")}
        var changed = false
        var occupied = 0
        for x in 0...(height-1){
            var line = ""
            for y in 0...(width-1){
                let seat=getSeat(x:x,y:y)
                if(seat.step(part: Part, cycle: Cycle)){changed = true}
                let c = seat.getChar()
                if(!Silent){line += c}
                if(c == "#"){occupied+=1}
            }
            if(!Silent){print(line)}
        }
        
        print("Cycle",String(Cycle),"]: Total seats occupied:", String(occupied))
        if(!changed){
            print("No more change on cycle",String(Cycle))
        }
        Cycle+=1
        return !changed
    }
    
    
    
    func stepUntilDone(){stepUntilDone(max:100)}
    func stepUntilDone(max: Int){
        var done = false
        var i = 0
        while i < max && !done {
            done = step()
            i+=1
        }
    }
    
    
    func outputSeats(){
        for x in 0...(height-1){
            var line = ""
            for y in 0...(width-1){
                line += getSeat(x:x,y:y).getChar()
            }
            print(line)
        }
    }
}

var Seats = SeatManager();


var x = 0
var y = 0
var pos = 0
while let line = readLine() {
    if(Seats.width==0){ Seats.width = line.characters.count }
    y = 0
    for c in line.characters {
        Seats.addSeat(c:c, x:x, y:y)
        y+=1
    }
    x+=1
    Seats.height+=1
}


//print(String(Seats.width),"x",String(Seats.height),"=",String(Seats.width*Seats.height))
//print("Total seats:",String(Seats.chairs))
//print("Total positions:",String(Seats.Seats.count))
//Seats.outputSeats()

Seats.Part = 2
//Seats.stepUntilDone(max:10)
Seats.Silent = true
Seats.stepUntilDone()
