-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExam2 ( trieInsert
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
trieInsert [] val (TrieNode _ children) = TrieNode (Just val) children
trieInsert (c:cs) val (TrieNode mv children) = TrieNode mv ((c, trieInsert cs val emptyTrie) : children)

trieLookup :: String -> Trie a -> Maybe a
trieLookup [] (TrieNode mv _) = mv
trieLookup (c:cs) (TrieNode _ children) = case lookup c children of
                                            Nothing -> Nothing
                                            Just sub -> trieLookup cs sub

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

applyUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
applyUntil p f x | p x = [x]
                 | otherwise = x : applyUntilHelper p f x

applyUntilHelper :: (a -> Bool) -> (a -> a) -> a -> [a]
applyUntilHelper p f x | p x = [x]
                 | p (f x) = [f x]
                 | otherwise = f x : applyUntilHelper p f (f x)

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

currentRoom :: Adventure Room
currentRoom = do 
            (room, items) <- get 
            pure (room)

pickUp :: Item -> Adventure ()
pickUp item = do 
            (room, items) <- get
            put (room, addItem items item)
            pure ()

addItem :: [Item] -> Item -> [Item]
addItem [] item = [item]
addItem items item = items ++ [item]

move :: Room -> Adventure ()
move room = do 
            (current, items) <- get
            put (room, [])
            pure ()

adventureExample :: Adventure (Room, [Item])
adventureExample = do
  pickUp "Sword"
  pickUp "Key"
  move "Library"
  pickUp "Book"
  r <- currentRoom
  (_, inv) <- get
  return (r, inv)

adventureExample2 :: Adventure [Item]
adventureExample2 = do
  pickUp "Torch"
  pickUp "Shield"
  (_, inv) <- get
  return inv

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

isSudokuBox :: [[Int]] -> Bool
isSudokuBox box = all (==True) ([notAbovenSquared] ++ [allUnique])
                where 
                    rowLength = length $ box!!1
                    notAbovenSquared = isWithinBoundary rowLength (concat box)
                    allUnique = isAllUnique (concat box)


isAllUnique :: [Int] -> Bool
isAllUnique [] = True
isAllUnique (x:xs) | x `elem` xs = False
                   | otherwise = isAllUnique xs

isWithinBoundary :: Int -> [Int] -> Bool
isWithinBoundary n [] = True
isWithinBoundary n (x:xs) | x < 0 || x > n^2 = False
                          | otherwise = isWithinBoundary n xs

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

evalProp :: PropEnv -> PropExpr -> Maybe Bool
evalProp env (PVar c) = case readEnv env c of
                            Nothing -> Nothing
                            Just p -> Just p
evalProp env (PNot e) = case evalProp env e of
                            Nothing -> Nothing
                            Just p -> Just (not p)
evalProp env (PAnd e e') = case evalProp env e of
                                Nothing -> Nothing
                                Just x -> case evalProp env e' of
                                    Nothing -> Nothing
                                    Just y -> pure (x && y)
evalProp env (POr e e') = case evalProp env e of
                                Nothing -> Nothing
                                Just x -> case evalProp env e' of
                                    Nothing -> Nothing
                                    Just y -> pure (x || y)
evalProp env (PXor e e') = case evalProp env e of
                                Nothing -> Nothing
                                Just x -> case evalProp env e' of
                                    Nothing -> Nothing
                                    Just y -> pure (xor x y)

readEnv :: PropEnv -> Char -> Maybe Bool
readEnv [] _ = Nothing
readEnv ((var, val):envs) c | c == var = Just val
                            | otherwise = readEnv envs c


xor :: Bool -> Bool -> Bool
xor True True = False
xor False False = False
xor True False = True
xor False True = True

propVars :: PropExpr -> [Char]
propVars expr = removeDuplicates $ propVarsHelper expr

propVarsHelper :: PropExpr -> [Char]
propVarsHelper (PVar c) = [c]
propVarsHelper (PNot e) = propVars e
propVarsHelper (PAnd e e') = propVars e ++ propVars e'
propVarsHelper (POr e e') = propVars e ++ propVars e'
propVarsHelper (PXor e e') = propVars e ++ propVars e'

removeDuplicates :: Eq a => [a] -> [a]
removeDuplicates [] = []
removeDuplicates (x:xs) | x `elem` xs = removeDuplicates xs
                        | otherwise = x : removeDuplicates xs
