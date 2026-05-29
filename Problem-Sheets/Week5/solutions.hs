import Types
import Data.Char

-- Exercise 1a. --
-- Write a function
-- that takes a list of buttons and the number of times to press them and gives back the corresponding text, e.g.
-- e.g. phoneToString [('*',1),('6',5),('5',4)] = "M5"

phoneToString :: [(Button, Presses)] -> Text
phoneToString [] = []
-- cs stands for combinations. each combination consist of (b, p) button and presses
phoneToString cs = processPhone cs False
    

processPhone :: [(Button, Presses)] -> Bool -> Text
processPhone [] _ = []
processPhone (c:cs) caps = 
    case c of
    ('*', p) | p `mod` 2 /= 0 -> processPhone cs True -- capitalize next letter
             | otherwise -> processPhone cs False
            
    ('#', p) | p `mod` 2 == 0 -> '.' : processPhone cs False
             | otherwise -> ',' : processPhone cs False

    _ | caps -> toUpper (phone2Key c) :  processPhone cs False
              | otherwise -> phone2Key c : processPhone cs False

-- Excercise 1b. --
-- Write a function
-- taking a string to a list of buttons and the number of times that they need to be pressed, e.g.
-- stringToPhone "Hi, students." = [('*',1),('4',2),('4',3),('#',2),('0',1),('7',4),('8',1),('8',2),('3',1),('3',2),('6',2),('8',1),('7',4),('#',1)]

stringToPhone :: Text -> [(Button, Presses)]
stringToPhone [] = []
-- consist of characters c of a list of chracters cs
stringToPhone (c:cs) | isUpper c = [('*', 1)] ++ [key2Phone (toLower c)] ++ stringToPhone cs
                     | otherwise = key2Phone c : stringToPhone cs


-- Excercise 1c. --
-- Write a function
-- that computes the minimal number of button presses needed to input the given string, e.g.
-- fingerTaps "Hi, students." = 27

fingerTaps :: Text -> Presses
fingerTaps text = countPresses (stringToPhone text)

countPresses :: [(Button, Presses)] -> Presses
countPresses [] = 0
countPresses ((b, p):cs) = p + countPresses cs
        
-- Using Maybe Types --
-- 1. Rewrite the head and tail functions from the prelude so that
-- they use the Maybe type constructor to indicate when provided
--  the argument was empty.

headMaybe :: [a] -> Maybe a
headMaybe [] = Nothing
headMaybe (x:xs) = Just x

tailMaybe :: [a] -> Maybe [a]
tailMaybe [] = Nothing
tailMaybe (x:xs) = Just xs

-- 2. Similarly, rewrite take :: Int -> [a] -> [a] to use Maybe to indicate
-- when the index is longer than the list.
takeMaybe :: Int -> [a] -> Maybe [a]
takeMaybe n xs | n > length xs || n < length xs = Nothing
               | otherwise = Just (take n xs)

-- 3. A common use of the Either type constructor is to return information
-- about a possible error condition.  Rewrite the function zip from the
-- prelude as
zipEither :: [a] -> [b] -> Either String [(a,b)]
zipEither [] [] = Right []
zipEither [] (_:_) = Left "First list is empty or too small."
zipEither (_:_) [] = Left "Second list is empty or too small."
zipEither (x:xs) (y:ys) = case zipEither xs ys of
                            Left message -> Left  message
                            Right rest -> Right ((x,y):rest)

-- Type Retractions --
-- 1. create a function that shows isomorphism between WeekDay and WorkingDay
toWeekDay :: WorkingDay -> WeekDay
toWeekDay Monday = Mon
toWeekDay Tuesday = Tue
toWeekDay Wednesday = Wed
toWeekDay Thursday = Thu
toWeekDay Friday = Fri

toWorkingDay :: WeekDay -> WorkingDay
toWorkingDay Mon = Monday
toWorkingDay Tue = Tuesday
toWorkingDay Wed = Wednesday
toWorkingDay Thu = Thursday
toWorkingDay Fri = Friday
toWorkingDay Sat = Friday
toWorkingDay Sun = Monday

-- 2. Show that the type Maybe a is a retract of the type [a].
-- You are expected to write the following two functions:

toList :: Maybe a -> [a]
toList Nothing = []
toList (Just x) = [x]

toMaybe :: [a] -> Maybe a 
toMaybe [] = Nothing
toMaybe [x] = Just x

-- Trees --
-- 1. Data type defined in Types.hs --

-- 2. Using the datatype from the previous problem, write a function
-- which collects the list of elements decorating the leaves of the given tree.
leaves :: BinLN a b -> [a]
leaves (Leaf a) = [a]
leaves (Node l _ r) = leaves l ++ leaves r

-- excercise: create a function that shows the tree
showBinLN :: Show a => Show b => BinLN a b -> String
showBinLN (Leaf a) = "(" ++ show a ++ ")"
showBinLN (Node l d r) = "(" ++ showBinLN l ++ show d ++ showBinLN r ++ ")"

-- 3. Implement a new version of binary trees which carries data only at the leaves.
-- defined in Types.hs

-- 4. Using the datatype from the previous examples, and supposing the type a has an instance of Show, implement a function which renders the tree
-- as a collection of parentheses enclosing the elements at the leaves.
showBin :: Show a => BinL a -> String
showBin (Lf x) = "(" ++ show x ++ ")"
showBin (Nd l r) = "(" ++ showBin l  ++ showBin r ++ ")"

-- 5. Skipped for now. A bit too difficult for now apparently.

-- 6. Define the right grafting operation
(//) :: BT a -> BT a -> BT a 
(//) Empty t = t 
(//) (Fork x l r) t = Fork x l (r // t)

-- 7. Define the left grafting operation
(\\) :: BT a -> BT a -> BT a
(\\) Empty t = t
(\\) (Fork x l r) t = Fork x (l \\ t) r 

-- 8. Given a binary tree, let us label the leaves from left to right starting at 0.  Each node then determines a pair of integers (i,j) where i is the index of its left-most leaf and j is the index of its rightmost leaf. 
leafIndices :: BT a -> BT (Int, Int)
leafIndices t = case (leafIndicesAcc 0 t) of
    (labelledTree, _) -> labelledTree

-- taken from the solution provided in the gitlab repositoryu.
-- the solution uses a counter, which is the 'Int' next to (BT (Int, Int), COUNTER)
-- im assuming this is a helper function that will be used within the main function
leafIndicesAcc :: Int -> BT a -> (BT (Int, Int), Int)
leafIndicesAcc i Empty = (Empty, i + 1) -- base case: hits a leaf, we increment the counter by 1
leafIndicesAcc i (Fork _ l r) =  
    let (l', i') = leafIndicesAcc i l -- we process the left subtree with its own counter i', returns labelled left sub tree
        (r', i'') = leafIndicesAcc i' r -- we process the right subtree with its own counter i'' , returns labelled right sub tree
    in (Fork (i, i'' - 1) l' r', i'') -- combine the labelled tree into a final tree
    -- i is the index of the left most leaf
    -- i'' - 1 is the index of the right most leaf.
