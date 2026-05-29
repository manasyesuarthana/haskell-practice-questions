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

-- BST type (Binary Search Tree)

data BST a = Empty
           | Node (BST a) a (BST a)
           deriving (Show, Eq)

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

-- No custom types needed (higher-order function question).

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

-- A simple calculator with a register and an accumulator.

type Calculator = State (Int, Int)
-- State is (register, accumulator)
-- The register stores a saved value; the accumulator holds the running result.

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

-- Matrix type alias

type Matrix a = [[a]]

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

-- Symbolic differentiation

data MathExpr = Lit Double
              | X                        -- the variable x
              | MathExpr :+: MathExpr    -- addition
              | MathExpr :*: MathExpr    -- multiplication
              | Neg MathExpr             -- negation
              deriving (Show, Eq)

infixl 6 :+:
infixl 7 :*:

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
