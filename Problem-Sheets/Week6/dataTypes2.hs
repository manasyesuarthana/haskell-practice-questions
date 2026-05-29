import Types

-- this is the isBST function provided by the lecture notes
-- specifically from User Defined data types 2

isBST :: Ord a => BT a -> Bool
isBST (Empty) = True
-- in a BST, a parent node is always bigger than its left child, but smaller than its right child
-- we will recursively check this on the left and right subtrees as well
isBST (Fork x l r) = allSmaller x r && allBigger x l && isBST l && isBST r

allSmaller :: Ord a => a -> BT a -> Bool
allSmaller x Empty = True
allSmaller x (Fork y l r) = x < y && allSmaller x l && allSmaller x r

allBigger :: Ord a => a -> BT a -> Bool
allBigger x Empty = True
allBigger x (Fork y l r) = x > y && allBigger x l && allBigger x r

-- the implementation above is not efficient as it runs in quadratic time O(n^2)
-- a better way to check whether a tree is a BST is to use in order traversal and check whether the elements are sorted.

treeInOrder :: BT a -> [a]
treeInOrder (Empty) = []
treeInOrder (Fork x l r) = treeInOrder l ++ [x] ++ treeInOrder r

isBSTLinear :: Ord a => BT a -> Bool
isBSTLinear (Empty) = True
isBSTLinear t = isSorted (treeInOrder t)

isSorted :: Ord a => [a] -> Bool
isSorted [] = True
isSorted (x:[]) = True
isSorted (x:y:zs) = x < y && isSorted (y:zs)

-- this is a linear approach as it checks whether the elements are sorted one by one from the inorder traversal.

-- another linear approach that does not use inorder traversal. We use minBound and maxBounds instead.
-- left subtree: if the current node is smaller than than the minimum limit or larger than the max limit, return False
    -- minimum limit: minBound, maximum limit: root node
-- right subtree: if the current node is larger than the maximum limit or smaller than the minimum limit, return False
    
    -- minimum limit: root node, maximum limit: maxBound
isBST' :: (Bounded a , Ord a) => BT a -> Bool
isBST' (Empty) = True
isBST' (Fork x l r) = isWithinLimit minBound x l && isWithinLimit x maxBound r where

    isWithinLimit :: Ord a => a -> a -> BT a -> Bool 
    isWithinLimit _ _ (Empty) = True
    isWithinLimit min max (Fork x l r) = min < x && x < max && isWithinLimit min x l && isWithinLimit x max r

-- trying to search an instance of an element in a binary tree
occurs :: Ord a => a -> BT a -> Bool
occurs x (Empty) = False
occurs x (Fork y l r) = x == y || x > y  && occurs x r || x < y && occurs x l

-- inserting an element to a BST 
-- in this case, we will recursively run the insert function on the right or left subtree depending on whether x > y or x < y.
insert :: Ord a => a -> BT a -> BT a 
insert x (Empty) = Fork x Empty Empty 
insert x (Fork y l r) | x > y = Fork y l (insert x r) -- we recursively try to insert x on the right subtree
                      | x < y = Fork y (insert x l) r -- we recursively try to insert x on the left subtree
                      | otherwise = Fork y l r -- in this case, x already exists, so we return the tree as if it were not changed.

-- we can also use the Maybe or Nothing type to indicate whether the element is inserted or not.
-- Nothing means the element already exists.
-- it follows the same principle of the previous version, except it tests for whether there is an output first from the recusive inserts.
-- if there is, it returns the new tree with the new subtree containing the inserted node. If not, that means the element already exists.
insert' :: Ord a => a -> BT a -> Maybe (BT a) 
insert' x (Empty) = Nothing 
insert' x (Fork y l r) | x > y = case (insert' x r) of 
                                    Nothing -> Just (Fork y l r)
                                    Just r' -> Just (Fork y l r')

                       | x > y = case (insert' x l) of
                                    Nothing -> Just (Fork y l r)
                                    Just l' -> Just (Fork y l' r)
                       | otherwise = Nothing


-- deletion in a BST
delete :: Ord a => a -> BT a -> BT a
delete x (Empty) = Empty -- deleting from an empty tree, results in.. well.. an empty tree.
delete x (Fork y l r) | x > y = Fork y (delete x l) r -- element smaller than current node, recursively try to delete left subtree
                      | x < y = Fork y l (delete x r) -- element larger than current node, recursively try to delete right subtree
                      | (x == y) && l == Empty = r -- element is current node, and left is empty, delete current node and return the right subtree
                      | (x == y) && r == Empty = l -- element is current node, and right is empty, delete current node and return the left subtree
                      | otherwise = Fork (largestOf l) (withoutLargest l) r -- if all of those don't satisfy, the element to be deleted is the largest one (?)

-- get the largest node of the current tree
largestOf :: BT a -> a
largestOf (Empty) = undefined 
largestOf (Fork x l Empty) = x
largestOf (Fork x l r) = largestOf r 

-- get the tree WITHOUT the largest node
withoutLargest :: BT a -> BT a
withoutLargest (Empty) = undefined 
withoutLargest (Fork x l Empty) = l 
withoutLargest (Fork x l r) = Fork x l (withoutLargest r)

-- deletion in a BST with the Maybe type for more safe operations
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

                        
-- largestOf and withoutLargest with Maybe type while also combining both functions into one

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


-- Rose trees. Rose trees are a type of tree that contain any amount of branches for a single node. 
-- Every single node can have a list of nodes as its children (defined in Types.hs)

-- calculate the size of a rose tree (number of data in the rose tree)
rsize :: Rose a -> Int
rsize (Branch _ children) = 1 + sum [rsize child | child <- children]

-- in this case the 'Branching' part does not count as an element.
-- Only the data counts
rsize' :: RoseTree a -> Int
rsize' (Data _) = 1
rsize' (Branching cs) = sum [rsize' c | c <- cs]

-- calculate the height of a rose
rheight :: Rose a -> Int
rheight (Branch _ []) = 0
rheight (Branch _ children) = 1 + maximum [rheight child | child <- children]

rheight' :: RoseTree a -> Int
rheight' (Data _) = 1
rheight' (Branching []) = 0
rheight' (Branching cs) = 1 + maximum (0 : [rheight' c | c <- cs])


-- Game Trees
-- these type of trees basically store a state of a game, where each node represents a possible move taken and the resulting state of the game.
-- this function turns a list of moves and the board states to a GameTree
-- the function will build the tree recursively with this function. 

gameTree :: (board -> [(move, board)]) -> board -> GameTree board move
gameTree plays board = Node board [(m, gameTree plays b) | (m, b) <- plays board]

nimPlays :: NimBoard -> [(NimMove,NimBoard)]
nimPlays heaps = [(Remove i k, (hs ++ h-k : hs'))
                 | i <- [0..length heaps-1],
                   let (hs, h:hs') = splitAt i heaps,
                   k <- [1..h]]

nim :: [Integer] -> GameTree NimBoard NimMove
nim heaps = (gameTree nimPlays) heaps

-- Permutation Trees
-- A tree to represent all the possible ways to arrange a list of items
-- One path represents one possibility

fullPaths :: PTree a -> [[a]]
fullPaths (EBranch []) = [[]]
fullPaths (EBranch children) = [] : [x:p | (x,t) <- children, p <- fullPaths t]

permTree :: Eq a => [a] -> PTree a 
permTree [] = EBranch []
permTree xs = EBranch [(x, permTree (xs \\\ x)) | x <- xs]
        where
            (\\\) :: Eq a => [a] -> a -> [a]
            [] \\\ _ = undefined
            (x:xs) \\\ y | x == y = xs
                         | otherwise = x : (xs \\\ y)

permutations :: Eq a => [a] -> [[a]]
permutations xs = fullPaths (permTree xs)

factorial :: Integer -> Integer
factorial 0 = 1
factorial x = x * factorial (x - 1)

