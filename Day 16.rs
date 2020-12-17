use std::io::{self, BufRead};

struct DataRange { min1:i16, max1:i16, min2:i16, max2:i16 }

fn toi16(s:&str) -> i16{
    return s.to_string().parse::<i16>().unwrap();
}

fn getDataRange(line:&str) -> DataRange {
    let pieces:Vec<&str> = line.split(": ").last().unwrap_or("").split(" or ").collect();
    let part1:Vec<&str> = pieces[0].split("-").collect();
    let part2:Vec<&str> = pieces[1].split("-").collect();
    return DataRange {min1:toi16(part1[0]),max1:toi16(part1[1]),min2:toi16(part2[0]),max2:toi16(part2[1])};
}

fn testValidity(line:&str, ranges:&Vec<DataRange>, checkRanges:&mut Vec<Vec<usize>>) -> i16 {
    let mut out:i16 = 0;
    let mut valid = true;
    for (i, s) in line.split(",").enumerate() {
        let n = toi16(s);
        let mut found = false;
        for r in ranges {
            if (r.min1 <= n && r.max1 >= n) || (r.min2 <= n && r.max2 >= n) { found=true; break; }
        }
        if !found { out += n; valid = false; }
    }
    if valid {
        for (i, s) in line.split(",").enumerate() {
            let n = toi16(s);
            for (p, r) in ranges.iter().enumerate() {
                if !((r.min1 <= n && r.max1 >= n) || (r.min2 <= n && r.max2 >= n)) {
                    checkRanges[i].retain(|&c| c!=p);
                }
            }
        }
    }
    return out;
}

fn overlapChecks(ticket:&Vec<i16>, checkRanges:&mut Vec<Vec<usize>>, requested:Vec<usize>) -> i64 {
    let mut sortedRanges:Vec<Vec<usize>> = Vec::new();
    let mut rangeid:Vec<usize> = (0..checkRanges.len()).collect();
    let mut actualPos:Vec<usize> = Vec::new();
    sortedRanges.clone_from(checkRanges);
    sortedRanges.sort_by_key(|a| a.len());
    sortedRanges.reverse();
    
    for (i, r) in sortedRanges.iter().enumerate() {
        for p in r { rangeid[p.to_owned()]=(sortedRanges.len()-1)-i; }
        //println!("Test Range {}: {:?}", i, r);
    }
    //println!("Range ID's: {:?}", rangeid);
    
    let mut out:i64 = 1;
    for (i, r) in checkRanges.iter().enumerate() {
        let p = rangeid.iter().position(|&e| e == r.len()-1).unwrap();
        if requested.contains(&p) { out *= ticket[i] as i64; }
        //println!("Test Range {}: {} {:?}", i, p, r);
        actualPos.push(p);
    }
    
    println!("actual pos: {:?}", actualPos);
    return out;
}

fn getYourTicket(line:&str) -> Vec<i16> {
    let mut ticket:Vec<i16> = Vec::new();
    for s in line.split(",") { ticket.push(toi16(s)); }
    return ticket;
}

fn main() {
    let mut ranges:Vec<DataRange> = Vec::new();
    let mut badNum:i16 = 0;
    let mut checkRanges:Vec<Vec<usize>> = Vec::new();
    let mut stage:i8 = 0;
    let mut requestedResults:Vec<usize> = Vec::new();
    let mut ticket:Vec<i16> = Vec::new();
    
    let stdin = io::stdin();
    for lin in stdin.lock().lines() {
        let line = lin.unwrap();
        if line == "" {stage+=1;}else{
            match stage {
                0=>{
                    if &line[..9] == "departure"{ requestedResults.push(ranges.len()); }
                    ranges.push(getDataRange(&line));
                },
                1=>{
                    for _i in 0..ranges.len() { checkRanges.push((0..l).collect()); }
                    stage+=1;
                },
                2=>{
                    ticket=getYourTicket(&line);
                    badNum+=testValidity(&line, &ranges, &mut checkRanges);
                },
                3=>stage+=1,
                4=>badNum+=testValidity(&line, &ranges, &mut checkRanges),
                _=>println!("The end."),
            }
        }
    }
    
    println!("Answer Part 1: {}", badNum);
    println!("Answer Part 2: {}", overlapChecks(&ticket, &mut checkRanges, requestedResults));
}
