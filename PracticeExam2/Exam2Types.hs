-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

---------------------------------------------------------------------------------
-------------------------- DO **NOT** MODIFY THIS FILE --------------------------
---------------------------------------------------------------------------------

module Exam2Types (module Exam2Types, module Control.Monad, module Control.Monad.State, module Data.List) where

import Control.Monad
import Control.Monad.State
import Data.List

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

-- A trie is a tree used for looking up strings character by character.
-- Each node holds a value (if the path so far is a complete key) and
-- a list of (Char, Trie a) pairs representing possible next characters.

data Trie a = TrieNode (Maybe a) [(Char, Trie a)]
  deriving (Show, Eq)

-- An empty trie
emptyTrie :: Trie a
emptyTrie = TrieNode Nothing []

-- Example tries for testing
trieExample1 :: Trie Int
trieExample1 =
  TrieNode Nothing
    [ ('c', TrieNode Nothing
               [ ('a', TrieNode Nothing
                          [ ('t', TrieNode (Just 1) [])
                          , ('r', TrieNode (Just 2) [])
                          ])
               ])
    , ('d', TrieNode Nothing
               [ ('o', TrieNode Nothing
                          [ ('g', TrieNode (Just 3) [])
                          ])
               ])
    ]

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

-- (No additional types needed beyond standard Prelude)

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

-- A simple text-adventure game modelled with the State monad.
-- The state tracks the player's current room and their inventory.

type Room     = String
type Item     = String
type GameState = (Room, [Item])   -- (current room, inventory)
type Adventure a = State GameState a

-- Starting room and item definitions used in examples
startRoom :: Room
startRoom = "Entrance Hall"

sword :: Item
sword = "Sword"

key :: Item
key = "Key"


---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

-- Some example grids for testing isSudokuBox
sudokuBox1 :: [[Int]]
sudokuBox1 = [[1,2,3],[4,5,6],[7,8,9]]

sudokuBox2 :: [[Int]]
sudokuBox2 = [[1,2,3],[4,5,6],[7,8,1]]

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

-- A simple propositional logic expression type extended with XOR.

data PropExpr = PVar   Char
              | PNot   PropExpr
              | PAnd   PropExpr PropExpr
              | POr    PropExpr PropExpr
              | PXor   PropExpr PropExpr   -- exclusive or
              deriving (Eq, Show)

-- An environment maps variable names to Bool values.
type PropEnv = [(Char, Bool)]

-- Some example expressions for testing
pexpr1 :: PropExpr
pexpr1 = PAnd (PVar 'p') (PNot (PVar 'p'))   -- contradiction

pexpr2 :: PropExpr
pexpr2 = POr (PVar 'p') (PNot (PVar 'p'))    -- tautology

pexpr3 :: PropExpr
pexpr3 = PXor (PVar 'p') (PVar 'q')
