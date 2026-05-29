-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExam5 ( duplicateDigits
                     , superOdd
                     , areTreeAnagrams
                     , knapsack
                     , crossOff
                     , sieveFrom
                     , primesUpTo
                     ) where

import Types

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

duplicateDigits :: String -> String
duplicateDigits [] = []
duplicateDigits (c:cs) | isDigit c = c : c : duplicateDigits cs
                       | otherwise = c : duplicateDigits cs

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

superOdd :: Int -> Bool
superOdd 0 = False
superOdd n | n `mod` 2 == 0 = False
           | otherwise = case (allOdd $ show n) of 
                        True -> True
                        False -> False

allOdd :: String -> Bool
allOdd [] = True
allOdd (n:ns) | (digitToInt n) `mod` 2 == 0 = False
              | otherwise = allOdd ns



---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

areTreeAnagrams :: Eq a => Tree a -> Tree a -> Bool
areTreeAnagrams (Leaf x) (Leaf y) = x == y 
areTreeAnagrams (Leaf x) (Branch l r) = False
areTreeAnagrams (Branch l r) (Leaf y) = False
areTreeAnagrams (Branch l1 r1) (Branch l2 r2) = areTreeAnagrams l1 r2 && areTreeAnagrams r1 l2 || areTreeAnagrams l1 l2 && areTreeAnagrams r1 r2

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

knapsack :: Int -> [[Item]]
knapsack w | w < 0  = []
           | w == 0 = [[]]
           | otherwise = [ x:xs | x <- [minBound..maxBound]
                        , let wt = weight x
                        , wt <= w
                        , xs <- knapsack (w - wt)
                ] ++ [[]]

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

crossOff :: Int -> [Bool] -> [Bool]
crossOff _ [] = []
crossOff n xs = crossOffFromIndex 1 n xs

crossOffFromIndex :: Int -> Int -> [Bool] -> [Bool]
crossOffFromIndex _ _ [] = []
crossOffFromIndex i n (x:xs) | i > 1 && i /= n && i `mod` n == 0 = False : crossOffFromIndex (i+1) n xs
                             | otherwise = x : crossOffFromIndex (i+1) n xs

sieveFrom :: Int -> [Bool] -> [Bool]
sieveFrom _ [] = []
sieveFrom n xs | n * n > length xs = xs
               | otherwise = case xs!!(n-1) of
                        True -> sieveFrom (n+1) $ crossOff n xs 
                        False -> sieveFrom (n+1) xs

primesUpTo :: Int -> [Int]
primesUpTo 0 = []
primesUpTo n = tail $ trueToPositions 1 (sieveFrom 2 (replicate n True))

trueToPositions :: Int -> [Bool] -> [Int]
trueToPositions _ [] = []
trueToPositions i (x:xs) | x == True = i : trueToPositions (i+1) xs
                         | otherwise = trueToPositions (i+1) xs


---------------------------------------------------------------------------------
-- QUESTION 6
---------------------------------------------------------------------------------

prettyShow :: Expr -> String
prettyShow (E []) = ""
prettyShow (E [Paren (E [])]) = "()"
prettyShow (E [Bracket (E [])]) = "[]"
prettyShow (E [Brace (E [])]) = "{}"
prettyShow (E ts) = concat [f t | t <- ts]
             where f (Paren expr) = "(" ++ prettyShow expr ++ ")"
                   f (Bracket expr) = "[" ++ prettyShow expr ++ "]"
                   f (Brace expr) = "{" ++ prettyShow expr ++ "}"
 

---------------------------------------------------------------------------------
-- QUESTION 7
---------------------------------------------------------------------------------

parseExpression :: Parser Expr
parseExpression = do 
        ts <- many parseToken
        pure (E ts)
        where parseToken = bracket <|> paren <|> brace
            

paren :: Parser Token
paren = do
            char '('
            e <- parseExpression
            char ')'
            pure (Paren e)
            
bracket :: Parser Token
bracket = do
            char '['
            e <- parseExpression
            char ']'
            pure (Bracket e)
brace :: Parser Token
brace = do
            char '{'
            e <- parseExpression
            char '}'
            pure (Brace e)
