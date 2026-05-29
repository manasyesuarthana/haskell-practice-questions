-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExam3 ( depthOf
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

depthOf :: Eq a => a -> GTree a -> Maybe Int
depthOf x (GNode val children) 
    | x == val = Just 0
    | otherwise = case firstJust (map (depthOf x) children) of
                    Nothing -> Nothing
                    Just d -> Just (d + 1)

firstJust :: [Maybe Int] -> Maybe Int
firstJust [] = Nothing
firstJust (Just x : xs) = Just x
firstJust (Nothing : xs) = firstJust xs

flatten :: GTree a -> [a]
flatten (GNode x []) = [x]
flatten (GNode x children) = [x] ++ concatMap flatten children

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

runLengthEncode :: Eq a => [a] -> [(a, Int)]
runLengthEncode = foldr step []
        where 
          step x [] = [(x, 1)]
          step x ((y, val):rest) | x == y = (y, val + 1) : rest
                                 | otherwise = (x, 1) : (y, val) : rest


runLengthDecode :: [(a, Int)] -> [a]
runLengthDecode [] = []
runLengthDecode ((val, amount):vals) = (replicate amount val) ++ runLengthDecode vals

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

deposit :: Int -> BankAccount ()
deposit amount = do
                (balance, transactions) <- get
                let log = "Deposited " ++ show amount
                put (balance + amount, transactions ++ [log])

withdraw :: Int -> BankAccount Bool
withdraw amount = do
                    (balance, transactions) <- get
                    let success = "Withdrew " ++ show amount
                    let failure = "Failed withdrawal of " ++ show amount

                    case (amount > balance) of
                        True -> do
                            put (balance, transactions ++ [failure])
                            return $ False
                        False -> do
                            put (balance - amount, transactions ++ [success])
                            return $ True

getHistory :: BankAccount [Transaction]
getHistory = do
                (balance, transactions) <- get
                return transactions

bankExample :: BankAccount (Bool, Bool, [Transaction])
bankExample = do
  deposit 500
  b1 <- withdraw 200
  b2 <- withdraw 400
  h  <- getHistory
  return (b1, b2, h)

bankExample2 :: BankAccount [Transaction]
bankExample2 = do
  deposit 100
  deposit 250
  _ <- withdraw 50
  getHistory

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

isToeplitz :: Eq a => [[a]] -> Bool     
isToeplitz [] = True
isToeplitz [_] = True
isToeplitz (r1:r2:rs) = init r1 == tail r2 && isToeplitz (r2:rs)

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

execProgram :: Program -> Maybe Stack
execProgram program = exec program []

exec :: Program -> Stack -> Maybe Stack
exec [] stack = Just stack 
exec (PUSH x : insts) stack = exec insts (x : stack)
exec (ADD : insts) (x:y:stack) = exec insts (y + x : stack)
exec (MUL : insts) (x:y:stack) = exec insts (x * y : stack)
exec (DUP : insts) (x : stack) = exec insts (x : x : stack)
exec (SWAP : insts) (x:y:stack) = exec insts (y:x:stack)
exec _ _ = Nothing