-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

---------------------------------------------------------------------------------
-------------------------- DO **NOT** MODIFY THIS FILE --------------------------
---------------------------------------------------------------------------------

module Exam3Types (module Exam3Types, module Control.Monad, module Control.Monad.State, module Data.List) where

import Control.Monad
import Control.Monad.State
import Data.List

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

-- A general tree (multi-way tree) where data is stored at the nodes
-- and leaves are empty branches (a node with an empty list of children).
data GTree a = GNode a [GTree a]
  deriving (Show, Eq)

gtreeExample1 :: GTree Int
gtreeExample1 = GNode 1 [GNode 2 [GNode 5 [], GNode 6 [] ], GNode 3 [], GNode 4 [ GNode 7 [ GNode 8 [] ] ] ]
                         

gtreeExample2 :: GTree Char
gtreeExample2 = GNode 'a' [ GNode 'b' []
                           , GNode 'c' [ GNode 'd' [] ] ]

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

-- (No additional types needed beyond standard Prelude)

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

-- A simple bank account modelled with the State monad.
-- The state tracks the current balance and the transaction history.

type Balance = Int
type Transaction = String
type AccountState = (Balance, [Transaction])
type BankAccount a = State AccountState a

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

-- Some example grids for testing isToeplitz
toeplitz1 :: [[Int]]
toeplitz1 = [[1,2,3,4],[5,1,2,3],[6,5,1,2]]

toeplitz2 :: [[Int]]
toeplitz2 = [[1,2,3],[4,1,2],[5,4,1]]

notToeplitz :: [[Int]]
notToeplitz = [[1,2,3],[4,5,6],[7,8,9]]

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

-- A small language of stack-based instructions.
-- A program is a sequence of instructions that operates on a stack of integers.

data Instr = PUSH Int       -- Push an integer onto the stack
           | ADD             -- Pop two values, push their sum
           | MUL             -- Pop two values, push their product
           | DUP             -- Duplicate the top of the stack
           | SWAP            -- Swap the top two elements
           deriving (Eq, Show)

type Stack = [Int]
type Program = [Instr]

exampleProg1 :: Program
exampleProg1 = [PUSH 3, PUSH 5, ADD]              -- result: [8]

exampleProg2 :: Program
exampleProg2 = [PUSH 2, DUP, MUL]                 -- result: [4]

exampleProg3 :: Program
exampleProg3 = [PUSH 1, PUSH 2, PUSH 3, SWAP, ADD] -- result: [5,1]
