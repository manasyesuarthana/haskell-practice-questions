-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExam3Solutions ( depthOf
                     , flatten
                     , runLengthEncode
                     , runLengthDecode
                     , deposit
                     , withdraw
                     , getHistory
                     , isToeplitz
                     , execProgram
                     ) where

import Exam3Types
import Data.List

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

-- 1a: depthOf
-- Search the tree depth-first, left-to-right for the first occurrence of x.
-- Return Just its depth, or Nothing if absent.
--
-- Strategy: check the root, then recurse into children. When recursing,
-- we increment by 1. We pick the first successful result from the children
-- (left-to-right) using a helper that finds the first Just.

depthOf :: Eq a => a -> GTree a -> Maybe Int
depthOf x (GNode v children)
  | x == v    = Just 0
  | otherwise = case firstJust (map (depthOf x) children) of
                  Nothing -> Nothing
                  Just d  -> Just (d + 1)

-- Helper: return the first Just value from a list of Maybes
firstJust :: [Maybe a] -> Maybe a
firstJust []             = Nothing
firstJust (Just x  : _ ) = Just x
firstJust (Nothing : xs) = firstJust xs


-- 1b: flatten (pre-order traversal)
-- The root comes first, then we recursively flatten each child subtree.
--
-- Note: the case (GNode x []) is subsumed by the general case because
-- concatMap flatten [] = []. A single clause suffices.

flatten :: GTree a -> [a]
flatten (GNode x children) = x : concatMap flatten children


---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

-- 2a: runLengthEncode using foldr
--
-- The key insight: foldr processes elements right-to-left. When we encounter
-- an element, we check whether the accumulated list already begins with a
-- run of the same element. If so, we increment the count; otherwise we
-- start a new run.
--
-- foldr step [] "aaabbc"
--   step 'a' (step 'a' (step 'a' (step 'b' (step 'b' (step 'c' [])))))
-- Working from the inside:
--   step 'c' []            = [('c',1)]
--   step 'b' [('c',1)]    = [('b',1),('c',1)]
--   step 'b' [('b',1),..] = [('b',2),('c',1)]
--   step 'a' [('b',2),..] = [('a',1),('b',2),('c',1)]
--   step 'a' [('a',1),..] = [('a',2),('b',2),('c',1)]
--   step 'a' [('a',2),..] = [('a',3),('b',2),('c',1)]

runLengthEncode :: Eq a => [a] -> [(a, Int)]
runLengthEncode = foldr step []
  where
    step x []                      = [(x, 1)]
    step x ((y, n) : rest)
      | x == y    = (y, n + 1) : rest
      | otherwise = (x, 1) : (y, n) : rest


-- 2b: runLengthDecode
-- Each (element, count) pair expands to `replicate count element`.
-- We concatenate all such expansions.

runLengthDecode :: [(a, Int)] -> [a]
runLengthDecode [] = []
runLengthDecode ((val, amount):vals) = (replicate amount val) ++ runLengthDecode vals


---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

-- 3a: deposit
-- Add amount to balance, append log entry.

deposit :: Int -> BankAccount ()
deposit amount = do
  (balance, history) <- get
  put (balance + amount, history ++ ["Deposited " ++ show amount])


-- 3b: withdraw
-- If sufficient funds, deduct and log success (return True).
-- Otherwise, log failure and leave balance unchanged (return False).

withdraw :: Int -> BankAccount Bool
withdraw amount = do
  (balance, history) <- get
  if balance >= amount
    then do
      put (balance - amount, history ++ ["Withdrew " ++ show amount])
      return True
    else do
      put (balance, history ++ ["Failed withdrawal of " ++ show amount])
      return False


-- 3c: getHistory
-- Read the transaction history without modifying the state.

getHistory :: BankAccount [Transaction]
getHistory = do
  (_, history) <- get
  return history


---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

-- A matrix is Toeplitz iff A[i][j] == A[i+1][j+1] for all valid i,j.
-- Equivalently: for each pair of adjacent rows, the init of the first row
-- equals the tail of the second row.
--
--   row_k   = [a, b, c, d]
--   row_k+1 = [e, a, b, c]
--
--   init row_k   = [a, b, c]
--   tail row_k+1 = [a, b, c]   ✓ they match
--
-- We check this property for every consecutive pair of rows.

isToeplitz :: Eq a => [[a]] -> Bool
isToeplitz []          = True
isToeplitz [_]         = True
isToeplitz (r1:r2:rs)  = init r1 == tail r2 && isToeplitz (r2:rs)


---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

-- We execute the program instruction-by-instruction, threading the stack
-- through with Maybe to propagate errors.
--
-- Strategy: fold over the instruction list, starting with Just [] (empty stack),
-- applying each instruction via a step function. If at any point we get
-- Nothing, it stays Nothing (using >>= / the Maybe monad).

execProgram :: Program -> Maybe Stack
execProgram prog = exec prog []
  where
    exec :: Program -> Stack -> Maybe Stack
    exec []              s          = Just s
    exec (PUSH n : is)   s          = exec is (n : s)
    exec (ADD    : is)   (a:b:rest) = exec is (b + a : rest)
    exec (MUL    : is)   (a:b:rest) = exec is (b * a : rest)
    exec (DUP    : is)   (a:rest)   = exec is (a : a : rest)
    exec (SWAP   : is)   (a:b:rest) = exec is (b : a : rest)
    exec _               _          = Nothing  -- insufficient operands
