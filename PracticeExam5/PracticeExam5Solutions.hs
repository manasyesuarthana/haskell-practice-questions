-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExam5Solutions ( duplicateDigits
                              , superOdd
                              , areTreeAnagrams
                              , knapsack
                              , crossOff
                              , sieveFrom
                              , primesUpTo
                              , prettyShow
                              , parseExpression
                              ) where

import Types

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

duplicateDigits :: String -> String
duplicateDigits ""     = ""
duplicateDigits (c:cs)
  | isDigit c = c : c : duplicateDigits cs
  | otherwise = c : duplicateDigits cs

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

digits :: Int -> [Int]
digits n = map digitToInt (show (abs n))

superOdd :: Int -> Bool
superOdd n = all odd (digits n)

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

areTreeAnagrams :: Eq a => Tree a -> Tree a -> Bool
areTreeAnagrams (Leaf a)       (Leaf b)       = a == b
areTreeAnagrams (Branch a b)   (Branch c d)   = (areTreeAnagrams a c && areTreeAnagrams b d)
                                              || (areTreeAnagrams a d && areTreeAnagrams b c)
areTreeAnagrams (Branch _ _)   (Leaf _)       = False
areTreeAnagrams (Leaf _)       (Branch _ _)   = False

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

knapsack :: Int -> [[Item]]
knapsack 0 = [[]]
knapsack w
  | w < 0     = []
  | otherwise = [ x:xs | x <- [minBound..maxBound]
                        , let wt = weight x
                        , wt <= w
                        , xs <- knapsack (w - wt)
                ] ++ [[]]

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

crossOff :: Int -> [Bool] -> [Bool]
crossOff n xs = [ if i > 1 && i /= n && i `mod` n == 0 then False else xs !! (i-1)
                | i <- [1..length xs]
                ]

sieveFrom :: Int -> [Bool] -> [Bool]
sieveFrom n xs
  | n * n > length xs = xs
  | xs !! (n - 1)     = sieveFrom (n + 1) (crossOff n xs)
  | otherwise         = sieveFrom (n + 1) xs

primesUpTo :: Int -> [Int]
primesUpTo n = [ i | i <- [2..n], sieved !! (i - 1) ]
  where sieved = sieveFrom 2 (replicate n True)

---------------------------------------------------------------------------------
-- QUESTION 6
---------------------------------------------------------------------------------

prettyShow :: Expr -> String
prettyShow (E [])                = ""
prettyShow (E (Paren   e : ts))  = "(" ++ prettyShow e ++ ")" ++ prettyShow (E ts)
prettyShow (E (Bracket e : ts))  = "[" ++ prettyShow e ++ "]" ++ prettyShow (E ts)
prettyShow (E (Brace   e : ts))  = "{" ++ prettyShow e ++ "}" ++ prettyShow (E ts)

---------------------------------------------------------------------------------
-- QUESTION 7
---------------------------------------------------------------------------------

parseExpression :: Parser Expr
parseExpression = do
    ts <- many parseToken
    pure (E ts)
  where
    parseToken :: Parser Token
    parseToken = parseParen <|> parseBracket <|> parseBrace

    parseParen :: Parser Token
    parseParen = do
        char '('
        e <- parseExpression
        char ')'
        pure (Paren e)

    parseBracket :: Parser Token
    parseBracket = do
        char '['
        e <- parseExpression
        char ']'
        pure (Bracket e)

    parseBrace :: Parser Token
    parseBrace = do
        char '{'
        e <- parseExpression
        char '}'
        pure (Brace e)
