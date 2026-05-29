module PracticeExam4 ( totalSize
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
---------------- DO **NOT** MAKE ANY CHANGES ABOVE THIS LINE --------------------
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- QUESTION 1
---------------------------------------------------------------------------------

totalSize :: FileSystem -> Int
totalSize (File name size) = size
totalSize (Dir name fs) = sum $ map (totalSize) fs

findFiles :: String -> FileSystem -> [String]
findFiles targetName (File name x) | targetName == name = [name]
                                   | otherwise = []
findFiles targetName (Dir name []) = []
findFiles targetName (Dir name fs) = concatMap (findFiles targetName)  fs

---------------------------------------------------------------------------------
-- QUESTION 2
---------------------------------------------------------------------------------

sequenceWhile :: Monad m => (a -> Bool) -> [m a] -> m [a]
sequenceWhile p [] = return []
sequenceWhile p (action:actions) = do
                            res <- action

                            if (p res)
                                then do
                                    rest <- sequenceWhile p actions
                                    pure (res : rest)
                                else
                                    pure []
---------------------------------------------------------------------------------
-- QUESTION 3
---------------------------------------------------------------------------------

turnRight :: Robot ()
turnRight = do 
                (position, direction) <- get
                case direction of
                    North  -> put (position, East)
                    East -> put (position, South)
                    South -> put (position, West)
                    West -> put (position, North)
                pure ()

forward :: Int -> Robot ()
forward steps = do
                (position, direction) <- get
                let (x, y) = position
                case direction of
                    North -> put ((x, y + steps), direction)
                    South -> put ((x, y - steps), direction)
                    East -> put ((x + steps, y), direction)
                    West -> put ((x - steps, y), direction)

                pure ()

execute :: [Command] -> Robot ()
execute [] = pure ()
execute cmds = do
                    mapM_ executeSingle cmds

executeSingle :: Command -> Robot ()
executeSingle (Forward x) = forward x
executeSingle (TurnRight) = turnRight
                    

---------------------------------------------------------------------------------
-- QUESTION 4
---------------------------------------------------------------------------------

isLatinSquare :: [[Int]] -> Bool
isLatinSquare [] = True
isLatinSquare matrix = all (==True) [allPermutationsRows, allPermutationsColumns, allWithinRange, allUnique]
                        where
                            allPermutationsRows = arePermutations matrix
                            allPermutationsColumns = arePermutations (transpose matrix)
                            allWithinRange = areWithinRange (length matrix) (concat matrix)
                            allUnique = all (==True) $ map isAllUnique matrix

arePermutations :: Ord a => [[a]] -> Bool
arePermutations [] = True
arePermutations (xs:xss) = all (==sort xs) (map sort xss)

areWithinRange :: Int -> [Int] -> Bool
areWithinRange _ [] = True
areWithinRange n (x:xs) | x < 0 || x > n = False
                        | otherwise = areWithinRange n xs

isAllUnique :: [Int] -> Bool
isAllUnique [] = True
isAllUnique (x:xs) | x `elem` xs = False
                   | otherwise = isAllUnique xs

---------------------------------------------------------------------------------
-- QUESTION 5
---------------------------------------------------------------------------------

stringify :: JSON -> String
stringify (JNull) = "null"
stringify (JBool x) = show x
stringify (JNum n) = show n
stringify (JStr s) = show s
stringify (JArr xs) =  show $ map stringify xs
stringify (JObj kvs) = "{" ++ parseKeyValue kvs ++ "}"

parseKeyValue :: [(String, JSON)] -> String
parseKeyValue [] = ""
parseKeyValue ((k, v):kvs) = show k ++ ":" ++ stringify v ++ "," ++ parseKeyValue kvs

