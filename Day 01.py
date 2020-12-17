Array = ['''insert data here#''']
l = Array.length
i = 0
found = False

valA = 0
valB = 0
while i < l and found == False:
    valA = Array[i]
    j = i+1
    while j < l and found == False:
        valB = Array[j]
        if valA + valB == 2020:
            found = True
        j+=1
    i+=1
answer = valA * valB
print("A: "+ valA + ", B: "+ valB + ", Solution: "+answer)


----------------------------------------------------------------------------------------------


l = len(Array)
i = 0
found = False

valA = 0
valB = 0
valC = 0
while i < l and found == False:
    valA = Array[i]
    j = i+1
    while j < l and found == False:
        valB = Array[j]
        if valA + valB < 2020:
            k = j+1
            while k < l and found == False:
                valC = Array[k]
                if valA + valB + valC == 2020:
                    found = True
                k+=1
        j+=1
    i+=1
answer = valA * valB * valC
print("A: ", valA , ", B: ", valB , ", C: ", valC, ", Solution: " , answer)
