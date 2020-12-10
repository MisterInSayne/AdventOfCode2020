class Day7 {
    
    static public function main():Void {
        var Bags:Map<String,Bag> = new Map<String,Bag>();
        var line:String;
        var r = ~/^(.+?) bags contain ([^\.\n]+?)\.$/g;
        var rc = ~/(\d+?) ([^,\.\n]+?) bags?/g;
        try {
            while (true) {
                line = Sys.stdin().readLine();
                if(r.match(line)){
                    if(r.matched(2) == "no other bags"){
                        // Dead end.
                    }else{
                        var name = r.matched(1);
                        var content = r.matched(2);
                        if(!Bags.exists(name))Bags[name] = new Bag();
                        while(rc.match(content)){
                            if(!Bags.exists(rc.matched(2)))Bags[rc.matched(2)] = new Bag();
                            Bags[rc.matched(2)].inBags.push(Bags[name]);
                            Bags[name].hasBags.push(Bags[rc.matched(2)]);
                            Bags[name].Amount.push(Std.parseInt(rc.matched(1)));
                            
                            content = rc.matchedRight();
                        }
                        
                    }
                }
            }
        }
        catch (e:haxe.io.Eof) {
            trace("done!");
        }
        if(Bags.exists("shiny gold")){
            trace("Answer Part 1: " + (Bags["shiny gold"].getCountPt1()-1));
            trace("Answer Part 2: " + (Bags["shiny gold"].getCountPt2()-1));
        }
    }
}

class Bag {
    public var inBags:Array<Bag> = [];
    public var hasBags:Array<Bag> = [];
    public var Amount:Array<Int> = [];
    private var counted = false;
    
    public function getCountPt1(){
        if(this.counted) return 0;
        this.counted = true;
        var out = 1;
        for(bag in this.inBags){
            out += bag.getCountPt1();
        }
        return out;
    }
    
    public function getCountPt2(){
        if(this.hasBags.length == 0) return 1;
        var out = 1;
        var l = this.hasBags.length;
        for(i in 0...l){
            out += this.hasBags[i].getCountPt2()*this.Amount[i];
        }
        return out;
    }
    
    public function new(){
        
    }
    
}
