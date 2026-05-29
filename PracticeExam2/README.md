# Practice Exam 2

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

* Copy the file `PracticeExam2-Template.hs` to a new file called `PracticeExam2.hs` and write your solutions in `PracticeExam2.hs`.

  __Don't change the header of this file, including the module declaration, and, moreover, don't change the type signature of any of the given functions for you to complete.__

* Solve the exercises below in the file `PracticeExam2.hs` by replacing the default function implementation of `undefined` with your own function.

## Additional Information

* The file `Exam2Types.hs` has various definitions and functions which you are welcome to use when completing the questions.
* This is an open book test.
* You may consult your own notes, the course materials, the official book or [Hoogle](https://hoogle.haskell.org/).
* Feel free to write helper functions whenever convenient.
* All the exercises may be solved without importing additional modules. Do **not** import any modules, as it will interfere with the marking.

---

## Question 1 (10 marks)

A **trie** (also called a prefix tree) is a tree-based data structure for efficiently storing and retrieving keys that are strings. Each node in the trie stores an optional value and a list of (character, sub-trie) pairs representing possible next characters.

We define it as follows:

```haskell
data Trie a = TrieNode (Maybe a) [(Char, Trie a)]
  deriving (Show, Eq)

emptyTrie :: Trie a
emptyTrie = TrieNode Nothing []
```

For example, inserting the key `"cat"` with value `1` and `"car"` with value `2` into an empty trie should build a structure where following `'c'`, then `'a'`, then `'t'` leads to `Just 1`, and following `'c'`, then `'a'`, then `'r'` leads to `Just 2`.

**Task 1a**: Write a function `trieInsert` which inserts a key–value pair into a trie. If the key already exists, overwrite its value.

```haskell
trieInsert :: String -> a -> Trie a -> Trie a
trieInsert key val trie = undefined
```

**Examples**:
```hs
ghci> trieLookup "cat" (trieInsert "cat" 1 emptyTrie)
Just 1
ghci> trieLookup "car" (trieInsert "car" 2 (trieInsert "cat" 1 emptyTrie))
Just 2
ghci> trieLookup "ca" (trieInsert "cat" 1 emptyTrie)
Nothing
ghci> trieLookup "cats" (trieInsert "cat" 1 emptyTrie)
Nothing
```

**Task 1b**: Write a function `trieLookup` which searches for a key in the trie and returns the associated value (or `Nothing` if absent).

```haskell
trieLookup :: String -> Trie a -> Maybe a
trieLookup key trie = undefined
```

**Examples**:
```hs
ghci> trieLookup "dog" trieExample1
Just 3
ghci> trieLookup "do" trieExample1
Nothing
ghci> trieLookup "cats" trieExample1
Nothing
ghci> trieLookup "cat" trieExample1
Just 1
ghci> trieLookup "" trieExample1
Nothing
```

---

## Question 2 (10 marks)

Recall that the higher-order function `iterate` from the Prelude has the type:

```haskell
iterate :: (a -> a) -> a -> [a]
```

It produces an infinite list by repeatedly applying a function: `iterate f x = [x, f x, f (f x), ...]`.

**Task**: Using recursion (do **not** use `iterate` from the Prelude), implement the function `applyUntil` which repeatedly applies a function `f` to a starting value `x`, collecting the results into a list and stopping (inclusively) at the **first** value that satisfies the predicate `p`.

```haskell
applyUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
applyUntil p f x = undefined
```

Your function should satisfy the following properties:
1. The starting value `x` is always included in the output.
2. The first value satisfying `p` is the **last** element of the output list.
3. If `x` itself satisfies `p`, the output is `[x]`.

**Examples**:
```hs
ghci> applyUntil (>= 10) (+3) 0
[0,3,6,9,12]
ghci> applyUntil even (+1) 1
[1,2]
ghci> applyUntil (== 1) (`div` 2) 16
[16,8,4,2,1]
ghci> applyUntil (const True) (+1) 5
[5]
ghci> applyUntil null tail "hello"
["hello","ello","llo","lo","o",""]
```

---

## Question 3 (10 marks)

We model a simple text-adventure game using the `State` monad. The game state tracks the player's current room and their inventory of items.

```haskell
type Room      = String
type Item      = String
type GameState = (Room, [Item])   -- (current room, inventory)
type Adventure a = State GameState a
```

**Task 3a**: Write a function `currentRoom :: Adventure Room` which returns the name of the room the player is currently in, without modifying the state.

```haskell
currentRoom :: Adventure Room
currentRoom = undefined
```

**Task 3b**: Write a function `pickUp :: Item -> Adventure ()` which adds the given item to the player's inventory.

```haskell
pickUp :: Item -> Adventure ()
pickUp item = undefined
```

**Task 3c**: Write a function `move :: Room -> Adventure ()` which moves the player to a new room. Moving to a new room **clears the inventory** (the player drops everything when they leave).

```haskell
move :: Room -> Adventure ()
move room = undefined
```

For example, given the interaction sequence:

```haskell
adventureExample :: Adventure (Room, [Item])
adventureExample = do
  pickUp "Sword"
  pickUp "Key"
  move "Library"
  pickUp "Book"
  r <- currentRoom
  (_, inv) <- get
  return (r, inv)
```

we have:

```
ghci> runState adventureExample ("Entrance Hall", [])
(("Library",["Book"]),("Library",["Book"]))
```

And:

```haskell
adventureExample2 :: Adventure [Item]
adventureExample2 = do
  pickUp "Torch"
  pickUp "Shield"
  (_, inv) <- get
  return inv
```

```
ghci> runState adventureExample2 ("Dungeon", [])
(["Torch","Shield"],("Dungeon",["Torch","Shield"]))
```

---

## Question 4 (10 marks)

In Sudoku, the grid is divided into 3×3 boxes. Each such box must contain all of the digits 1 through 9, each appearing exactly once.

More generally, we say that an `n × n` grid is a **valid box** if:
1. It contains exactly `n²` elements in total (i.e. `n` rows of `n` elements each).
2. Every integer from `1` to `n²` appears **exactly once**.

**Task**: Write a function

```haskell
isSudokuBox :: [[Int]] -> Bool
isSudokuBox = undefined
```

which takes a list of lists of integers and returns:

1. `True` if the input represents a valid box (every integer from `1` to `n²` appears exactly once across all rows).
2. `False` otherwise.

You may assume that the input is a well-formed `n × n` grid for some positive integer `n`. You will not be tested on the empty list.

### Examples

```hs
ghci> isSudokuBox [[1,2,3],[4,5,6],[7,8,9]]
True
ghci> isSudokuBox [[1,2,3],[4,5,6],[7,8,1]]
False
ghci> isSudokuBox [[1,2],[3,4]]
True
ghci> isSudokuBox [[1,2],[2,3]]
False
ghci> isSudokuBox [[1,2],[3,5]]
False
```

---

## Question 5 (10 marks)

We can represent propositional logic expressions using the following datatype, which extends the usual connectives with **exclusive or** (`XOR`):

```haskell
data PropExpr = PVar   Char
              | PNot   PropExpr
              | PAnd   PropExpr PropExpr
              | POr    PropExpr PropExpr
              | PXor   PropExpr PropExpr
              deriving (Eq, Show)
```

Some examples:
- The formula `p` would be represented as `PVar 'p'`.
- The formula `p ∧ ¬q` would be represented as `PAnd (PVar 'p') (PNot (PVar 'q'))`.
- The formula `p ⊕ q` (p XOR q, true when exactly one of p, q is true) is `PXor (PVar 'p') (PVar 'q')`.

We evaluate expressions under an environment mapping variable names to `Bool` values:

```haskell
type PropEnv = [(Char, Bool)]
```

**Task 5a**: Implement `evalProp` which evaluates a propositional expression under the given environment. If any variable in the expression is not found in the environment, return `Nothing`. Use the `Maybe` monad to propagate failures.

Recall that `p XOR q` is `True` when exactly one of `p` or `q` is `True` (i.e. they differ).

```haskell
evalProp :: PropEnv -> PropExpr -> Maybe Bool
evalProp env expr = undefined
```

**Examples**:
```hs
ghci> evalProp [('p', True), ('q', False)] (PAnd (PVar 'p') (PVar 'q'))
Just False
ghci> evalProp [('p', True), ('q', False)] (POr (PVar 'p') (PVar 'q'))
Just True
ghci> evalProp [('p', True)] (PNot (PVar 'p'))
Just False
ghci> evalProp [('p', True), ('q', False)] (PXor (PVar 'p') (PVar 'q'))
Just True
ghci> evalProp [('p', True), ('q', True)] (PXor (PVar 'p') (PVar 'q'))
Just False
ghci> evalProp [('p', True)] (PAnd (PVar 'p') (PVar 'q'))
Nothing
```

**Task 5b**: Write a function `propVars :: PropExpr -> [Char]` which returns the list of all variable names occurring in the expression, **without duplicates**, in the order of their **first appearance** (left to right, depth-first).

```haskell
propVars :: PropExpr -> [Char]
propVars expr = undefined
```

**Examples**:
```hs
ghci> propVars (PAnd (PVar 'p') (PVar 'q'))
"pq"
ghci> propVars (POr (PVar 'p') (PAnd (PVar 'q') (PVar 'p')))
"pq"
ghci> propVars (PNot (PVar 'r'))
"r"
ghci> propVars (PXor (PAnd (PVar 'a') (PVar 'b')) (POr (PVar 'b') (PVar 'c')))
"abc"
```
