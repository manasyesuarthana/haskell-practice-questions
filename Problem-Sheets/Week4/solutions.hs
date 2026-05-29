import Data.List

-- 1. A triple (x,y,z) of positive integers is called pythagorean if x^2 + y^2 = z^2 . Using a list comprehension, define a function:
pyths :: Int -> [(Int,Int,Int)]
pyths n = [(x,y,z) | x <- [1..n], y <- [1..n], z <- [1..n], x^2 + y^2 == z^2 ]

-- 2. A positive integer is perfect if it equals the sum of all of its
-- factors, excluding the number itself. Using a list comprehension,
-- define a function that returns the list of all perfect numbers up to a given limit. For example:
-- perfects 500 = [6,28,496]

perfects :: Int -> [Int]
perfects n | n <= 0 = []
           | otherwise = [x | x <- [1..n], x == sum (positiveFactors x)]

positiveFactors :: Eq Int => Int -> [Int]
positiveFactors n | n <= 0 = []
                  | otherwise = [x | x <- [1..n-1], n `mod` x == 0]

{-- 
Variations of no. 2
A number which is less than the sum of its proper divisors is called abundant.
A number which is greater than the sum of its proper divisions is called deficient.
A number for which the sum of all its divisors (including itself) is greater than
the sum of the divisors of any smaller number is called highly abundant.

For each of these variations, write a function which finds all the numbers with the
stated property below a given number.
--}
abundants :: Int -> [Int]
abundants n = if n <= 0 then [] else [x | x <- [1..n], x < sum (positiveFactors x)]

deficients :: Int -> [Int]
deficients n = if n <= 0 then [] else [x | x <- [1..n], x > sum (positiveFactors x)]

-- extremely inefficient code with O(n^3) complexity, but it works :P
highlyAbundants :: Int -> [Int]
highlyAbundants n = if n <= 0 then [] else [x | x <- [1..n], all (\y -> sumFactors x > sumFactors y) [1..x-1]]

sumFactors :: Int -> Int
sumFactors n = sum [x | x <- [1..n], n `mod` x == 0]

-- 3. The scalar product of two lists of integers xs and ys of length n is give by the sum of the products of the corresponding integers:
scalarProduct :: [Int] -> [Int] -> Int
scalarProduct [] [] = 0
scalarProduct xs ys | myAnd (length xs > 0) (length ys > 0) =  sum (zipWith (*) xs ys)
                    | otherwise = undefined

myAnd :: Bool -> Bool -> Bool
myAnd True True = True
myAnd False _ = False
myAnd _ False = False

-- 4. [Harder] Implement matrix multiplication where matrices are represented by lists of lists of integers.  
matrix_mul :: [[Int]] -> [[Int]] -> [[Int]]
matrix_mul [] _ = []
matrix_mul _ [] = []
matrix_mul xss yss = 
    let cols = transpose yss
    -- multiply each row of xss with all transposed row of yss (columns) -> one row of the result matrix
    -- after that, continue to the next row of xss
    -- new technique: nested list comprehensions
    in [ [scalarProduct rows columns | columns <- cols] | rows <- xss]

-- Recursive Functions --

-- 1. Without looking at the standard prelude, define the following library functions using recursion:

-- and --
and' :: [Bool] -> Bool
and' (b:bs) = b && and bs

-- concat --
concat' ::[[a]] -> [a]
concat' [] = []
concat' (xs:xss) = xs ++ concat' xss

-- replicate --
replicate' :: Int -> a -> [a]
replicate' 0 x = []
replicate' n x = [x] ++ replicate (n-1) x

-- (!!) --
extractIndex :: [a] -> Int -> a 
extractIndex xs 0 = head xs
extractIndex (x:xs) n = extractIndex xs (n-1)

-- elem --
elem' :: Eq a => a -> [a] -> Bool
elem' e [] = False
elem' e (x:xs) | e == x = True
               | otherwise = elem e xs


-- 2. Define a recursive function that merges two sorted lists of values to give a single sorted list.
merge :: Ord a => [a] -> [a] -> [a]
merge [] [] = []
merge xs [] = xs
merge [] ys = ys
merge (x:xs) (y:ys) | min x y `elem` (x:xs) = [min x y] ++ merge xs (y:ys)
                    | min x y `elem` (y:ys) = [min x y] ++ merge (x:xs) ys

-- List comprehensions and higher-order functions --

-- 1. Express the comprehension [f x | x <- xs, p x] using the functions map and filter. The function type is given as:
fun :: Num a => (a -> a) -> (a -> Bool) -> [a] -> [a]
fun f p [] = []
fun f p xs = map f (filter p xs)

-- 2. Redefine map f and filter p using foldr and foldl. For your reference, here are the definitions of map and filter from lecture notes. HINT. 
-- Read about the foldr and foldl functions in the handout higher-order functions and Chapter 7.3 and 7.4 of Programming in Haskell.

{-- 
map :: (a -> b) -> [a] -> [b]
map f []     = []
map f (x:xs) = f x : map f xs

filter :: (a -> Bool) -> [a] -> [a]
filter p [] = []
filter p (x:xs)
   | p x       = x : filter p xs
   | otherwise = filter p xs
--}

-- i. map --
-- foldr --
mapFoldr :: (a -> b) -> [a] -> [b]
mapFoldr f xs = foldr (\x acc -> f x : acc) [] xs

-- foldl --
mapFoldl :: (a -> b) -> [a] -> [b]
mapFoldl f xs = foldl (\acc x -> acc ++ [f x]) [] xs

-- ii. filter
-- foldr --
filterFoldr :: (a -> Bool) -> [a] -> [a]
filterFoldr p xs = foldr (\x acc -> if p x then x : acc else acc) [] xs

-- foldl --
filterFoldl :: (a -> Bool) -> [a] -> [a]
filterFoldl p xs = foldl (\acc x -> if p x then acc ++ [x] else acc) [] xs

-- 3. Define a function altMap :: (a -> b) -> (a -> b) -> [a] -> [b] that alternatively applies the two argument functions to successive elements in a list.
altMap :: (a -> b) -> (a -> b) -> [a] -> [b]
altMap f g [] = []
altMap f g (x:xs) | even (length xs) = f x : altMap f g xs 
                  | otherwise = g x : altMap f g xs

-- Excercise: define reverse using foldr and foldl
reverseFoldr :: [a] -> [a]
reverseFoldr xs = foldr (\x acc -> acc ++ [x]) [] xs

reverseFoldl :: [a] -> [a]
reverseFoldl xs = foldl (\acc x -> [x] ++ acc) [] xs

-- 4. [Harder] Church Numerals
-- It is possible to represent the natural numbers (i.e. 0,1,2,...) using higher order functions of type
-- (Skipped for now)


-- Defining the prelude concat function in four different ways --

-- 1. using list comprehension --
concat1 :: [[a]] -> [a]
concat1 [] = []
concat1 xss = [x | xs <- xss, x <- xs]

-- Tested: Successful and returns True

-- 2. Using Recursion --
concat2:: [[a]] -> [a]
concat2 [] = []
concat2 (xs:xss) = xs ++ concat xss

-- Tested: Successful and returns True

-- 3. Using foldr and foldl --

-- i. foldr --
concat3 :: [[a]] -> [a]
concat3 xss = foldr (\xs acc -> xs ++ acc) [] xss

-- ii. foldl --
concat4 :: [[a]] -> [a]
concat4 xss = foldl (\acc xs -> acc ++ xs) [] xss

-- Tested: Successful and returns True