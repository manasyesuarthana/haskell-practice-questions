{-# OPTIONS_GHC -Wno-x-partial #-}

import Data.Char
import Data.List
import System.IO

{-- We restrict ourselves to the traditional 3x3 tictactoe, with the following moves:

             0 | 1 | 2
            ---+---+---
             3 | 4 | 5
            ---+---+---
             6 | 7 | 8

We represent a board by a pair of two lists, for the moves of players
O and X respectively.

Replace "undefined" below by suitable code.

--}

type Move = Int

type Grid = ([Move],[Move])

data Player = O | B | X
              deriving (Eq, Ord, Show)

next :: Player -> Player
next O = X
next B = B
next X = O

empty :: Grid
empty = ([], [])

full :: Grid -> Bool
full (os, xs) | sum (os ++ xs) == 36 = True
              | otherwise = False

turn :: Grid -> Player
turn (os, xs) = if length os <= length xs then O else X

wins :: Player -> Grid -> Bool
wins O (os, _) = any (\line -> all (`elem` os) line) winningLines
wins X (_, xs) = any (\line -> all (`elem` xs) line) winningLines

winningLines :: [[Move]]
winningLines = [ [0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]

won :: Grid -> Bool
won g = wins O g || wins X g 

valid :: Grid -> Move -> Bool
valid (os, xs) i = 0 <= i && i < 9 && not (i `elem` (os ++ xs))

move :: Grid -> Move -> Player -> [Grid]
move (os, xs) i p
  | valid (os, xs) i = [if p == O then (i:os, xs) else (os, i:xs)]
  | otherwise = []

chop :: Int -> [a] -> [[a]]
chop n [] = []
chop n xs = take n xs : chop n (drop n xs)

interleave :: a -> [a] -> [a]
interleave x []     = []
interleave x [y]    = [y]
interleave x (y:ys) = y : x : interleave x ys

showPlayer :: Player -> [String]
showPlayer O = ["   ", " O ", "   "]
showPlayer B = ["   ", "   ", "   "]
showPlayer X = ["   ", " X ", "   "]

showRow :: [Player] -> [String]
showRow = beside . interleave bar . map showPlayer
  where
    beside = foldr1 (zipWith (++))
    bar    = replicate 3 "|"

moveToPlayerGrid :: Grid -> [[Player]] 
moveToPlayerGrid (os, xs) = chop 3 [playerAt i | i <- [0..8]]
                        where
                           playerAt i | i `elem` os = O 
                                      | i `elem` xs = X 
                                      | otherwise = B

putGrid :: Grid -> IO ()
putGrid g = putStrLn . unlines . concat . interleave bar . map showRow $ moveToPlayerGrid g
  where
    bar = [replicate 11 '-']


getNat :: String -> IO Int
getNat prompt = do putStr prompt
                   xs <- getLine
                   if xs /= [] && all isDigit xs then
                      return (read xs)
                   else
                      do putStrLn "ERROR: Invalid number"
                         getNat prompt

tictactoe :: IO ()
tictactoe = run empty O

run :: Grid -> Player -> IO ()
run g p = do cls
             goto (1,1)
             putGrid g
             run' g p

run' :: Grid -> Player -> IO ()
run' g p | wins O g  = putStrLn "Player O wins!\n"
         | wins X g  = putStrLn "Player X wins!\n"
         | full g    = putStrLn "It's a draw!\n"
         | otherwise =
              do i <- getNat (prompt p)
                 case move g i p of
                    []   -> do putStrLn "ERROR: Invalid move"
                               run' g p
                    [g'] -> run g' (next p)

prompt :: Player -> String
prompt p = "Player " ++ show p ++ ", enter your move: "

cls :: IO ()
cls = putStr "\ESC[2J"

goto :: (Int,Int) -> IO ()
goto (x,y) = putStr ("\ESC[" ++ show y ++ ";" ++ show x ++ "H")

moves :: Grid -> Player -> [Grid]
moves g p = undefined

data Tree a = Node a [Tree a]
              deriving Show

gametree :: Grid -> Player -> Tree Grid
gametree g p = Node g [gametree g' (next p) | g' <- moves g p]

prune :: Int -> Tree a -> Tree a
prune 0 (Node x _)  = Node x []
prune n (Node x ts) = Node x [prune (n-1) t | t <- ts]

depth :: Int
depth = 9

minimax :: Tree Grid -> Tree (Grid,Player)
minimax (Node g [])
   | wins O g  = Node (g,O) []
   | wins X g  = Node (g,X) []
   | otherwise = Node (g,B) []
minimax (Node g ts)
   | turn g == O = Node (g, minimum ps) ts'
   | turn g == X = Node (g, maximum ps) ts'
                   where
                     ts' = map minimax ts
                     ps  = [p | Node (_,p) _ <- ts']

bestmove :: Grid -> Player -> Grid
bestmove g p = head [g' | Node (g',p') _ <- ts, p' == best]
               where
                 tree = prune depth (gametree g p)
                 Node (_,best) ts = minimax tree

main :: IO ()
main = do hSetBuffering stdout NoBuffering
          play empty O

play :: Grid -> Player -> IO ()
play g p = do cls
              goto (1,1)
              putGrid g
              play' g p

play' :: Grid -> Player -> IO ()
play' g p
   | wins O g = putStrLn "Player O wins!\n"
   | wins X g = putStrLn "Player X wins!\n"
   | full g   = putStrLn "It's a draw!\n"
   | p == O   = do i <- getNat (prompt p)
                   case move g i p of
                      []   -> do putStrLn "ERROR: Invalid move"
                                 play' g p
                      [g'] -> play g' (next p)
   | p == X   = do putStr "Player X is thinking... "
                   play (bestmove g p) (next p)

supremum, infimum :: [Player] -> Player

supremum []     = O            -- The maximum function would (rightly) give an error instead.
supremum (X:ps) = X            -- Pruning takes place here - we don't look at ps.
supremum (O:ps) = supremum  ps
supremum (B:ps) = supremumB ps -- We now know that supremum ps >= B.
                  where
                    supremumB []     = B
                    supremumB (X:ps) = X -- Pruning takes place here too - we don't look at ps
                    supremumB (_:ps) = supremumB ps

infimum []     =  X
infimum (X:ps) = infimum  ps
infimum (O:ps) = O
infimum (B:ps) = infimumB ps
                 where
                  infimumB []     = B
                  infimumB (O:ps) = O
                  infimumB (_:ps) = infimumB ps

minimax' :: Tree Grid -> Tree (Grid,Player)
minimax' (Node g [])
   | wins O g  = Node (g,O) []
   | wins X g  = Node (g,X) []
   | otherwise = Node (g,B) []
minimax' (Node g ts)
   | turn g == O = Node (g, infimum  ps) ts'
   | turn g == X = Node (g, supremum ps) ts'
                   where
                     ts' = map minimax' ts
                     ps  = [p | Node (_,p) _ <- ts']

bestmove' :: Grid -> Player -> Grid
bestmove' g p = head [g' | Node (g',p') _ <- ts, p' == best]
                where
                  tree = prune depth (gametree g p)
                  Node (_,best) ts = minimax' tree

leavescount :: Tree a -> Int
leavescount (Node _ []) = 1
leavescount (Node _ forest) = sum [leavescount tree | tree <- forest]

alphabeta :: Tree Grid -> Tree (Grid,Player)
alphabeta (Node g [])
   | wins O g  = Node (g,O) []
   | wins X g  = Node (g,X) []
   | otherwise = Node (g,B) []
alphabeta (Node g ts)
   | turn g == O = Node (g, minimum o) (take (length o) ts')
   | turn g == X = Node (g, maximum x) (take (length x) ts')
                   where
                     ts' = map alphabeta ts
                     ps  = [p | Node (_,p) _ <- ts']
                     o = takeUntil (== O) ps
                     x = takeUntil (== X) ps

takeUntil :: (a -> Bool) -> [a] -> [a]
takeUntil p [] = []
takeUntil p (x : xs) | p x       = [x]
                     | otherwise = x : takeUntil p xs