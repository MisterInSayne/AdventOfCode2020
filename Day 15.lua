data = {0,3,6};

lastOccurance = {};

for i, v in ipairs(data) do
    lastOccurance[v] = i-1;
end

l=#data;
nextNumber = 0;
last=30000000-2;
firstpartNumber = 0;
for i = l, last do
    currNumber = nextNumber;
    if lastOccurance[nextNumber] ~= nil then
        nextNumber = i-lastOccurance[nextNumber];
    else
        nextNumber = 0;
    end
    lastOccurance[currNumber] = i;
	if i == 2018 then
		firstpartNumber = nextNumber;
	end
end
print("Part 1: "..firstpartNumber);
print("Part 2: "..nextNumber);

