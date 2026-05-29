# Practice Exam 3

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

* Copy the file `PracticeExam3-Template.hs` to a new file called `PracticeExam3.hs` and write your solutions in `PracticeExam3.hs`.

  __Don't change the header of this file, including the module declaration, and, moreover, don't change the type signature of any of the given functions for you to complete.__

* Solve the exercises below in the file `PracticeExam3.hs` by replacing the default function implementation of `undefined` with your own function.

## Additional Information

* The file `Exam3Types.hs` has various definitions and functions which you are welcome to use when completing the questions.
* This is an open book test.
* You may consult your own notes, the course materials, the official book or [Hoogle](https://hoogle.haskell.org/).
* Feel free to write helper functions whenever convenient.
* All the exercises may be solved without importing additional modules. Do **not** import any modules, as it will interfere with the marking.

---

## Question 1 (10 marks)

A **general tree** (also called a multi-way tree or rose tree) is a tree in which
each node carries a value and has zero or more children. A node with an empty
list of children is considered a leaf.

```haskell
data GTree a = GNode a [GTree a]
  deriving (Show, Eq)
```

For example:

```
         1
       / | \
      2  3  4
     / \     \
    5   6     7
               \
                8
```

is represented as:

```haskell
gtreeExample1 = GNode 1 [ GNode 2 [ GNode 5 []
                                   , GNode 6 [] ]
                         , GNode 3 []
                         , GNode 4 [ GNode 7 [ GNode 8 [] ] ] ]
```

**Task 1a**: Write a function `depthOf :: Eq a => a -> GTree a -> Maybe Int` which
returns the depth of the **first occurrence** (searched left-to-right, depth-first)
of a given value in the tree, or `Nothing` if the value does not appear. The root
has depth 0.

```haskell
depthOf :: Eq a => a -> GTree a -> Maybe Int
depthOf x t = undefined
```

**Examples**:
```hs
ghci> depthOf 1 gtreeExample1
Just 0
ghci> depthOf 6 gtreeExample1
Just 2
ghci> depthOf 8 gtreeExample1
Just 3
ghci> depthOf 9 gtreeExample1
Nothing
ghci> depthOf 3 gtreeExample1
Just 1
```

**Task 1b**: Write a function `flatten :: GTree a -> [a]` which produces a list
of all values in the tree via a **pre-order** traversal (i.e. the root value
comes first, followed by the flattened children from left to right).

```haskell
flatten :: GTree a -> [a]
flatten t = undefined
```

**Examples**:
```hs
ghci> flatten gtreeExample1
[1,2,5,6,3,4,7,8]
ghci> flatten (GNode 'x' [])
"x"
ghci> flatten gtreeExample2
"abcd"
```

---

## Question 2 (10 marks)

[Run-length encoding](https://en.wikipedia.org/wiki/Run-length_encoding) is a
simple form of data compression in which consecutive identical elements are
stored as a single element together with a count.

For example, the list `"aaabbbccca"` would be encoded as
`[('a',3),('b',3),('c',3),('a',1)]`.

**Task 2a**: Using `foldr`, implement the function `runLengthEncode` which
performs run-length encoding on a list. Consecutive equal elements should be
grouped together. You **must** use `foldr` in your definition (you may not use
explicit recursion on the input list, though you may define helper functions).

```haskell
runLengthEncode :: Eq a => [a] -> [(a, Int)]
runLengthEncode xs = undefined
```

**Examples**:
```hs
ghci> runLengthEncode "aaabbbccca"
[('a',3),('b',3),('c',3),('a',1)]
ghci> runLengthEncode [1,1,2,2,2,3]
[(1,2),(2,3),(3,1)]
ghci> runLengthEncode ""
[]
ghci> runLengthEncode "abcde"
[('a',1),('b',1),('c',1),('d',1),('e',1)]
```

**Task 2b**: Implement the function `runLengthDecode` which reverses the
encoding, expanding each `(element, count)` pair back into the corresponding
sequence of repeated elements.

```haskell
runLengthDecode :: [(a, Int)] -> [a]
runLengthDecode = undefined
```

**Examples**:
```hs
ghci> runLengthDecode [('a',3),('b',3),('c',3),('a',1)]
"aaabbbccca"
ghci> runLengthDecode [(1,2),(2,3),(3,1)]
[1,1,2,2,2,3]
ghci> runLengthDecode []
[]
ghci> runLengthDecode [('x',5)]
"xxxxx"
```

Note that for any list `xs`, we should have
`runLengthDecode (runLengthEncode xs) == xs`.

---

## Question 3 (10 marks)

We model a simple bank account using the `State` monad. The account state
tracks the current balance (in pence) and a log of transaction descriptions.

```haskell
type Balance = Int
type Transaction = String
type AccountState = (Balance, [Transaction])
type BankAccount a = State AccountState a
```

**Task 3a**: Write a function `deposit :: Int -> BankAccount ()` which adds the
given amount to the balance and appends the string `"Deposited X"` to the
transaction history, where `X` is the deposited amount.

```haskell
deposit :: Int -> BankAccount ()
deposit amount = undefined
```

**Task 3b**: Write a function `withdraw :: Int -> BankAccount Bool` which
attempts to withdraw the given amount. If the balance is sufficient (≥ the
amount), reduce the balance by that amount, append the string `"Withdrew X"` to
the transaction history, and return `True`. Otherwise, append the string
`"Failed withdrawal of X"` to the history, leave the balance unchanged, and
return `False`.

```haskell
withdraw :: Int -> BankAccount Bool
withdraw amount = undefined
```

**Task 3c**: Write a function `getHistory :: BankAccount [Transaction]` which
returns the current transaction history without modifying the state.

```haskell
getHistory :: BankAccount [Transaction]
getHistory = undefined
```

For example, given the interaction sequence:

```haskell
bankExample :: BankAccount (Bool, Bool, [Transaction])
bankExample = do
  deposit 500
  b1 <- withdraw 200
  b2 <- withdraw 400
  h  <- getHistory
  return (b1, b2, h)
```

we have:

```
ghci> runState bankExample (0, [])
((True,False,["Deposited 500","Withdrew 200","Failed withdrawal of 400"]),(300,["Deposited 500","Withdrew 200","Failed withdrawal of 400"]))
```

And:

```haskell
bankExample2 :: BankAccount [Transaction]
bankExample2 = do
  deposit 100
  deposit 250
  _ <- withdraw 50
  getHistory
```

```
ghci> runState bankExample2 (0, [])
(["Deposited 100","Deposited 250","Withdrew 50"],(300,["Deposited 100","Deposited 250","Withdrew 50"]))
```

---

## Question 4 (10 marks)

A [Toeplitz matrix](https://en.wikipedia.org/wiki/Toeplitz_matrix) (also called
a diagonal-constant matrix) is a matrix in which each descending diagonal from
left to right is constant. Equivalently, a matrix `A` is Toeplitz if and only if
`A[i][j] == A[i+1][j+1]` for all valid indices `i` and `j`.

For example, the following is a 3×4 Toeplitz matrix:

|   |   |   |   |
|---|---|---|---|
| 1 | 2 | 3 | 4 |
| 5 | 1 | 2 | 3 |
| 6 | 5 | 1 | 2 |

Each descending diagonal (from top-left to bottom-right) contains a single
repeated value: the main diagonal is `[1,1,1]`, the diagonal above it is
`[2,2,2]`, the one above that is `[3,3]`, and the corner is `[4]`. Below the
main diagonal: `[5,5]` and `[6]`.

**Task**: Write a function

```haskell
isToeplitz :: Eq a => [[a]] -> Bool
isToeplitz = undefined
```

which takes a list of lists (representing an m × n matrix, where m ≥ 1 and
n ≥ 1) and returns:

1. `True` if every descending diagonal from left to right is constant (i.e. the
   matrix is a Toeplitz matrix).
2. `False` otherwise.

You may assume that the input is always a well-formed m × n matrix (all rows
have the same length) and is non-empty.

**Hint**: Consider comparing each row with the next row, shifted by one position.

### Examples

```hs
ghci> isToeplitz [[1,2,3,4],[5,1,2,3],[6,5,1,2]]
True
ghci> isToeplitz [[1,2,3],[4,1,2],[5,4,1]]
True
ghci> isToeplitz [[1,2,3],[4,5,6],[7,8,9]]
False
ghci> isToeplitz [[42]]
True
ghci> isToeplitz [[1,2],[3,1],[4,3]]
True
ghci> isToeplitz [[1,2],[1,3]]
False
```

---

## Question 5 (10 marks)

A stack-based virtual machine executes a sequence of instructions that
manipulate a stack of integers. We define the instruction set as follows:

```haskell
data Instr = PUSH Int   -- Push an integer onto the stack
           | ADD         -- Pop the top two values, push their sum
           | MUL         -- Pop the top two values, push their product
           | DUP         -- Duplicate the top value of the stack
           | SWAP        -- Swap the top two values on the stack
           deriving (Eq, Show)

type Stack = [Int]
type Program = [Instr]
```

For `ADD` and `MUL`, the top element of the stack is the **right** operand and
the element below it is the **left** operand (though for these commutative
operations the order does not matter for the result). `SWAP` exchanges the
positions of the top two elements.

An instruction **fails** (and the entire program should return `Nothing`) if
there are not enough elements on the stack to perform it. Specifically:
- `ADD` and `MUL` each require at least 2 elements.
- `DUP` requires at least 1 element.
- `SWAP` requires at least 2 elements.
- `PUSH` always succeeds.

**Task**: Implement the following function which executes a program starting
with an empty stack. If all instructions execute successfully, return
`Just` the final stack. If any instruction fails due to insufficient operands,
return `Nothing`.

```haskell
execProgram :: Program -> Maybe Stack
execProgram prog = undefined
```

**Examples**:
```hs
ghci> execProgram [PUSH 3, PUSH 5, ADD]
Just [8]
ghci> execProgram [PUSH 2, DUP, MUL]
Just [4]
ghci> execProgram [PUSH 1, PUSH 2, PUSH 3, SWAP, ADD]
Just [5,1]
ghci> execProgram [ADD]
Nothing
ghci> execProgram [PUSH 5, SWAP]
Nothing
ghci> execProgram []
Just []
ghci> execProgram [PUSH 10, PUSH 3, PUSH 7, ADD, MUL]
Just [100]
ghci> execProgram [PUSH 4, DUP, ADD, DUP, MUL]
Just [64]
```

In the last example: `PUSH 4` → `[4]`, `DUP` → `[4,4]`, `ADD` → `[8]`,
`DUP` → `[8,8]`, `MUL` → `[64]`.
