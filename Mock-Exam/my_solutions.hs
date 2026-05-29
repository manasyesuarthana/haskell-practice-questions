-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module MockTest ( isNBranching
                 , prune
                 , applyNTimes
                 , gameOver
                 , takeTokens
                 , isMagicSquare
                 , circuit
                 ) where

import Types
import Data.List

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

isNBranching :: Int -> Rose a -> Bool
isNBranching n (Leaf _) = True
isNBranching n (Branch children) = length children == n && all (\child -> isNBranching n child) children

prune :: Int -> Rose a -> Rose a
prune n (Leaf x) = Leaf x
prune n (Branch children) = Branch (take n (map (\child -> (prune n child)) children))

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

applyNTimes :: Monad m => m a -> (a -> m a) -> Int -> m [a]
applyNTimes mx mf n = reverse <$> go n
                where
                    go 0 = (\x -> [x]) <$> mx -- we turn the wrapped value of x into a list type using fmap <$>
                    go m = do 
                        xs <- go (m-1) -- tail of the list, pass the rest of the elements into mf
                        x <- mf (head xs) -- pass head of the list to mf
                        pure (x:xs) -- return the result list

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

gameOver :: NimGame Bool
gameOver = do
            (heap1, heap2) <- get 
            pure (heap1 == 0 && heap2 == 0)

takeTokens :: Int -> Heap -> NimGame ()
takeTokens n h = do
                (heap1, heap2) <- get
                case h of 
                    First -> if n > heap1
                                then put (0, heap2)
                                else put (heap1 - n, heap2)
                    Second -> if n > heap2
                                then put(heap1, 0)
                                else put (heap1, heap2 - n)

example :: NimGame Bool
example = do takeTokens 5 First
             takeTokens 3 Second
             takeTokens 1 Second
             gameOver


---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

isMagicSquare :: [[Int]] -> Bool
isMagicSquare g = allEqualSum sums
                where 
                    rows = g
                    cols = transpose g
                    dias = [diag g, diag (map reverse g)]
                    combinations = rows ++ cols ++ dias
                    sums = calculateSums combinations

                    
                    

diag :: [[Int]] -> [Int]
diag g = [g !! n !! n | n <- [0..(length g -1)]]

calculateSums :: [[Int]] -> [Int]
calculateSums [] = []
calculateSums (xs:xss) = (sum xs) : calculateSums xss

allEqualSum :: [Int] -> Bool
allEqualSum [] = True
allEqualSum (x:xs) = all (==x) xs

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

circuit :: Expr -> Circuit
circuit (Var x) = Input x
circuit (Not e) = Nand (circuit e) (circuit e)
circuit (And e e') = Nand (Nand (circuit e) (circuit e')) (Nand (circuit e) (circuit e'))
circuit (Or e e') = circuit (Not (And (Not e) (Not e')))
circuit (Implies e e') = circuit (Or (Not e) (e'))
