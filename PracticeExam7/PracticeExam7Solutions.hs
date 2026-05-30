-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExam7Solutions ( roseSize
                              , roseLeaves
                              , rosePaths
                              , caesarShift
                              , caesarEncode
                              , caesarDecode
                              , addItem
                              , removeItem
                              , getTotal
                              , groupConsecutive
                              , windows
                              , merge
                              , halve
                              , msort
                              , parseKeyValue
                              , evalExpr
                              , showExpr
                              ) where

import Types

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- QUESTION 1 — Rose Trees
---------------------------------------------------------------------------------

-- 1a: Count all nodes in the tree
roseSize :: Rose a -> Int
roseSize (Rose _ children) = 1 + sum (map roseSize children)

-- 1b: Collect the values at all leaves (nodes with no children)
roseLeaves :: Rose a -> [a]
roseLeaves (Rose x []) = [x]
roseLeaves (Rose _ children) = concatMap roseLeaves children

-- 1c: All paths from root to each leaf
rosePaths :: Rose a -> [[a]]
rosePaths (Rose x []) = [[x]]
rosePaths (Rose x children) = map (x:) (concatMap rosePaths children)

---------------------------------------------------------------------------------
-- QUESTION 2 — Caesar Cipher
---------------------------------------------------------------------------------

-- Helper: convert letter to 0-based index
let2int :: Char -> Int
let2int c
  | isLower c = ord c - ord 'a'
  | isUpper c = ord c - ord 'A'
  | otherwise = ord c

-- Helper: convert 0-based index back to letter
int2lower :: Int -> Char
int2lower n = chr (ord 'a' + n)

int2upper :: Int -> Char
int2upper n = chr (ord 'A' + n)

-- 2a: Shift a single character by n positions
caesarShift :: Int -> Char -> Char
caesarShift n c
  | isLower c = int2lower ((let2int c + n) `mod` 26)
  | isUpper c = int2upper ((let2int c + n) `mod` 26)
  | otherwise = c

-- 2b: Encode a string using a shift factor
caesarEncode :: Int -> String -> String
caesarEncode n = map (caesarShift n)

-- 2c: Decode by shifting in the opposite direction
caesarDecode :: Int -> String -> String
caesarDecode n = caesarEncode (-n)

---------------------------------------------------------------------------------
-- QUESTION 3 — State Monad (Shopping Cart)
---------------------------------------------------------------------------------

-- 3a: Add an item to the cart
addItem :: String -> Int -> ShopState ()
addItem name price = do
    cart <- get
    put ((name, price) : cart)

-- 3b: Remove the first occurrence of an item by name
removeItem :: String -> ShopState Bool
removeItem name = do
    cart <- get
    case span (\(n, _) -> n /= name) cart of
      (_, [])       -> pure False
      (before, _:after) -> do put (before ++ after)
                              pure True

-- 3c: Get the total price of all items
getTotal :: ShopState Int
getTotal = do
    cart <- get
    pure (sum (map snd cart))

---------------------------------------------------------------------------------
-- QUESTION 4 — List Processing
---------------------------------------------------------------------------------

-- 4a: Group consecutive equal elements
groupConsecutive :: Eq a => [a] -> [[a]]
groupConsecutive [] = []
groupConsecutive (x:xs) = (x : takeWhile (== x) xs) : groupConsecutive (dropWhile (== x) xs)

-- 4b: Sliding windows of size n
windows :: Int -> [a] -> [[a]]
windows n xs
  | length xs < n = []
  | otherwise     = take n xs : windows n (tail xs)

---------------------------------------------------------------------------------
-- QUESTION 5 — Merge Sort
---------------------------------------------------------------------------------

-- 5a: Merge two sorted lists into one sorted list
merge :: Ord a => [a] -> [a] -> [a]
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
  | x <= y    = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

-- 5b: Split a list into two halves
halve :: [a] -> ([a], [a])
halve xs = splitAt (length xs `div` 2) xs

-- 5c: Merge sort
msort :: Ord a => [a] -> [a]
msort []  = []
msort [x] = [x]
msort xs  = merge (msort left) (msort right)
  where (left, right) = halve xs

---------------------------------------------------------------------------------
-- QUESTION 6 (EXTRA) — Parsing key=value pairs
---------------------------------------------------------------------------------

-- Parse "key=value" where key is one or more lowercase letters
-- and value is one or more alphanumeric characters.

parseKeyValue :: Parser (String, String)
parseKeyValue = do
    k <- some lower
    char '='
    v <- some alphanum
    pure (k, v)

---------------------------------------------------------------------------------
-- QUESTION 7 (EXTRA) — Expression Evaluation
---------------------------------------------------------------------------------

-- 7a: Evaluate an expression, returning Nothing on division by zero.
-- Uses the Maybe monad for automatic error propagation.

evalExpr :: Expr -> Maybe Int
evalExpr (Val n)     = Just n
evalExpr (Add e1 e2) = do v1 <- evalExpr e1
                          v2 <- evalExpr e2
                          pure (v1 + v2)
evalExpr (Sub e1 e2) = do v1 <- evalExpr e1
                          v2 <- evalExpr e2
                          pure (v1 - v2)
evalExpr (Mul e1 e2) = do v1 <- evalExpr e1
                          v2 <- evalExpr e2
                          pure (v1 * v2)
evalExpr (Div e1 e2) = do v1 <- evalExpr e1
                          v2 <- evalExpr e2
                          if v2 == 0 then Nothing
                                     else pure (v1 `div` v2)

-- 7b: Pretty-print an expression with full parenthesisation.

showExpr :: Expr -> String
showExpr (Val n)     = show n
showExpr (Add e1 e2) = "(" ++ showExpr e1 ++ " + " ++ showExpr e2 ++ ")"
showExpr (Sub e1 e2) = "(" ++ showExpr e1 ++ " - " ++ showExpr e2 ++ ")"
showExpr (Mul e1 e2) = "(" ++ showExpr e1 ++ " * " ++ showExpr e2 ++ ")"
showExpr (Div e1 e2) = "(" ++ showExpr e1 ++ " / " ++ showExpr e2 ++ ")"
