content = File.new("input.txt", "r").sysread(256)

part=2

active = Hash.new(false);
chars = content.split('')
x = y = 0
chars.each { |c|
  if c == "\n"
    x=0; y +=1
  else 
    if c == "#"; active[[x,y,0,0]]=true; end
    x +=1
  end
}
#puts active
cycles = 6
cycle = 0
while cycle < cycles do
  checked = Hash.new(0);
  active.each_key { |pos|
    x, y, z, w = pos
    #puts "#{x} #{y} #{z} #{w}"
    (-1..1).each{ |xs|
      (-1..1).each{ |ys|
        (-1..1).each{ |zs|
          if part == 1
            if xs == ys && ys == zs && zs == 0; next; end
            checked[[x+xs,y+ys,z+zs]] +=1
          else
            (-1..1).each{ |ws|
              if xs == ys && ys == zs && zs == 0 && ws == 0; next; end
              checked[[x+xs,y+ys,z+zs,w+ws]] +=1
            }
          end
        }
      }
    }
  }

  newActive = Hash.new(false);
  checked.each { |pos, c|
    if c==3
      newActive[pos]=true
    else 
      if c == 2 && active[pos] == true
        newActive[pos]=true
      end
    end
  }
  active = newActive
  cycle+=1
end

puts "Answer part 1: #{active.length()}"