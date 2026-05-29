-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExam2Solutions ( trieInsert
                               , trieLookup
                               , applyUntil
                               , currentRoom
                               , pickUp
                               , move
                               , isSudokuBox
                               , evalProp
                               , propVars
                               ) where

import Exam2Types
import Data.List

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

trieInsert :: String -> a -> Trie a -> Trie a
trieInsert []     val (TrieNode _ children) = TrieNode (Just val) children
trieInsert (c:cs) val (TrieNode mv children) =
  case lookup c children of
    Nothing   -> TrieNode mv ((c, trieInsert cs val emptyTrie) : children)
    Just sub  -> TrieNode mv (map (\(k,v) -> if k == c
                                              then (k, trieInsert cs val v)
                                              else (k, v)) children)

trieLookup :: String -> Trie a -> Maybe a
trieLookup []     (TrieNode mv _)        = mv
trieLookup (c:cs) (TrieNode _  children) =
  case lookup c children of
    Nothing  -> Nothing
    Just sub -> trieLookup cs sub

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

applyUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
applyUntil p f x
  | p x       = [x]
  | otherwise = x : applyUntil p f (f x)

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

currentRoom :: Adventure Room
currentRoom = do
  (room, _) <- get
  return room

pickUp :: Item -> Adventure ()
pickUp item = do
  (room, inv) <- get
  put (room, inv ++ [item])

move :: Room -> Adventure ()
move room = do
  put (room, [])

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

isSudokuBox :: [[Int]] -> Bool
isSudokuBox grid = sort (concat grid) == [1..n*n]
  where n = length grid

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

lookupProp :: PropEnv -> Char -> Maybe Bool
lookupProp []              _ = Nothing
lookupProp ((c, b) : rest) x
  | c == x    = Just b
  | otherwise = lookupProp rest x

evalProp :: PropEnv -> PropExpr -> Maybe Bool
evalProp env (PVar x)   = lookupProp env x
evalProp env (PNot e)   = fmap not (evalProp env e)
evalProp env (PAnd e1 e2) = do
  b1 <- evalProp env e1
  b2 <- evalProp env e2
  return (b1 && b2)
evalProp env (POr e1 e2) = do
  b1 <- evalProp env e1
  b2 <- evalProp env e2
  return (b1 || b2)
evalProp env (PXor e1 e2) = do
  b1 <- evalProp env e1
  b2 <- evalProp env e2
  return (b1 /= b2)

propVars :: PropExpr -> [Char]
propVars = nub . go
  where
    go (PVar c)       = [c]
    go (PNot e)       = go e
    go (PAnd e1 e2)   = go e1 ++ go e2
    go (POr  e1 e2)   = go e1 ++ go e2
    go (PXor e1 e2)   = go e1 ++ go e2
