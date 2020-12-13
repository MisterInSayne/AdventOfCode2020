data Pos x = Pos x x deriving (Eq, Ord, Show)
data Dir = E|S|W|N deriving (Eq, Ord, Show, Read, Enum, Bounded)
dirPos :: Dir -> Pos Int
dirPos E=Pos 0 1
dirPos S=Pos (-1) 0
dirPos W=Pos 0 (-1)
dirPos N=Pos 1 0

pMult :: Pos Int -> Int -> Pos Int
(Pos x y) `pMult` m = Pos (x*m) (y*m)

pAdd :: Pos Int -> Pos Int -> Pos Int
(Pos x y) `pAdd` (Pos x2 y2) = Pos (x+x2) (y+y2)

manhattanDist :: Pos Int -> Int
manhattanDist (Pos x y) = (abs(x)+abs(y))

rotDir :: Int -> Dir
rotDir x = ([minBound .. maxBound] :: [Dir])!!(mod (x `div` 90) 4)

rotWP :: (Pos Int, Int) -> Pos Int
rotWP ((Pos x y), r) = do
  case (mod (r `div` 90) 4) of
    1->Pos (-y) x
    2->Pos (-x) (-y)
    3->Pos y (-x)
    n->Pos x y

doInst :: ([Char], Int) -> (Pos Int, Int) -> (Pos Int, Int)
doInst (s, i) (p, r) = do 
  case s of
    "F"-> ((p `pAdd` (dirPos(rotDir(r)) `pMult` i)), r)
    "R"-> (p, (r+i))
    "L"-> (p, (r-i))
    n -> ((p `pAdd` (dirPos(read n::Dir) `pMult` i)), r)

recDoInst :: [([Char], Int)] -> (Pos Int, Int)
recDoInst instructions = rec (Pos 0 0, 0) instructions
  where
    rec :: (Pos Int, Int) -> [([Char], Int)] -> (Pos Int, Int)
    rec (p, r) [] = (p, r)
    rec (p, r) ((s, i):xi) = rec (doInst (s,i) (p,r)) xi


doInstP2 :: ([Char], Int) -> (Pos Int, Pos Int) -> (Pos Int, Pos Int)
doInstP2 (s, i) (p, w) = do 
  case s of
    "F"-> ((p `pAdd` (w `pMult` i)), w)
    "R"-> (p, rotWP (w, i))
    "L"-> (p, rotWP (w, (-i)))
    n -> (p, w `pAdd` (dirPos(read n::Dir) `pMult` i))

recDoInstP2 :: [([Char], Int)] -> (Pos Int, Pos Int)
recDoInstP2 instructions = rec (Pos 0 0, Pos 1 10) instructions
  where
    rec :: (Pos Int, Pos Int) -> [([Char], Int)] -> (Pos Int, Pos Int)
    rec (p, w) [] = (p, w)
    rec (p, w) ((s, i):xi) = rec (doInstP2 (s,i) (p,w)) xi

main = do
  instr <- words <$> getContents
  
  let a = [([head x],read (drop 1 x) :: Int) | x <- instr]
  let (endpos, endrot) = recDoInst a
  let (endposP2, endwp) = recDoInstP2 a
  let outcome = manhattanDist endpos
  let outcomeP2 = manhattanDist endposP2
  print ("Answer Part 1: " ++ (show outcome))
  print ("Answer Part 2: " ++ (show outcomeP2))