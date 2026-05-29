-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

---------------------------------------------------------------------------------
------------------------ DO **NOT** MODIFY THIS FILE ----------------------------
---------------------------------------------------------------------------------

module PracticeTypes (module PracticeTypes, module Control.Monad, module Control.Monad.State, module Data.Char, module Data.List) where

import Control.Monad
import Control.Monad.State
import Data.Char
import Data.List

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

data BT a = Empty
           | Fork a (BT a) (BT a)
           deriving (Show, Eq)

-- Some example trees for testing
exampleTree1 :: BT Int
exampleTree1 = Fork 1 (Fork 2 Empty Empty) (Fork 3 Empty Empty)

exampleTree2 :: BT Char
exampleTree2 = Fork 'a' (Fork 'b' (Fork 'c' Empty Empty) Empty) Empty

exampleTree3 :: BT Int
exampleTree3 = Fork 1
                 (Fork 2
                   (Fork 4 Empty Empty)
                   (Fork 5 Empty Empty))
                 (Fork 3
                   (Fork 6 Empty Empty)
                   (Fork 7 Empty Empty))

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

-- (No additional types needed, uses standard Prelude and Data.Char)

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

type Stock = [(String, Int)]       -- list of (itemName, quantity) pairs
type VendingState = (Int, Stock)   -- (money inserted in pence, stock)
type Vending a = State VendingState a

exampleStock :: Stock
exampleStock = [("Coke", 2), ("Water", 3), ("Crisps", 1)]

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

latinSquare1 :: [[Int]]
latinSquare1 = [[1,2,3],[2,3,1],[3,1,2]]

latinSquare2 :: [[Int]]
latinSquare2 = [[1,2,3],[1,2,3],[1,2,3]]

latinSquare3 :: [[Char]]
latinSquare3 = [['a','b'],['b','a']]

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

data AExpr = Lit Int
           | Var Char
           | Add AExpr AExpr
           | Mul AExpr AExpr
           | Neg AExpr
           deriving (Eq, Show)

type Env = [(Char, Int)]

expr1 :: AExpr
expr1 = Add (Var 'x') (Var 'y')

expr2 :: AExpr
expr2 = Mul (Var 'x') (Lit 2)

expr3 :: AExpr
expr3 = Neg (Add (Var 'a') (Var 'b'))

expr4 :: AExpr
expr4 = Add (Var 'x') (Mul (Var 'y') (Var 'x'))
