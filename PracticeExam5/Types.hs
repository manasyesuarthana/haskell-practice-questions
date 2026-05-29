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

-- A string-processing question (no custom types needed).

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

-- A numerical predicate question (no custom types needed).

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

data Tree a = Leaf a
            | Branch (Tree a) (Tree a)
            deriving (Show, Eq)

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

data Item = Gem | Scroll | Potion | Shield
            deriving (Show, Eq, Ord, Enum, Bounded)

class Weighable a where
  weight :: a -> Int

instance Weighable Item where
  weight Gem    = 1
  weight Scroll = 2
  weight Potion = 3
  weight Shield = 5

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

-- Sieve of Eratosthenes helper types
-- No custom types needed; the question operates on [Bool] and [Int].

---------------------------------------------------------------------------------
-- QUESTION 6 & 7 - Bracket Expressions and Parsing
---------------------------------------------------------------------------------

-- Bracket expression types

data Token = Paren   Expr
           | Bracket Expr
           | Brace   Expr
           deriving (Show, Eq)

data Expr = E [Token]
          deriving (Show, Eq)

-- Example expressions for testing

expr1 :: Expr
expr1 = E [Paren (E [])]
-- represents "()"

expr2 :: Expr
expr2 = E [Paren (E []), Bracket (E []), Brace (E [])]
-- represents "()[]{}"

expr3 :: Expr
expr3 = E [Paren (E [Bracket (E [Brace (E [])])])]
-- represents "([{}])"

expr4 :: Expr
expr4 = E [Paren (E [Paren (E [])]), Bracket (E [Brace (E [])])]
-- represents "(())[{}]"

---------------------------------------------------------------------------------
-- Parser infrastructure (provided — do NOT redefine these)
---------------------------------------------------------------------------------

newtype Parser a = P (String -> [(a, String)])

parse :: Parser a -> String -> [(a, String)]
parse (P p) inp = p inp

item :: Parser Char
item = P (\inp -> case inp of
                     []     -> []
                     (x:xs) -> [(x,xs)])

instance Functor Parser where
  -- fmap :: (a -> b) -> Parser a -> Parser b
  fmap g p = P (\inp -> case parse p inp of
                           []        -> []
                           [(v,out)] -> [(g v, out)])

instance Applicative Parser where
  -- pure :: a -> Parser a
  pure v = P (\inp -> [(v,inp)])
  -- (<*>) :: Parser (a -> b) -> Parser a -> Parser b
  pg <*> px = P (\inp -> case parse pg inp of
                   []         -> []
                   [(g, out)] -> parse (fmap g px) out)

instance Monad Parser where
  -- (>>=) :: Parser a -> (a -> Parser b) -> Parser b
  p >>= f = P (\inp -> case parse p inp of
                          []        -> []
                          [(v,out)] -> parse (f v) out)

instance Alternative Parser where
  -- empty :: Parser a
  empty = P (\_ -> [])
  -- (<|>) :: Parser a -> Parser a -> Parser a
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

upper :: Parser Char
upper = sat isUpper

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

identifier :: Parser String
identifier = token ident
  where ident = do x  <- lower
                   xs <- many alphanum
                   pure (x:xs)

natural :: Parser Int
natural = token nat
  where nat = do xs <- some digit
                 pure (read xs)
