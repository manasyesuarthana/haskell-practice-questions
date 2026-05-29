-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExam6 ( insertBST
                     , fromList
                     , toSortedList
                     , zipApply
                     , iterateN
                     , store
                     , recall
                     , addToAcc
                     , runProgram
                     , spiralOrder
                     , eval
                     , simplify
                     , parseList
                     ) where

import Types

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

insertBST :: Ord a => a -> BST a -> BST a
insertBST x (Empty) = Node Empty x Empty
insertBST x (Node l y r) | x > y = Node l y (insertBST x r)
                         | x < y = Node (insertBST x l) y r
                         | otherwise = Node l y r

fromList :: Ord a => [a] -> BST a
fromList [] = Empty
fromList xs = fromListBetween xs Empty

fromListBetween :: Ord a => [a] -> BST a -> BST a
fromListBetween [] t = t
fromListBetween (x:xs) t = fromListBetween xs (insertBST x t)

toSortedList :: BST a -> [a]
toSortedList (Empty) = []
toSortedList (Node l x r) = toSortedList l ++ [x] ++ toSortedList r

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

zipApply :: [a -> b] -> [a] -> [b]
zipApply [] [] = []
zipApply (f:fs) [] = []
zipApply [] (x:xs) = []
zipApply (f:fs) (x:xs) = f x : zipApply fs xs


iterateN :: Int -> (a -> a) -> a -> [a]
iterateN 0 f x = [x]
iterateN n f x = x : iterateN (n-1) f (f x)

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

store :: Int -> Calculator ()
store n = do
        (reg, acc) <- get 
        put (n, acc)
        pure ()

recall :: Calculator Int
recall = do 
        (reg, acc) <- get
        return reg

addToAcc :: Int -> Calculator ()
addToAcc n = do
        (reg, acc) <- get
        put (reg, acc + n)

runProgram :: Calculator a -> (Int, Int) -> ((Int, Int), a)
runProgram prog initState = (ret, res)
                        where
                        (res, ret) = runState prog initState
                        

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

spiralOrder :: Matrix a -> [a]
spiralOrder [] = []
spiralOrder (r:rs) = r ++ spiralOrder (reverse (transpose rs))



---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

eval :: Double -> MathExpr -> Double
eval x (X) = x 
eval x (Lit d) = d
eval x (e :+: e') = eval x e + eval x e'
eval x (e :*: e') = eval x e * eval x e'
eval x (Neg e) = - (eval x e)

simplify :: MathExpr -> MathExpr
simplify (X) = X 
simplify (Lit d) = Lit d
simplify (e :+: e') = case (simplify e, simplify e') of
                                (Lit 0, e2) -> e2
                                (e1, Lit 0) -> e1
                                (Lit x, Lit y) -> Lit (x + y)
                                (e1, e2) -> e1 :+: e2
simplify (e :*: e') = case (simplify e, simplify e') of
                                (Lit 0, e2) -> Lit 0.0
                                (e1, Lit 0) -> Lit 0.0
                                (Lit x, Lit y) -> Lit (x*y)
                                (e1, e2) -> e1 :*: e2
simplify (Neg e) = case simplify e of
                        Lit 0 -> Lit 0
                        e1 -> Neg e1
                        

---------------------------------------------------------------------------------
-- QUESTION 6 (EXTRA - Parsing)
---------------------------------------------------------------------------------

parseList :: Parser [Int]
parseList = do
        char '['
        ns <- parseItems <|> pure []
        char ']'
        pure ns


parseItems :: Parser [Int]
parseItems = do
                n <- integer
                ns <- many (do {char ',' ; space; integer})
                pure (n : ns)