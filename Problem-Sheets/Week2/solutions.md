# Manasye's Solutions for the Week 2 FP Problem Sheet

solution.hs:
```haskell
import Data.Char
-- 1. write 5 ill-typed expressions in Haskell

-- ill typed expression 1
-- 5 :: Char --  no instance of the literal 5 in the Char type
-- 5 - 'a' -- no instance of subtracting literals in the Char type
-- True - False -- no instance of '-' or substraction in the boolean type
-- 5 == True -- cannot compare Bool type and the literal 5
-- 'a' == "a" -- Char is not the same as [Char] types

-- 2. Explain, in your own words, what the function zip does. In the expression zip ['x', 'y'] [False], what are the type variables a and b of zip :: [a] -> [b] -> [(a, b)] instantiated by?
-- the zip function takes two lists [a], [b] of any type and creates a list of tuples where each tuple consists of two elements from the same index in the two lists. 
-- For example: [a] = [1,2], [b] = ['a','b'], zip the two lists will create [(1, 'a'),(2, 'b')]. Index 0 from two lists -> 1 and 'a' -> first tuple and so on.
-- In zip ['x', 'y'] [False], a and b can be any type.

-- 3. Find a polymorphic function in the GHC standard library whose type contains 3 type variables or more.
-- 4. Read Section 3.7 of Programming in Haskell. Compare the types of the examples given there with the types ghci indicates. (Note: some of the types that ghci shows use "type classes" - you will learn about these in the next lesson.)

-- 5. Standard Library Functions and Hoogle

{--
Look up the following functions for manipulating lists on
Hoogle and write down their types.  For
each function, read the description and try the function on a sample list.

-- length = outputs a length of a list, e.g. length [1,2,3] = 3
-- reverse = reverses a list, e.g. reverse [1,2,3] = [3,2,1]
-- tail = takes a tail of a list (list without its head), e.g. tail [1,2,3] = [2,3]
-- head = takes the first element of a list, e.g. head [1,2,3] = 1
-- take = takes the first n elements of a list, e.g. take 2 [1,2,3] = [1,2]
-- drop = drops the first n elements of a list
-- takeWhile * = takes elements of a list until a given predicate is false, e.g. takeWhile (>1) [5,4,3,2,1] = [5,4,3,2]
-- dropWhile * = same logic as above but for dropping dropWhile (>1) [5,4,3,2,1] = [1]
-- filter * = takes an element of a list that satisfies a given predicate and keeps the order filter (>2) [4,3,1,5,2] = [4,3,5]
-- all * = checks whether all elements in a list satisfies a given predicate. returns True or False
-- any * = checks whether one or more elements satisfies a given predicate. also returns True or False
-- map ** = applies a given function to all elements in a list, e.g. map doubleMe [1,2,3,4] = [2,4,6,8]

--} 

doubleMe :: Int -> Int
doubleMe x = x + x

-- 5. Writing Function in Haskell

-- (1) Write a function orB :: Bool -> Bool -> Bool that returns True if at least one argument is True.
orB :: Bool -> Bool -> Bool
orB _ True = True
orB _ True = True
orB False False = False

-- (2) Write a function swap :: (a, b) -> (b, a) that swaps the elements of a pair.
swap :: (a, b) -> (b, a)
swap (x, y) = (y, x)

-- (3) Write a function that removes both the first and the last element of a list.
removeFirstLast :: [a] -> [a]
removeFirstLast [] = []
removeFirstLast xs = reverse(tail (reverse (tail xs)))

-- (4) Write a function which returns the reverse of a list if its length is greater than 7.  Now modify the function so that the cutoff length is a parameter.
reverseLengthLargerSeven :: [a] -> [a]
reverseLengthLargerSeven [] = []
reverseLengthLargerSeven xs | length xs > 7 = reverse xs
                            | otherwise = xs

reverseLengthGreaterN :: Int -> [a] -> [a]
reverseLengthGreaterN _ [] = []
reverseLengthGreaterN n xs | length xs > n = reverse xs
                         | otherwise = xs

-- (5) Write a function which doubles all the elements of a list l :: [Int] and then keeps only those which are greater than 10.
doubleAndKeepGreaterTen :: [Int] -> [Int]
doubleAndKeepGreaterTen [] = []
doubleAndKeepGreaterTen l = filter (>10) (map doubleMe l)

-- (6) Write a function to return the reverse of a string with all its alphabetic elements capitalized. (The function toUpper :: Char -> Char in the Data.Char library may be useful here.)


-- 7. Writing More Functions
reverseAndUpper :: [Char] -> [Char]
reverseAndUpper "" = ""
reverseAndUpper cs = map toUpper (reverse cs)

-- (1) Write a function to pair each element of a list with its index. For example, [76,4,17] should result in [(0,76),(1,4),(2,17)]
pairIndex :: [Int] -> [(Int, Int)]
pairIndex [] = []
pairIndex xs = zip [0..length xs-1] xs

-- (2) Using guarded equations, write a function of type Int -> Int -> Bool that returns True if the first argument is greater than the second and less than twice the second.
someFunction :: Int -> Int -> Bool
someFunction x y | x > y && x < 2*y = True
                 | otherwise = False


-- (3) (Adapted and expanded from the book "Programming in Haskell) 
-- Define three variants of a function third :: [a] -> a that returns the third element in any list that contains at least 3 elements, using

-- head and tail
thirdHeadAndTail :: [a] -> Maybe a
thirdHeadAndTail [] = Nothing
thirdHeadAndTail xs = Just (head (tail (tail xs)))


-- list indexing !!
thirdIndex :: [a] -> Maybe a
thirdIndex [] = Nothing
thirdIndex xs = Just (xs!!2)

-- pattern matching
thirdPatternMatch :: [a] -> Maybe a
thirdPatternMatch [] = Nothing
thirdPatternMatch (x:y:z:xs) = Just z

-- (Adapted and expanded from the book "Programming in Haskell)
-- Define a function safetail :: [a] -> [a] that behaves like tail except that it maps [] to [] (instead of throwing an error). Using tail and isEmpty :: [a] -> Bool, define safetail using

-- isEmpty
isEmpty :: [a] -> Bool
isEmpty [] = True
isEmpty xs = False

-- a conditional expression
safetailConditional :: [a] -> [a]
safetailConditional xs = if isEmpty xs then [] else tail xs

-- guarded equations
safetailGuards :: [a] -> [a]
safetailGuards xs | isEmpty xs = []
                  | otherwise = tail xs

-- pattern matching
safetailPatterns :: [a] -> [a]
safetailPatterns [] = []
safetailPatterns xs = tail xs
```

