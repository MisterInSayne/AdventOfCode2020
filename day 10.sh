varlist=()
tribonacci=(1 1 2 4 7 13 24 44 81 149 274 504 927 1705 3136 5768 10609 19513 35890 66012)
i=0

while read line
do
  varlist[i]=${line%?}
  i=$((i+1))
done < "${1:-/dev/stdin}"

IFS=$'\n' varlist=($(sort -n <<<"${varlist[*]}"))


varlist[$(($i-1))]=$((${varlist[$(($i-2))]}+3))

last=0
count=0
ones=0
threes=0
consecOnes=0
possibilities=1
while [ "x${varlist[count]}" != "x" ]
do
    
    step=$((${varlist[count]}-$last))
    last=${varlist[count]}
    if [ $step = 1 ]
    then
        ones=$(($ones+1))
        consecOnes=$(($consecOnes+1))
        echo "${varlist[count]} : step $step, consecOnes: $consecOnes"
    else
        options=1
        if [ $step = 3 ]
        then
            threes=$(($threes+1))
            if [ $consecOnes -gt 0 ]
            then
                options=${tribonacci[consecOnes]}
            fi
        else
            if [ $consecOnes -gt 0 ]
            then
                options=$((${tribonacci[consecOnes]}+${tribonacci[$(($consecOnes-1))]}))
            fi
        fi
        echo "${varlist[count]} : step $step, options: $options"
        possibilities=$(($possibilities*$options))
        consecOnes=0
    fi
    
    count=$(( $count + 1 ))
done

answer1=$(($ones*$threes))
echo "Answer 1: $ones * $threes = $answer1"

possibilities=$(($possibilities*${tribonacci[consecOnes]}))
echo "Answer 2: $possibilities"
