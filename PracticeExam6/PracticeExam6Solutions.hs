-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExam6Solutions ( insertBST
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
-- QUESTION 1 — Binary Search Trees
---------------------------------------------------------------------------------

insertBST :: Ord a => a -> BST a -> BST a
insertBST x Empty = Node Empty x Empty
insertBST x (Node l v r)
  | x < v    = Node (insertBST x l) v r
  | x > v    = Node l v (insertBST x r)
  | otherwise = Node l v r  -- duplicate, no change

fromList :: Ord a => [a] -> BST a
fromList = foldl (flip insertBST) Empty

toSortedList :: BST a -> [a]
toSortedList Empty        = []
toSortedList (Node l v r) = toSortedList l ++ [v] ++ toSortedList r

---------------------------------------------------------------------------------
-- QUESTION 2 — Higher-Order Functions
---------------------------------------------------------------------------------

zipApply :: [a -> b] -> [a] -> [b]
zipApply [] _          = []
zipApply _ []          = []
zipApply (f:fs) (x:xs) = f x : zipApply fs xs

iterateN :: Int -> (a -> a) -> a -> [a]
iterateN 0 _ x = [x]
iterateN n f x = x : iterateN (n - 1) f (f x)

---------------------------------------------------------------------------------
-- QUESTION 3 — State Monad (Calculator)
---------------------------------------------------------------------------------

store :: Int -> Calculator ()
store n = do
    (_, acc) <- get
    put (n, acc)

recall :: Calculator Int
recall = do
    (reg, _) <- get
    pure reg

addToAcc :: Int -> Calculator ()
addToAcc n = do
    (reg, acc) <- get
    put (reg, acc + n)

runProgram :: Calculator a -> (Int, Int) -> ((Int, Int), a)
runProgram prog initState = let (a, s) = runState prog initState
                            in (s, a)

---------------------------------------------------------------------------------
-- QUESTION 4 — Spiral Order
---------------------------------------------------------------------------------

spiralOrder :: Matrix a -> [a]
spiralOrder [] = []
spiralOrder (r:rs) = r ++ spiralOrder (reverse (transpose rs))

---------------------------------------------------------------------------------
-- QUESTION 5 — Symbolic Expressions
---------------------------------------------------------------------------------

eval :: Double -> MathExpr -> Double
eval _ (Lit c)  = c
eval x X          = x
eval x (a :+: b)  = eval x a + eval x b
eval x (a :*: b)  = eval x a * eval x b
eval x (Neg a)    = negate (eval x a)

simplify :: MathExpr -> MathExpr
simplify (Lit c)  = Lit c
simplify X          = X
simplify (Neg e)    = case simplify e of
                        Lit 0 -> Lit 0
                        e'      -> Neg e'
simplify (a :+: b)  = case (simplify a, simplify b) of
                        (Lit 0, b')      -> b'
                        (a',      Lit 0) -> a'
                        (Lit x, Lit y) -> Lit (x + y)
                        (a',      b')      -> a' :+: b'
simplify (a :*: b)  = case (simplify a, simplify b) of
                        (Lit 0, _)       -> Lit 0
                        (_,       Lit 0) -> Lit 0
                        (Lit 1, b')      -> b'
                        (a',      Lit 1) -> a'
                        (Lit x, Lit y) -> Lit (x * y)
                        (a',      b')      -> a' :*: b'

---------------------------------------------------------------------------------
-- QUESTION 6 (EXTRA) — Parsing a list of integers
---------------------------------------------------------------------------------

parseList :: Parser [Int]
parseList = do
    char '['
    ns <- parseItems <|> pure []
    char ']'
    pure ns
  where
    parseItems :: Parser [Int]
    parseItems = do
        n <- integer
        ns <- many (do { char ',' ; space ; integer })
        pure (n : ns)
