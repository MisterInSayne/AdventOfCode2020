<?php

$number = Array();
$nlen = 0;
$f = fopen( 'php://stdin', 'r' );

while( $line = fgets( $f ) ) {
  //echo $line;
  $number[$nlen] = intval($line);
  $nlen ++;
}

fclose( $f );

//print_r($number);

$found = 0;
for($i = 25; $i < $nlen; $i++){
    $foundi = false;
    for($x = $i-25; $x < $i; $x++){
        for($y = $x+1; $y < $i; $y++){
            if(($number[$x] + $number[$y]) == $number[$i]){
                $foundi = true;
                break;
            }
        }
        if($foundi)break;
    }
    if(!$foundi){
        $found = $i;
        break;
    }
}
if($found){
    echo "Line ".$found. ", answer part 1: ".$number[$found]."\n";
}else{
    die("failed to find part 1\n");
}
$start = 0;
$end = 0;
$outsum = 0;
$h = 0;
$l = 0;
for($i = 0; $i < $nlen; $i++){
    $sum = 0;
    $end = $i;
    $l = $i;
    $h = $i;
    while($sum < $number[$found] && $end < $nlen){
        $sum += $number[$end];
        if($number[$end] > $number[$h])$h = $end;
        if($number[$end] < $number[$l])$l = $end;
        $end++;
    }
    if($sum == $number[$found]){
        $start = $i;
        $outsum = $sum;
        $end--;
        break;
    }
}

if($start){
    echo "Startline: ".$start.", endline: ".$end." , Sum: ".$outsum."\n";
    echo "Answer part 2: ".($number[$l] + $number[$h])."\n";
}else{
    die("failed to find part 2\n");
}


?>