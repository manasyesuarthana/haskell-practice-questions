import Types

-- Binary Trees --

-- 1. Puzzle from the problem sheet: write a isBST that is linear without inorder traversal
-- we can approach this problem by using upper and lower limits. in haskell, this is available through minBound and maxBound
-- if the current node is empty, we return True.
-- left subtree: if the current node is lower than or equal to the lower limit, return False
        -- lower limit: minBound, upper limit: root node
-- right subtree: if the current node is greater than or equal to the upper limit, return False
        -- lower limit: root node, upper limit: maxBound
-- P.S. this was derived from the solution based on my own understanding 
isBST' :: (Bounded a, Ord a) => BT a -> Bool
isBST' (Empty) = True
isBST' (Fork x l r) = withinLimit minBound x l && withinLimit x maxBound r where
    
    withinLimit :: Ord a => a -> a -> BT a -> Bool
    withinLimit _ _ (Empty) = True
    withinLimit minL maxL (Fork x l r) = minL < x && x < maxL && withinLimit minL x l && withinLimit x maxL r

-- 2. Can you write a function delete' with a Maybe return type to indicate that there is nothing to delete?
delete' :: Ord a => a -> BT a -> Maybe (BT a)
delete' x (Empty) = Nothing
delete' x (Fork y l r) | x > y = case (delete' x r) of
                                    Nothing -> Just (Fork y l r)
                                    Just r' -> Just (Fork y l r')
                       | x < y = case (delete' x l) of
                                    Nothing -> Just (Fork y l r)
                                    Just l' -> Just (Fork y l' r)
                       | (x == y) && l == Empty = Just r
                       | (x == y) && r == Empty = Just l 
                       | otherwise = Just (Fork (largestOfLeft) (withoutLargestLeft) r) where (largestOfLeft, withoutLargestLeft) = fromJust (largestAndWithoutLargest l)

largestOf :: BT a -> a
largestOf (Empty) = undefined 
largestOf (Fork x l Empty) = x
largestOf (Fork x l r) = largestOf r 

-- get the tree WITHOUT the largest node
withoutLargest :: BT a -> BT a
withoutLargest (Empty) = undefined 
withoutLargest (Fork x l Empty) = l 
withoutLargest (Fork x l r) = Fork x l (withoutLargest r)

-- 3. Can you combine the last two functions largestOf and withoutLargest into a single one, using a pair type as the result, 
-- so as to get a more efficient version of the delete function? And then this together with Maybe rather than using undefined?

fromJust :: Maybe a -> a 
fromJust (Nothing) = undefined
fromJust (Just x) = x

largestOf' :: BT a -> Maybe a
largestOf' (Empty) = Nothing
largestOf' (Fork x l Empty) = Just x
largestOf' (Fork x l r) = largestOf' r

withoutLargest' :: BT a -> Maybe (BT a)
withoutLargest' (Empty) = Nothing
withoutLargest' (Fork x l Empty) = Just l 
withoutLargest' (Fork x l r) = Just (Fork x l (fromJust (withoutLargest' r)))

largestAndWithoutLargest :: Ord a => BT a -> Maybe (a, BT a)
largestAndWithoutLargest (Empty) = Nothing
largestAndWithoutLargest t = Just (largest, withoutLargestT) where
        largest = fromJust (largestOf' t)
        withoutLargestT = fromJust (withoutLargest' t)

-- Rose Trees --
-- 1. Write a function validAddresses :: Rose a -> [Address] which returns all the valid addresses in a given tree.
-- example valid addresses [[], [0], [0,0], [0,1], [0,2], [1], [1,0], ... [n,n]]
validAddresses :: Rose a -> [Address]
validAddresses (Branch _ children) = [] : [i : path | (i, child) <- zip [0..] children, path <- validAddresses child]

-- 2. Write a function getAtAddress :: Rose a -> Address -> Maybe a which returns the value found at the node specified by the given address provided that it is valid.
getAtAddress :: Rose a -> Address -> Maybe a 
getAtAddress (Branch x _) [] = Just x
getAtAddress (Branch _ []) xs = Nothing
getAtAddress (Branch x (children)) (d:ds) | d >= 0 && d < length children = getAtAddress (children!!d) ds
                                          | otherwise = Nothing

-- -- 3. from the mock exam: write a function to ensure that each node has the same amount of children
sameNChildren :: Rose a -> Bool
sameNChildren (Branch _ children)= allNodesHave n (Branch undefined children)
            where
                n = length children
                allNodesHave target (Branch _ cs) =
                    length cs == target && all (allNodesHave target) cs

-- calculate

-- Applying functions to trees --

{--
Exercise 1 - Applying Functions to Trees
Your task is to write a higher-order function applyfuns that takes
two functions f :: a -> b and g :: b -> d, as well as an element
of type Tree a b as input and applies the first function to the
values found at the forks, and the second function to the values found
at the leaves.  That is, implement the function:
--}

str2int :: String -> Int
str2int xs = length xs

int2bool :: Int -> Bool
int2bool n = n /= 0

applyfuns :: (a -> c) -> (b -> d) -> Tree a b -> Tree c d
applyfuns f g (Leaf x) = Leaf (g x)
applyfuns f g (Fork l x r) = (Fork (applyfuns f g l) (f x) (applyfuns f g r))

{--
Your task is to implement the function

updateNodes :: Route -> (a -> a) -> BinTree a -> BinTree a
updateNodes = undefined

NB:

If you run out of directions before hitting a leaf, e.g. if running
updateNodes on the route [GoRight] in the tree above, then you
stop and do not modify the remainder of the tree (the values 'd'
and 'e' in the example).
If the route is too long, e.g. if running updateNodes on the
route [GoLeft,GoLeft] in the tree above, then you discard the
remainder of the route (so in the example, you would only update the
values 'a' and 'b' and then stop).
--}

updateNodes :: Route -> (a -> a) -> BinTree a -> BinTree a
updateNodes _ _ Empty = Empty
updateNodes [] f (Node left x right) = (Node left (f x) right)
updateNodes (r:rs) f (Node left x right)
                                | r == GoLeft = Node (updateNodes rs f left) (f x) (right)
                                | otherwise = Node left (f x) (updateNodes rs f right)
