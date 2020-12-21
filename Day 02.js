var textDump = `insert data here`;
var answerA = 0; var answerB = 0;
for(var res of [...textDump.matchAll(/^(\d+)\-(\d+) (\w)\: (.*)$/gm)]){
    var c = 0;
    for (var l of res[4]){ if(l == res[3])c++;}
    if(c >= res[1] && c <= res[2]) answerA++;
    if((res[4].charAt(res[1]-1) == res[3]?1:0) + (res[4].charAt(res[2]-1) == res[3]?1:0) == 1) answerB++;
}
console.log("Part 1: "+answerA);
console.log("Part 2: "+answerB);
