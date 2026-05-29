module Types where

data Rose a = Branch a [Rose a]
        deriving Show

-- another common definition of rose trees:
data RoseTree a = Data a | Branching [RoseTree a]
        deriving Show

type Direction = Int
type Address = [Direction]

-- data Tree a b = Leaf b | Fork (Tree a b) a (Tree a b)
--   deriving (Eq, Show)

-- data BinTree a = Empty | Node (BinTree a) a (BinTree a)
--   deriving (Eq, Show)

data Dir = GoLeft | GoRight
  deriving (Eq, Show, Bounded, Enum)

type Route = [Dir]

-- For BST questions, comment when done
data BT a = Empty | Fork a (BT a) (BT a)
              deriving (Eq, Show)

-- game trees
data GameTree board move = Node board [(move, GameTree board move)] deriving (Eq, Show)

type NimBoard = [Integer]
data NimMove = Remove Int Integer deriving (Eq, Show)

data PTree a = EBranch [(a, PTree a)] deriving (Eq, Show)

