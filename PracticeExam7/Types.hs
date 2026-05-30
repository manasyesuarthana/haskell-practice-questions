-- setting the "warn-incomplete-patterns" flag asks GHC to warn you
-- about possible missing cases in pattern-matching definitions
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

-- see https://wiki.haskell.org/Safe_Haskell
{-# LANGUAGE NoGeneralizedNewtypeDeriving, Safe #-}

---------------------------------------------------------------------------------
-------------------------- DO **NOT** MODIFY THIS FILE --------------------------
---------------------------------------------------------------------------------

module Types (module Types, module Control.Monad, module Control.Monad.State,
              module Data.Char, module Data.List, module Control.Applicative) where

import Control.Monad
import Control.Monad.State
import Control.Applicative
import Data.Char
import Data.List

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

-- Rose tree: a value and a list of children

data Rose a = Rose a [Rose a]
            deriving (Show, Eq)

-- Example rose trees for testing

roseEx1 :: Rose Int
roseEx1 = Rose 1 []
-- a single leaf

roseEx2 :: Rose Int
roseEx2 = Rose 1 [Rose 2 [], Rose 3 [], Rose 4 []]
-- root with three leaf children

roseEx3 :: Rose Int
roseEx3 = Rose 1 [Rose 2 [Rose 5 [], Rose 6 []], Rose 3 [], Rose 4 [Rose 7 []]]
-- a deeper tree:
--        1
--      / | \
--     2  3  4
--    / \    |
--   5   6   7

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

-- Caesar cipher (uses Data.Char functions: ord, chr, isLower, isUpper)
-- No custom types needed.

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

-- Shopping cart state monad
-- State is a list of (item name, unit price) pairs.

type Cart = [(String, Int)]
type ShopState = State Cart

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

-- List processing — no custom types needed.

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

-- Merge sort — no custom types needed.

---------------------------------------------------------------------------------
-- QUESTION 7 (EXTRA - Expression Evaluation)
---------------------------------------------------------------------------------

-- Arithmetic expressions with division (which can fail)

data Expr = Val Int
          | Add Expr Expr
          | Sub Expr Expr
          | Mul Expr Expr
          | Div Expr Expr     -- can fail with division by zero
          deriving (Show, Eq)

-- Example expressions for testing

expr1 :: Expr
expr1 = Add (Val 2) (Val 3)
-- represents: 2 + 3 = 5

expr2 :: Expr
expr2 = Mul (Add (Val 1) (Val 2)) (Val 4)
-- represents: (1 + 2) * 4 = 12

expr3 :: Expr
expr3 = Div (Val 10) (Val 0)
-- represents: 10 / 0 = error!

expr4 :: Expr
expr4 = Add (Div (Val 10) (Val 2)) (Mul (Val 3) (Sub (Val 5) (Val 1)))
-- represents: (10 / 2) + (3 * (5 - 1)) = 5 + 12 = 17

---------------------------------------------------------------------------------
-- QUESTION 6 (EXTRA - Parsing)
---------------------------------------------------------------------------------

-- Parser infrastructure (provided — do NOT redefine these)

newtype Parser a = P (String -> [(a, String)])

parse :: Parser a -> String -> [(a, String)]
parse (P p) inp = p inp

item :: Parser Char
item = P (\inp -> case inp of
                     []     -> []
                     (x:xs) -> [(x,xs)])

instance Functor Parser where
  fmap g p = P (\inp -> case parse p inp of
                           []        -> []
                           [(v,out)] -> [(g v, out)])

instance Applicative Parser where
  pure v = P (\inp -> [(v,inp)])
  pg <*> px = P (\inp -> case parse pg inp of
                   []         -> []
                   [(g, out)] -> parse (fmap g px) out)

instance Monad Parser where
  p >>= f = P (\inp -> case parse p inp of
                          []        -> []
                          [(v,out)] -> parse (f v) out)

instance Alternative Parser where
  empty = P (\_ -> [])
  p <|> q = P (\inp -> case parse p inp of
                          []        -> parse q inp
                          [(v,out)] -> [(v,out)])

-- Derived parser primitives

sat :: (Char -> Bool) -> Parser Char
sat p = do x <- item
           if p x then pure x else empty

digit :: Parser Char
digit = sat isDigit

lower :: Parser Char
lower = sat isLower

letter :: Parser Char
letter = sat isAlpha

alphanum :: Parser Char
alphanum = sat isAlphaNum

char :: Char -> Parser Char
char x = sat (== x)

string :: String -> Parser String
string []     = pure []
string (x:xs) = do char x
                   string xs
                   pure (x:xs)

space :: Parser ()
space = do _ <- many (sat isSpace)
           pure ()

token :: Parser a -> Parser a
token p = do space
             v <- p
             space
             pure v

symbol :: String -> Parser String
symbol xs = token (string xs)

natural :: Parser Int
natural = token nat
  where nat = do xs <- some digit
                 pure (read xs)

integer :: Parser Int
integer = token int
  where int = do _ <- char '-'
                 n <- natural
                 pure (-n)
              <|> natural
