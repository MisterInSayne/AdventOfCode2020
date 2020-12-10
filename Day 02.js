var textDump = `insert data here`;



var regex = /^(\d+)\-(\d+) (\w)\: (.*)$/gm;

var result = [...textDump.matchAll(regex)];
var count = 0;

for(var res of result){
    var min = res[1];
    var max = res[2];
    var letter = res[3];
    var pass = res[4];
    
    var c = 0;
    for (var l of pass){
        if(l == letter)c++;
    }
    if(c >= min && c <= max) count++;
    
}
console.log(count);


//-------------------------[Part 2]-----------------------------



var regex = /^(\d+)\-(\d+) (\w)\: (.*)$/gm;

var result = [...textDump.matchAll(regex)];
var count = 0;

for(var res of result){
    var min = res[1];
    var max = res[2];
    var letter = res[3];
    var pass = res[4];
    
    if((pass.charAt(min-1) == letter?1:0) + (pass.charAt(max-1) == letter?1:0) == 1) count++;
    
}
console.log(count);
