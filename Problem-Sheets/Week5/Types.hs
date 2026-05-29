module Types where

data WeekDay = Mon | Tue | Wed | Thu | Fri | Sat | Sun
			   deriving (Show, Read, Eq, Ord, Enum)


-- Type Retractions --
data WorkingDay = Monday | Tuesday | Wednesday | Thursday | Friday
                deriving (Show, Read, Eq, Ord, Enum)

-- Trees --
-- 1. Define a type of binary trees --
-- which carries an element of type a at each leaf, and an element f type b at each node
data BinLN a b = Leaf a | Node (BinLN a b) b (BinLN a b)
            deriving Show

-- 3. Implement a new version of binary trees which carries data only at the leaves.
data BinL a = Lf a | Nd (BinL a) (BinL a)
            deriving Show

data BT a = Empty | Fork a (BT a) (BT a)

-- Valid buttons are ['0'..'9']++['*','#']
type Button = Char
-- Valid presses are [1..]
type Presses = Int
-- Valid text consists of
-- ['A'..'Z']++['a'...'z']++['0'..'9']++['.',',',' ']
type Text = String

-- excluding # and *
phone2Key :: (Button, Presses) -> Char
phone2Key ('1', _) = '1'
phone2Key ('2', p) = case (p `mod` 4) of
                        0 -> '2'
                        1 -> 'a'
                        2 -> 'b'
                        3 -> 'c'

phone2Key ('3', p) = case (p `mod` 4) of
                        0 -> '3'
                        1 -> 'd'
                        2 -> 'e'
                        3 -> 'f'

phone2Key ('4', p) = case (p `mod` 4) of
                        0 -> '4'
                        1 -> 'g'
                        2 -> 'h'
                        3 -> 'i'

phone2Key ('5', p) = case (p `mod` 4) of
                        0 -> '5'
                        1 -> 'j'
                        2 -> 'k'
                        3 -> 'l'

phone2Key ('6', p) = case (p `mod` 4) of
                        0 -> '6'
                        1 -> 'm'
                        2 -> 'n'
                        3 -> 'o'

phone2Key ('7', p) = case (p `mod` 5) of
                        0 -> '7'
                        1 -> 'p'
                        2 -> 'q'
                        3 -> 'r'
                        4 -> 's'

phone2Key ('8', p) = case (p `mod` 4) of
                        0 -> '8'
                        1 -> 't'
                        2 -> 'u'
                        3 -> 'v'

phone2Key ('9', p) = case (p `mod` 5) of
                        0 -> '9'
                        1 -> 'w'
                        2 -> 'x'
                        3 -> 'y'
                        4 -> 'z'

phone2Key ('0', p) = case (p `mod` 2) of
                        0 -> '0'
                        1 -> ' '

-- excluding # and *
key2Phone :: Char -> (Button, Presses)
key2Phone '0' = ('0', 2)
key2Phone '1' = ('1', 1)
key2Phone '2' = ('2', 4)
key2Phone '3' = ('3', 4)
key2Phone '4' = ('4', 4)
key2Phone '5' = ('5', 4)
key2Phone '6' = ('6', 4)
key2Phone '7' = ('7', 5)
key2Phone '8' = ('8', 4)
key2Phone '9' = ('9', 5)
key2Phone 'a' = ('2',1)
key2Phone 'b' = ('2', 2)
key2Phone 'c' = ('2', 3)
key2Phone 'd' = ('3', 1)
key2Phone 'e' = ('3', 2)
key2Phone 'f' = ('3', 3)
key2Phone 'g' = ('4', 1)
key2Phone 'h' = ('4', 2)
key2Phone 'i' = ('4', 3)
key2Phone 'j' = ('5', 1)
key2Phone 'k' = ('5', 2)
key2Phone 'l' = ('5', 3)
key2Phone 'm' = ('6', 1)
key2Phone 'n' = ('6', 2)
key2Phone 'o' = ('6', 3)
key2Phone 'p' = ('7', 1)
key2Phone 'q' = ('7', 2)
key2Phone 'r' = ('7', 3)
key2Phone 's' = ('7', 4)
key2Phone 't' = ('8', 1)
key2Phone 'u' = ('8', 2)
key2Phone 'v' = ('8', 3)
key2Phone 'w' = ('9', 1)
key2Phone 'x' = ('9', 2)
key2Phone 'y' = ('9', 3)
key2Phone 'z' = ('9', 4)
key2Phone '.' = ('#', 1)
key2Phone ',' = ('#', 2)
key2Phone ' ' = ('0', 1)