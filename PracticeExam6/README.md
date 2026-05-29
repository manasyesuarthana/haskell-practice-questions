# Practice Exam 6

## Marking Table

The exercises are defined so that it is hard to get a first-class mark.

| Mark         | Cut-off            |
| ------------ | ------------------ |
| 1st          | 35 marks and above |
| upper second | 30-34 marks        |
| lower second | 25-29 marks        |
| third        | 20-24 marks        |
| fail         | 0-19 marks         |

Questions 1–5 have equal weight (10 marks each, 50 total). Question 6 is a bonus parsing question worth 10 extra marks.

## Preparation

* Do __not__ modify either the file `Types.hs` or the file `PracticeExam6-Template.hs`.
* Copy the file `PracticeExam6-Template.hs` to a new file called `PracticeExam6.hs` and write your solutions in `PracticeExam6.hs`.

  __Don't change the header of this file, including the module declaration, and, moreover, don't change the type signature of any of the given functions for you to complete.__

* Solve the exercises below in the file `PracticeExam6.hs` by replacing the default function implementation of `undefined` with your own function.

## Additional Information

* The file `Types.hs` has various definitions and functions which you are welcome to use when completing the questions.
* This is an open book test.
* Feel free to write helper functions whenever convenient.
* All the exercises may be solved without importing additional modules. Do **not** import any modules beyond what is already imported.

---

## Question 1 — Binary Search Trees (10 marks)

Consider the following binary search tree (BST) type:

```haskell
data BST a = Empty
           | Node (BST a) a (BST a)
           deriving (Show, Eq)
```

A BST maintains the invariant: for every `Node l v r`, all values in `l` are strictly less than `v`, and all values in `r` are strictly greater than `v`. Duplicate values are not inserted.

### Part (a): `insertBST` (4 marks)

Insert a value into a BST, maintaining the BST invariant. If the value already exists, leave the tree unchanged.

```haskell
insertBST :: Ord a => a -> BST a -> BST a
insertBST x t = undefined
```

### Part (b): `fromList` (3 marks)

Build a BST from a list of values by inserting each element one at a time, left to right.

```haskell
fromList :: Ord a => [a] -> BST a
fromList xs = undefined
```

**Hint**: `foldl` may be useful.

### Part (c): `toSortedList` (3 marks)

Produce a sorted list from a BST using an in-order traversal.

```haskell
toSortedList :: BST a -> [a]
toSortedList t = undefined
```

### Examples

```hs
ghci> insertBST 5 Empty
Node Empty 5 Empty

ghci> fromList [4,2,6,1,3,5,7]
Node (Node (Node Empty 1 Empty) 2 (Node Empty 3 Empty)) 4 (Node (Node Empty 5 Empty) 6 (Node Empty 7 Empty))

ghci> toSortedList (fromList [4,2,6,1,3,5,7])
[1,2,3,4,5,6,7]

ghci> toSortedList (fromList [3,1,4,1,5,9,2,6])
[1,2,3,4,5,6,9]
```

---

## Question 2 — Higher-Order Functions (10 marks)

### Part (a): `zipApply` (5 marks)

Write a function that takes a list of functions and a list of values, and applies each function to the corresponding value, like `zip` but with function application.

```haskell
zipApply :: [a -> b] -> [a] -> [b]
zipApply fs xs = undefined
```

If one list is shorter than the other, stop at the shorter one.

### Part (b): `iterateN` (5 marks)

Write a function that produces a list of `n+1` values by repeatedly applying a function, starting from a seed value.

```haskell
iterateN :: Int -> (a -> a) -> a -> [a]
iterateN n f x = undefined
```

### Examples

```hs
ghci> zipApply [(+1),(*2),(^2)] [10,20,30]
[11,40,900]

ghci> zipApply [show, show] [1,2,3]
["1","2"]

ghci> iterateN 5 (*2) 1
[1,2,4,8,16,32]

ghci> iterateN 0 (+1) 42
[42]

ghci> iterateN 4 reverse "abc"
["abc","cba","abc","cba","abc"]
```

### Hints

* `zipApply` should stop when either list runs out — pattern match on both lists simultaneously.
* `iterateN 0` should return a singleton list containing just the seed.
* `iterateN n` includes the seed and `n` applications.

---

## Question 3 — State Monad (Calculator) (10 marks)

A simple calculator has two pieces of state: a **register** (a saved integer) and an **accumulator** (a running total). The state is represented as a pair:

```haskell
type Calculator = State (Int, Int)
-- State is (register, accumulator)
```

### Part (a): `store` (3 marks)

Store a value into the register, leaving the accumulator unchanged.

```haskell
store :: Int -> Calculator ()
store n = undefined
```

### Part (b): `recall` (3 marks)

Read and return the current value of the register.

```haskell
recall :: Calculator Int
recall = undefined
```

### Part (c): `addToAcc` (2 marks)

Add a value to the accumulator, leaving the register unchanged.

```haskell
addToAcc :: Int -> Calculator ()
addToAcc n = undefined
```

### Part (d): `runProgram` (2 marks)

Run a calculator program from an initial state, returning the final state and the result.

```haskell
runProgram :: Calculator a -> (Int, Int) -> ((Int, Int), a)
runProgram prog initState = undefined
```

**Hint**: Use `runState`.

### Examples

```hs
ghci> runProgram (store 42) (0, 0)
((42,0),())

ghci> runProgram recall (10, 0)
((10,0),10)

ghci> runProgram (addToAcc 5 >> addToAcc 3) (0, 0)
((0,8),())

ghci> runProgram (do { store 7 ; addToAcc 10 ; r <- recall ; addToAcc r }) (0, 0)
((7,17),())
```

---

## Question 4 — Spiral Matrix Traversal (10 marks)

Given a matrix represented as a list of rows, return its elements in **spiral order**: traverse the first row left-to-right, then the last column top-to-bottom, then the last row right-to-left, then the first column bottom-to-top, then repeat on the inner sub-matrix.

```haskell
type Matrix a = [[a]]

spiralOrder :: Matrix a -> [a]
spiralOrder m = undefined
```

### Examples

```
For the matrix:      Spiral order:
  1  2  3            [1, 2, 3, 6, 9, 8, 7, 4, 5]
  4  5  6
  7  8  9

For the matrix:      Spiral order:
  1  2  3  4         [1, 2, 3, 4, 8, 12, 11, 10, 9, 5, 6, 7]
  5  6  7  8
  9 10 11 12
```

```hs
ghci> spiralOrder [[1,2,3],[4,5,6],[7,8,9]]
[1,2,3,6,9,8,7,4,5]

ghci> spiralOrder [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
[1,2,3,4,8,12,11,10,9,5,6,7]

ghci> spiralOrder [[1]]
[1]

ghci> spiralOrder ([] :: [[Int]])
[]
```

### Hints

* After taking the first row, the remaining rows can be **rotated** so that the next "first row" corresponds to the next layer of the spiral.
* The functions `transpose` and `reverse` (both available from `Data.List`) can rotate a matrix.
* Think about what happens when you `reverse` the list of rows from `transpose` of the remaining matrix.

---

## Question 5 — Symbolic Expressions (10 marks)

Consider the following type for mathematical expressions in a single variable `x`:

```haskell
data MathExpr = Lit Double
              | X                        -- the variable x
              | MathExpr :+: MathExpr    -- addition
              | MathExpr :*: MathExpr    -- multiplication
              | Neg MathExpr             -- negation
              deriving (Show, Eq)
```

### Part (a): `eval` (4 marks)

Evaluate an expression at a given value of `x`.

```haskell
eval :: Double -> MathExpr -> Double
eval x e = undefined
```

### Part (b): `simplify` (6 marks)

Simplify an expression using the following algebraic rules:

- `0 + e = e` and `e + 0 = e`
- `0 * e = 0` and `e * 0 = 0`
- `1 * e = e` and `e * 1 = e`
- `Neg (Lit 0) = Lit 0`
- Constant folding: `Lit a :+: Lit b = Lit (a+b)` and `Lit a :*: Lit b = Lit (a*b)`

Simplification should be applied recursively to sub-expressions first.

```haskell
simplify :: MathExpr -> MathExpr
simplify e = undefined
```

### Examples

```hs
ghci> eval 3.0 (X :+: Lit 1.0)
4.0

ghci> eval 2.0 (X :*: X :+: Lit 3.0 :*: X)
10.0

ghci> simplify (X :+: Lit 0)
X

ghci> simplify (Lit 0 :*: X)
Lit 0.0

ghci> simplify (Lit 1 :*: X)
X

ghci> simplify (Lit 2 :+: Lit 3)
Lit 5.0

ghci> simplify (X :*: Lit 1 :+: Lit 0)
X :*: Lit 1
```

### Hints

* For `eval`, pattern match on each constructor and recurse.
* For `simplify`, first recursively simplify sub-expressions, then check for the algebraic identities using `case` on the simplified results.

---

## Question 6 (EXTRA) — Parsing a List of Integers (10 marks)

The file `Types.hs` provides a complete monadic parser library. Using it, write a parser `parseList` that parses a comma-separated list of integers enclosed in square brackets.

```haskell
parseList :: Parser [Int]
parseList = undefined
```

The parser should handle:
- Empty lists: `"[]"` → `[]`
- Single-element lists: `"[42]"` → `[42]`
- Multi-element lists: `"[1,2,3]"` → `[1,2,3]`
- Negative numbers: `"[-1,2,-3]"` → `[-1,2,-3]`

### Examples

```hs
ghci> parse parseList "[1,2,3]"
[([1,2,3],"")]

ghci> parse parseList "[42]"
[([42],"")]

ghci> parse parseList "[]"
[([],"")] 

ghci> parse parseList "[-1,2,-3]"
[([-1,2,-3],"")]
```

### Hints

* Use `char '[' ... char ']'` to consume the brackets.
* Use the provided `integer :: Parser Int` to parse a (possibly negative) integer.
* For multiple items, parse the first integer, then use `many` to parse zero or more `, integer` pairs.
* Use `<|>` to handle the empty-list case (when there are no items between the brackets).
