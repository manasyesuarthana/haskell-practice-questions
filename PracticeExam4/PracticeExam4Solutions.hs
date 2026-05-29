module PracticeExam4Solutions ( totalSize
                              , findFiles
                              , sequenceWhile
                              , turnRight
                              , forward
                              , execute
                              , isLatinSquare
                              , stringify
                              ) where

import Exam4Types
import Control.Monad.State
import Data.List

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

totalSize :: FileSystem -> Int
totalSize (File _ size) = size
totalSize (Dir _ contents) = sum (map totalSize contents)

findFiles :: String -> FileSystem -> [String]
findFiles targetName (File name _)
  | name == targetName = [name]
  | otherwise          = []
findFiles targetName (Dir _ contents) = concatMap (findFiles targetName) contents

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

sequenceWhile :: Monad m => (a -> Bool) -> [m a] -> m [a]
sequenceWhile _ [] = return []
sequenceWhile p (action:actions) = do
    res <- action
    if p res 
       then do 
           rest <- sequenceWhile p actions
           return (res : rest)
       else return []

---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

turnRight :: Robot ()
turnRight = do
    (pos, dir) <- get
    let newDir = case dir of
            North -> East
            East  -> South
            South -> West
            West  -> North
    put (pos, newDir)

forward :: Int -> Robot ()
forward steps = do
    ((x, y), dir) <- get
    let newPos = case dir of
            North -> (x, y + steps)
            East  -> (x + steps, y)
            South -> (x, y - steps)
            West  -> (x - steps, y)
    put (newPos, dir)

execute :: [Command] -> Robot ()
execute = mapM_ executeSingle
  where
    executeSingle TurnLeft = do
        (pos, dir) <- get
        let newDir = case dir of
                North -> West
                West  -> South
                South -> East
                East  -> North
        put (pos, newDir)
    executeSingle TurnRight = turnRight
    executeSingle (Forward steps) = forward steps

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

isLatinSquare :: [[Int]] -> Bool
isLatinSquare [] = True
isLatinSquare matrix = 
    let n = length matrix
        expected = [1..n]
        isValid line = sort line == expected
    in all isValid matrix && all isValid (transpose matrix)

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

stringify :: JSON -> String
stringify JNull = "null"
stringify (JBool True) = "true"
stringify (JBool False) = "false"
stringify (JNum n) = show n
stringify (JStr s) = show s
stringify (JArr xs) = "[" ++ concatWith ',' (map stringify xs) ++ "]"
stringify (JObj kvs) = "{" ++ concatWith ',' (map parsePair kvs) ++ "}"
  where
    parsePair (k, v) = show k ++ ":" ++ stringify v

concatWith :: Char -> [String] -> String
concatWith s [] = ""
concatWith s (x:xs) = x ++ show s ++ concatWith s xs