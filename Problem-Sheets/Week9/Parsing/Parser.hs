module Types where

import Data.Char
import Control.Applicative

newtype Parser a = P (String -> [(a, String)])

parse :: Parser a -> String -> [(a, String)]
parse (P p) inp = p inp

-- primitive function (item): fails if input string is empty and succeeds with the first character as the result value
-- Parser Char :: P (String -> [(Char, String)])
item :: Parser Char
item = P (\inp -> case inp of
                    [] -> []
                    (x:xs) -> [(x, xs)])

instance Functor Parser where
    fmap g p = P (\inp -> case parse p inp of
                    [] -> []
                    [(v, out)] -> [(g v, out)]) -- we apply the function to the extracted output

instance Applicative Parser where
    -- pure :: a -> Parser a
    pure v = P (\inp -> [(v, inp)])

    -- (<*>) :: Parser (a -> b) -> Parser a -> Parser b
    pg <*> px = P (\inp -> case parse pg inp of
                                [] -> []
                                [(g, out)] -> parse (fmap g px) out) -- extract the function from pg, then apply g to px (parser x)

instance Monad Parser where

    -- (>>=) :: Parser a -> (a -> Parser b) -> Parser b
    p >>= f = P (\inp -> case parse p inp of
                        [] -> []
                        [(v, out)] -> parse (f v) out) -- if a value is successfully extracted, apply f to v and then pass it to another parser with 'out' as the rest of the input

instance Alternative Parser where
    
    -- empty is passed, we give out an empty list
    -- empty :: Parser a
    empty = P (\inp -> [])

    -- (<|>) :: Parser a -> Parser a -> Parser a
    p <|> q = P (\inp -> case parse p inp of
                            [] -> parse q inp -- if first parser p fails, use the alternative q
                            [(v, out)] -> [(v, out)])

-- check if a certain character matches a predicate
sat :: (Char -> Bool) -> Parser Char
sat p = do 
    x <- item
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
char x = sat (==x)

string :: String -> Parser String
string [] = pure []
string (x:xs) = do
            char x
            string xs
            pure(x:xs)
