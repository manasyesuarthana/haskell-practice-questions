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
duplicateDigits s = undefined

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

superOdd :: Int -> Bool
superOdd n = undefined

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

areTreeAnagrams :: Eq a => Tree a -> Tree a -> Bool
areTreeAnagrams t1 t2 = undefined

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

knapsack :: Int -> [[Item]]
knapsack w = undefined

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

crossOff :: Int -> [Bool] -> [Bool]
crossOff n xs = undefined

sieveFrom :: Int -> [Bool] -> [Bool]
sieveFrom n xs = undefined

primesUpTo :: Int -> [Int]
primesUpTo n = undefined

---------------------------------------------------------------------------------
-- QUESTION 6
---------------------------------------------------------------------------------

prettyShow :: Expr -> String
prettyShow e = undefined

---------------------------------------------------------------------------------
-- QUESTION 7
---------------------------------------------------------------------------------

parseExpression :: Parser Expr
parseExpression = undefined
