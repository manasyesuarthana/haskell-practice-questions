-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns -Wno-x-partial #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

module PracticeExam7 ( roseSize
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
-- QUESTION 1
---------------------------------------------------------------------------------

roseSize :: Rose a -> Int
roseSize (Rose x []) = 1
roseSize (Rose x children) = sum $ 1 : map roseSize children

roseLeaves :: Rose a -> [a]
roseLeaves (Rose x []) = [x]
roseLeaves (Rose x children) = concat $ map roseLeaves children

rosePaths :: Rose a -> [[a]]
rosePaths (Rose x []) = [[x]]
rosePaths (Rose x children) = map (x:) (concatMap rosePaths children)

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

caesarShift :: Int -> Char -> Char
caesarShift n ' ' = ' '
caesarShift n c | isUpper c = chr $ ((ord c - ord 'A') + n) `mod` 26 + ord 'A'
                | otherwise = chr $ ((ord c - ord 'a') + n) `mod` 26 + ord 'a'

caesarEncode :: Int -> String -> String
caesarEncode n cs = map (caesarShift n) cs

caesarDecode :: Int -> String -> String
caesarDecode n cs = map (caesarShift (-n)) cs

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

addItem :: String -> Int -> ShopState ()
addItem name price = do
            cs <- get
            put ((name, price) : cs)

removeItem :: String -> ShopState Bool
removeItem name = do
            cs <- get
            case (isItemPresent name cs) of
                True -> do
                    put (removeItemHelper name cs)
                    pure True
                False ->
                    pure False

isItemPresent :: String -> Cart -> Bool
isItemPresent _ [] = False
isItemPresent name ((item, price):cart) | name == item = True
                                         | otherwise = isItemPresent name cart

removeItemHelper :: String -> Cart -> [(String, Int)]
removeItemHelper _ [] = []
removeItemHelper name ((item, price):cart) | name == item = cart
                                            | otherwise = removeItemHelper name cart

getTotal :: ShopState Int
getTotal = do
        cs <- get
        return (calculateTotal cs)

calculateTotal :: Cart -> Int
calculateTotal [] = 0
calculateTotal ((item, price):cart) = price + calculateTotal cart
---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

groupConsecutive :: Eq a => [a] -> [[a]]
groupConsecutive [] = []
groupConsecutive (x:xs) = (x : takeWhile (==x) xs) : (groupConsecutive $ dropWhile (==x) xs)

windows :: Int -> [a] -> [[a]]
windows _ [] = []
windows n xs | n > length xs = []
             | otherwise = take n xs : windows n (drop 1 xs)

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

merge :: Ord a => [a] -> [a] -> [a]
merge xs [] = xs
merge [] ys = ys
merge (x:xs) (y:ys) = min x y : max x y : merge xs ys

halve :: [a] -> ([a], [a])
halve [] = ([], [])
halve xs = (take (length xs `div` 2) xs, drop (length xs `div` 2) xs)

msort :: Ord a => [a] -> [a]
msort [] = []
msort (x:xs) = msort smaller ++ [x] ++ msort larger
               where
                 smaller = [a | a <- xs, a <= x]
                 larger  = [b | b <- xs, b > x]
---------------------------------------------------------------------------------
-- QUESTION 6 (EXTRA - Parsing) -- DO NOT MARK THIS
---------------------------------------------------------------------------------

parseKeyValue :: Parser (String, String)
parseKeyValue = do
        key <- some lower
        symbol "="
        value <- some alphanum
        pure (key, value)

---------------------------------------------------------------------------------
-- QUESTION 7 (EXTRA - Expression Evaluation)
---------------------------------------------------------------------------------

-- pretty easy question
evalExpr :: Expr -> Maybe Int
evalExpr (Val x) = Just x
evalExpr (Add e e') = case (evalExpr e, evalExpr e') of
                                (Just x, Just y) -> Just (x + y)
                                (_, _) -> Nothing
evalExpr (Sub e e') = case (evalExpr e, evalExpr e') of
                                (Just x, Just y) -> Just (x - y)
                                (_, _) -> Nothing
evalExpr (Mul e e') = case (evalExpr e, evalExpr e') of
                                (Just x, Just y) -> Just (x * y)
                                (_,_) -> Nothing
evalExpr (Div e e') = case (evalExpr e, evalExpr e') of
                                (Just x, Just 0) -> Nothing
                                (Just x, Just y) -> Just (x `div` y)
                                (_,_) -> Nothing

showExpr :: Expr -> String
showExpr (Val x) = show x
showExpr (Add e e') = "(" ++ showExpr e ++ " + " ++ showExpr e' ++ ")"
showExpr (Sub e e') = "(" ++ showExpr e ++ " - " ++ showExpr e' ++ ")"
showExpr (Mul e e') = "(" ++ showExpr e ++ " * " ++ showExpr e' ++ ")"
showExpr (Div e e') = "(" ++ showExpr e ++ " / " ++ showExpr e' ++ ")"
