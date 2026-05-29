-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExamSolutions ( mirror
                             , collectAtDepth
                             , encode
                             , filterMap
                             , insertMoney
                             , buyItem
                             , isLatinSquare
                             , evalAExpr
                             , collectVars
                             ) where

import PracticeTypes
import Data.List

---------------------------------------------------------------------------------
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

mirror :: BT a -> BT a
mirror Empty        = Empty
mirror (Fork x l r) = Fork x (mirror r) (mirror l)

collectAtDepth :: Int -> BT a -> [a]
collectAtDepth _ Empty        = []
collectAtDepth 0 (Fork x _ _) = [x]
collectAtDepth n (Fork _ l r) = collectAtDepth (n-1) l ++ collectAtDepth (n-1) r

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

encode :: String -> [Int]
encode = foldr (\c acc -> ord c : acc) []

filterMap :: (a -> Maybe b) -> [a] -> [b]
filterMap f = foldr (\x acc -> case f x of
                                 Just y  -> y : acc
                                 Nothing -> acc) []

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

insertMoney :: Int -> Vending ()
insertMoney amount = do (money, stock) <- get
                        put (money + amount, stock)

buyItem :: String -> Int -> Vending Bool
buyItem name price = do (money, stock) <- get
                        case lookup name stock of
                          Nothing -> return False
                          Just qty -> if money >= price && qty > 0
                                      then do put (money - price, updateStock name stock)
                                              return True
                                      else return False
  where
    updateStock :: String -> Stock -> Stock
    updateStock _    []          = []
    updateStock item ((n,q):rest)
      | item == n  = (n, q-1) : rest
      | otherwise  = (n, q)   : updateStock item rest

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

isLatinSquare :: Eq a => [[a]] -> Bool
isLatinSquare []       = False
isLatinSquare xss@(r:_) = noDups r && allPerms rows && allPerms cols
  where
    rows     = xss
    cols     = transpose xss
    noDups xs = nub xs == xs
    isPerm xs ys = length xs == length ys && all (`elem` ys) xs && noDups xs
    allPerms = all (\row -> isPerm row r)

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

evalAExpr :: Env -> AExpr -> Maybe Int
evalAExpr _   (Lit n)     = Just n
evalAExpr env (Var c)     = lookup c env
evalAExpr env (Add e1 e2) = do v1 <- evalAExpr env e1
                               v2 <- evalAExpr env e2
                               return (v1 + v2)
evalAExpr env (Mul e1 e2) = do v1 <- evalAExpr env e1
                               v2 <- evalAExpr env e2
                               return (v1 * v2)
evalAExpr env (Neg e)     = do v <- evalAExpr env e
                               return (negate v)

collectVars :: AExpr -> [Char]
collectVars expr = nub (go expr)
  where
    go (Lit _)     = []
    go (Var c)     = [c]
    go (Add e1 e2) = go e1 ++ go e2
    go (Mul e1 e2) = go e1 ++ go e2
    go (Neg e)     = go e
