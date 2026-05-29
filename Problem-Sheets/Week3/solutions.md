# Manasye's Solutions for the Week 3 FP Problem Sheet

```hs
{-- 
1. Run, and understand, the following examples:

A. False == 'c'
B. False == True
C. False == not
D. False == not True
E. not == id
F. [not] == [ (id :: Bool -> Bool) ]
--}

False == 'c' -- this statement tries to compare the equality of a Boolean and a Char type. This obviously does not work and haskell returns "couldn't match type" error.

False == True -- result: False. this statement compares whether the value of False and True. the statement is valid as both types are equal but since both values are not equal, the result is False.

False == not -- this statement tries to compare a Boolean type and a function type of Bool -> Bool. This obviously does not work and haskell returns "couldn't match type" error.

False == not True -- result: True. this statement is valid as it compares a Boolean and a result of putting 'True' into the function not, resulting in a boolean as well. not True is False, so False == False -> True

not == id -- the statement tries to compare two functions. 'not' is a (Bool -> Bool) type while id is (a -> a). There are no instances of equality for these functions and therefore Haskell gives an error.

[not] == [id :: Bool -> Bool)] -- this statement tries to compare the values of not within a list, and id in a list with its type specified. Both types are in fact, equal: [(Bool -> Bool)] == [(Bool -> Bool)], however, same problem as statement E, there are no instances of equality for these function types.


-- 2.Find all the basic instances of the type class Bounded that are defined in the GHC Prelude (the libraries that are loaded when starting ghci, without importing any additional libraries). Find out what minBound and maxBound are for each of the instances.

-- answer: definitely a lot of instances for a lot of types. You can find it here:  https://hackage-content.haskell.org/package/base-4.22.0.0/docs/Prelude.html#t:Bounded

-- 3. What type classes do the type classes Fractional, Floating, Integral extend? What functions do they provide? Which type class would you choose to implement a trigonometric calculus?

-- answer: 
-- Fractional extends Num
-- Integral extends Real a, Enum a
-- Floating extends Fractional
-- For trigonometric calculus, the Floating typeclass seems the most suitable as it already supports trigonometric functions such as asin, etc.

-- 4. Answer in ./number_4.hs


-- 99 Haskell Problems: the first 5 problems:

-- 1. (*) Find the last element of a list with a function name `myLast`
myLast :: [a] -> a
myLast xs = head (reverse xs)

-- 2. (*) Find the last-but-one (or second-last) element of a list with a function name `myButLast`
myButLast :: [a] -> a
myButLast xs = head (tail (reverse xs))

-- 3. (*) Find the K'th element of a list with a function name `elementAt`
elementAt :: [a] -> Int -> a
elementAt xs n = xs!!(n-1)

-- 4. (*) Find the number of elements in a list with a function name `myLength`
myLength :: [a] -> Int
myLength [] = 0
myLength (x:xs) = 1 + myLength xs

-- 5. (*) Reverse a list with a function name `myReverse`
myReverse :: [a] -> [a]
myReverse [] = []
myReverse (x:xs) = myReverse xs ++ [x]

```