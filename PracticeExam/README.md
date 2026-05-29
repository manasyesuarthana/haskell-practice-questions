# Practice Exam

## Marking table

The exercises are defined so that it is hard to get a first-class mark.

| Mark         | Cut-off            |
| ------------ | ------------------ |
| 1st          | 35 marks and above |
| upper second | 30-34 marks        |
| lower second | 25-29 marks        |
| third        | 20-24 marks        |
| fail         | 0-19 marks         |

All questions have equal weight, with ten marks each, with a total of 50 marks.

## Preparation

* Copy the file `PracticeExam-Template.hs` to a new file called `PracticeExam.hs` and write your solutions in `PracticeExam.hs`.

  __Don't change the header of this file, including the module declaration, and, moreover, don't change the type signature of any of the given functions for you to complete.__

* Solve the exercises below in the file `PracticeExam.hs` by replacing the default function implementation of `undefined` with your own function.

## Additional Information

* The file `PracticeTypes.hs` has various definitions and functions which you are welcome to use when completing the questions.  
* This is an open book test.
* You may consult your own notes, the course materials, the official book or [Hoogle](https://hoogle.haskell.org/).
* Feel free to write helper functions whenever convenient.
* All the exercises may be solved without importing additional modules. Do **not** import any modules, as it will interfere with the marking.

---

## Question 1 (10 marks)

Consider the following type of binary trees where values are stored at the nodes (forks) and leaves are empty.

```haskell
data BT a = Empty
           | Fork a (BT a) (BT a)
           deriving (Show, Eq)
```

**Task 1a**: Write a function `mirror :: BT a -> BT a` which produces the mirror image of a binary tree, i.e. swaps the left and right subtrees at every node, recursively.

```haskell
mirror :: BT a -> BT a
mirror t = undefined
```

**Examples**:
```hs
ghci> mirror Empty
Empty
ghci> mirror (Fork 1 (Fork 2 Empty Empty) (Fork 3 Empty Empty))
Fork 1 (Fork 3 Empty Empty) (Fork 2 Empty Empty)
ghci> mirror (Fork 'a' (Fork 'b' (Fork 'c' Empty Empty) Empty) Empty)
Fork 'a' Empty (Fork 'b' Empty (Fork 'c' Empty Empty))
```

**Task 1b**: Write a function `collectAtDepth :: Int -> BT a -> [a]` which collects all node values at a given depth in the tree. The root is at depth 0.

```haskell
collectAtDepth :: Int -> BT a -> [a]
collectAtDepth n t = undefined
```

**Examples**:
```hs
ghci> collectAtDepth 0 (Fork 1 (Fork 2 Empty Empty) (Fork 3 Empty Empty))
[1]
ghci> collectAtDepth 1 (Fork 1 (Fork 2 Empty Empty) (Fork 3 Empty Empty))
[2,3]
ghci> collectAtDepth 2 (Fork 1 (Fork 2 Empty Empty) (Fork 3 Empty Empty))
[]
ghci> collectAtDepth 1 Empty
[]
```

---

## Question 2 (10 marks)

Recall that the higher-order function `foldr` has the type:

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b
```

and can be thought of as replacing each `(:)` in a list with a given function, and `[]` with a given value.

**Task 2a**: Using `foldr`, implement a function `encode :: String -> [Int]` which converts each character in a string to its ASCII value using `Data.Char.ord`.

```haskell
encode :: String -> [Int]
encode = undefined
```

**Examples**:
```hs
ghci> encode "abc"
[97,98,99]
ghci> encode ""
[]
ghci> encode "A"
[65]
```

**Task 2b**: Using `foldr`, implement a function `filterMap :: (a -> Maybe b) -> [a] -> [b]` which simultaneously filters and maps over a list. For each element, if the function returns `Just y`, then `y` is included in the output; if it returns `Nothing`, the element is discarded.

```haskell
filterMap :: (a -> Maybe b) -> [a] -> [b]
filterMap f = undefined
```

**Examples**:
```hs
ghci> filterMap (\x -> if even x then Just (x `div` 2) else Nothing) [1..10]
[1,2,3,4,5]
ghci> filterMap (\c -> if c >= 'a' && c <= 'z' then Just c else Nothing) "Hello World"
"elloorld"
ghci> filterMap (\_ -> Nothing) [1,2,3]
[]
```

---

## Question 3 (10 marks)

A vending machine has a stock of items and an amount of money inserted.
We model the machine's state and operations inside the `State` monad.

```haskell
type Stock = [(String, Int)]   -- list of (itemName, quantity) pairs
type VendingState = (Int, Stock) -- (money inserted in pence, stock)
type Vending a = State VendingState a
```

**Task 3a**: Write a function `insertMoney :: Int -> Vending ()` which adds the given number of pence to the amount of money currently inserted.

```haskell
insertMoney :: Int -> Vending ()
insertMoney amount = undefined
```

**Task 3b**: Write a function `buyItem :: String -> Int -> Vending Bool` which attempts to purchase the named item at the given price (in pence). The purchase succeeds (returns `True`) if:
1. There is enough money inserted (≥ the price), **and**
2. The item is in stock (quantity > 0).

If successful, the money inserted is decreased by the price and the item's quantity is decreased by 1. If unsuccessful, the state is unchanged and the function returns `False`.

```haskell
buyItem :: String -> Int -> Vending Bool
buyItem name price = undefined
```

For example, given the interaction sequence:

```haskell
vendingExample :: Vending (Bool, Bool)
vendingExample = do insertMoney 100
                    insertMoney 50
                    b1 <- buyItem "Coke" 120
                    b2 <- buyItem "Coke" 120
                    return (b1, b2)
```

we have:

```
ghci> runState vendingExample (0, [("Coke", 2), ("Water", 3)])
((True,False),(30,[("Coke",1),("Water",3)]))
```

The first purchase succeeds (150 pence inserted, Coke costs 120, leaving 30 pence and 1 Coke remaining). The second purchase fails because only 30 pence remain, which is not enough for 120.

```
ghci> runState vendingExample (0, [("Water", 3)])
((False,False),(150,[("Water",3)]))
```

Here both fail because "Coke" is not in the stock list at all.

---

## Question 4 (10 marks)

A [Latin square](https://en.wikipedia.org/wiki/Latin_square) is an n × n grid filled with n different values, such that each value occurs exactly once in each row and exactly once in each column.

For example, the following is a Latin square of order 3:

|   |   |   |
|---|---|---|
| 1 | 2 | 3 |
| 2 | 3 | 1 |
| 3 | 1 | 2 |

**Task**: Write a function

```haskell
isLatinSquare :: Eq a => [[a]] -> Bool
isLatinSquare = undefined
```

which takes a list of lists (representing a square grid) and returns:

1. `True` if the input represents a valid Latin square,
2. `False` otherwise.

Specifically, your function should check that:
- Every row is a permutation of the first row (i.e. contains exactly the same elements, each appearing exactly once).
- Every column is a permutation of the first row.

You may assume that the input is always a well-formed n × n grid for some positive integer n. You will not be tested on the empty list.

**Hint**: You may find `Data.List.sort` or `Data.List.nub` useful, or you can write your own helper to check if two lists are permutations of each other.

### Examples

```hs
ghci> isLatinSquare [[1,2,3],[2,3,1],[3,1,2]]
True
ghci> isLatinSquare [[1,2,3],[1,2,3],[1,2,3]]
False
ghci> isLatinSquare [['a','b'],['b','a']]
True
ghci> isLatinSquare [[1,2],[2,2]]
False
```

---

## Question 5 (10 marks)

We can represent simple arithmetic expressions with variables using the following datatype:

```haskell
data AExpr = Lit Int
           | Var Char
           | Add AExpr AExpr
           | Mul AExpr AExpr
           | Neg AExpr
           deriving (Eq, Show)
```

Some examples:
  - The number `5` would be represented as `Lit 5`.
  - The variable `x` would be represented as `Var 'x'`.
  - The expression `x + 5` would be represented as `Add (Var 'x') (Lit 5)`.
  - The expression `-(x * y)` would be represented as `Neg (Mul (Var 'x') (Var 'y'))`.

We define an **evaluation function** that takes an environment (a mapping from variable names to integer values) and evaluates an expression:

```haskell
type Env = [(Char, Int)]

evalAExpr :: Env -> AExpr -> Maybe Int
```

**Task 5a**: Implement `evalAExpr` which evaluates an expression under the given environment. If a variable is not found in the environment, return `Nothing`. Use the `Maybe` monad to propagate failures.

```haskell
evalAExpr :: Env -> AExpr -> Maybe Int
evalAExpr env expr = undefined
```

**Examples**:
```hs
ghci> evalAExpr [('x', 3), ('y', 4)] (Add (Var 'x') (Var 'y'))
Just 7
ghci> evalAExpr [('x', 3)] (Mul (Var 'x') (Lit 2))
Just 6
ghci> evalAExpr [('x', 3)] (Add (Var 'x') (Var 'y'))
Nothing
ghci> evalAExpr [] (Neg (Lit 5))
Just (-5)
```

**Task 5b**: Write a function `collectVars :: AExpr -> [Char]` which returns the list of all variable names occurring in the expression, **without duplicates**, in the order of their first appearance (left to right, depth-first).

```haskell
collectVars :: AExpr -> [Char]
collectVars expr = undefined
```

**Examples**:
```hs
ghci> collectVars (Add (Var 'x') (Mul (Var 'y') (Var 'x')))
"xy"
ghci> collectVars (Lit 5)
""
ghci> collectVars (Neg (Add (Var 'a') (Var 'b')))
"ab"
```
