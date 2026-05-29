-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExam ( mirror
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
mirror Empty = Empty
mirror (Fork x l r) = Fork x (mirror r) (mirror l)

collectAtDepth :: Int -> BT a -> [a]
collectAtDepth _ Empty = []
collectAtDepth n (Fork x l r) | n == 0 = [x]
                              | otherwise = collectAtDepth (n-1) l ++ collectAtDepth (n-1) r

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

encode :: String -> [Int]
encode [] = []
encode (x:xs) = foldr (\x acc -> ord x : acc) [] (x:xs)

filterMap :: (a -> Maybe b) -> [a] -> [b]
filterMap f xs = foldr (\x acc -> case f x of
                            Nothing -> acc
                            Just y -> y : acc) [] xs

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

insertMoney :: Int -> Vending ()
insertMoney amount = do 
                    (money, stock) <- get
                    put (money + amount, stock)
                    pure ()

buyItem :: String -> Int -> Vending Bool
buyItem name price = do
                       (money, stock) <- get
                       case (money < price) of
                                True -> pure False
                                False -> case checkStock name stock of
                                        0 -> return False
                                        _ -> do
                                            put(money-price, reduceItemStock name stock)
                                            return True 

checkStock :: String -> Stock -> Int
checkStock item ((name, stock):stocks) | item == name = stock
                                     | otherwise = checkStock item stocks


reduceItemStock :: String -> Stock -> Stock
reduceItemStock name ((item, stock):stocks) | name == item = ((item, stock - 1):stocks)
                                            | otherwise = (item, stock) : reduceItemStock name stocks

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

isLatinSquare :: Eq a => [[a]] -> Bool
isLatinSquare [] = True
isLatinSquare s = all (==True) ([rowsCheck] ++ [diagCheck] ++ [colsCheck])
                where
                    rows = s 
                    cols = transpose s
                    dias = [diag s, diag (map reverse s)]
                    rowsCheck = isAllUnique rows
                    diagCheck = isAllUnique dias
                    colsCheck = isAllUnique cols

isAllUnique :: Eq a => [a] -> Bool
isAllUnique [] = True
isAllUnique (x:xs) | x `elem` xs = False
                   | otherwise = isAllUnique xs

diag :: [[a]] -> [a]
diag g = [g !! n !! n | n <- [0..(length g)-1]]


---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

evalAExpr :: Env -> AExpr -> Maybe Int
evalAExpr env (Lit x) = Just x
evalAExpr env (Var x) = case extractEnv env x of
                            Nothing -> Nothing
                            Just x -> Just x

evalAExpr env (Add e e') = case evalAExpr env e of
                                Nothing -> Nothing
                                Just x -> case evalAExpr env e' of
                                    Nothing -> Nothing
                                    Just y -> Just (x + y)

evalAExpr env (Mul e e') = case evalAExpr env e of
                                Nothing -> Nothing
                                Just x -> case evalAExpr env e' of
                                    Nothing -> Nothing
                                    Just y -> Just (x * y)

evalAExpr env (Neg e) = evalAExpr env (Mul (e) (Lit (-1)))
                                

extractEnv :: Env -> Char -> Maybe Int
extractEnv [] x = Nothing
extractEnv ((var, val):envs) x | x == var = Just val
                               | otherwise = extractEnv envs x

collectVars :: AExpr -> [Char]
collectVars expr = case (sort $ removeDuplicates $ collectVarsHelper expr) of
                            xs | length xs == 1 -> xs
                               | otherwise -> drop 1 xs

removeDuplicates :: Eq a => [a] -> [a]
removeDuplicates [] = []
removeDuplicates (x:xs) | x `elem` xs = removeDuplicates xs
                        | otherwise = x : removeDuplicates xs


collectVarsHelper :: AExpr -> [Char]
collectVarsHelper (Lit x) = ""
collectVarsHelper (Var x) = [x]
collectVarsHelper (Add e e') = collectVarsHelper e ++ collectVarsHelper e'
collectVarsHelper (Mul e e') = collectVarsHelper e ++ collectVarsHelper e'
collectVarsHelper (Neg e) = collectVarsHelper e