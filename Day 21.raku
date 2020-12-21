
my @input = "input.txt".IO.slurp.lines;

my %Allergens = Map.new();

my %Ingredients = Map.new();
my @done = [];
my %doneList = Map.new();
for @input -> $line {
  my ($ingredients, $contains) = $line.split(' (contains ');
  my @ingrList = $ingredients.split(' ');
  for @ingrList -> $ingrd {
    if $ingrd ∈ %Ingredients {
      %Ingredients{$ingrd}++
    }else{
      %Ingredients{$ingrd}=1;
    }
  }
  my @allerList = $contains.chop.split(', ');
  for @allerList -> $allergen {
    if $allergen ∈ %Allergens {
      my @newlist = [];
      for %Allergens{$allergen}[] -> $ingrd {
        if $ingrd ~~ any @ingrList and not $ingrd ~~ any @done {
          @newlist.push($ingrd);
          
        }
      }
      if @newlist.elems == 1 {
        @done.push(@newlist[0]);
        %doneList{$allergen} = @newlist[0];
        @newlist=[];
      }
      %Allergens{$allergen} = @newlist;
    }else{
      %Allergens{$allergen} = @ingrList;
    }
  }
}

my $i = 0;
until @done.elems >= %Allergens.elems or $i > 100 {
  for %Allergens -> $apair {
    my @newlist = [];
    #$apair.value
    for $apair.value[] -> $ingrd {
      if not $ingrd ~~ any @done {
        @newlist.push($ingrd);
      }
    }
    if @newlist.elems == 1 {
      @done.push(@newlist[0]);
      %doneList{$apair.key} = @newlist[0];
      @newlist=[];
    }
    $apair.value = @newlist;
  }
  $i++;
}


my $sum = 0;

for  %Ingredients -> $ipair {
  if not $ipair.key ~~ any @done {
    $sum += $ipair.value;
  }
}

my $answer = "";
for %doneList.keys.sort[] -> $key {
  $answer ~= %doneList{$key}~",";
}

say "Answer part 1: "~$sum;
say "Answer part 2: "~$answer.chop;