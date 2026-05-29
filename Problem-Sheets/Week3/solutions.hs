
-- 2.Find all the basic instances of the type class Bounded that are defined in the GHC Prelude (the libraries that are loaded when starting ghci, without importing any additional libraries). Find out what minBound and maxBound are for each of the instances.

-- answer: definitely a lot of instances for a lot of types. You can find it here:  https://hackage-content.haskell.org/package/base-4.22.0.0/docs/Prelude.html#t:Bounded

-- 3. What type classes do the type classes Fractional, Floating, Integral extend? What functions do they provide? Which type class would you choose to implement a trigonometric calculus?

-- answer: 
-- Fractional extends Num
-- Integral extends Real a, Enum a
-- Floating extends Fractional
-- For trigonometric calculus, the Floating typeclass seems the most suitable as it already supports trigonometric functions such as asin, etc.

-- 4. Answer in ./number_4.hs


-- 99 Haskell Problems: the first 5 problems of each category:

-- (I. LISTS) --
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

-- 6. (*) Find out whether a list is a palindrome with a function name isPalindrome
isPalindrome :: Eq a => [a] -> Bool
isPalindrome xs | length xs `mod` 2 == 0 = False
                | otherwise = xs == reverse xs

-- 7. (**) Flatten a nested list structure.
-- Transform a list, possibly holding lists as elements into a `flat' list by replacing each list with its elements (recursively).
data NestedList a = Elem a | List [NestedList a]

flatten :: NestedList a -> [a]
flatten (Elem a) = [a]
flatten (List ls) = concatMap flatten ls

-- 8. (**) Eliminate consecutive duplicates of list elements.







