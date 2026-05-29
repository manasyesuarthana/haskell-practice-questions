# Practice Exam 4

## Marking table

The exercises are designed to separate basic competence from true mastery. It is intentionally challenging to achieve a first-class mark.

| Mark         | Cut-off            |
| ------------ | ------------------ |
| 1st          | 35 marks and above |
| upper second | 30-34 marks        |
| lower second | 25-29 marks        |
| third        | 20-24 marks        |
| fail         | 0-19 marks         |

All questions have equal weight, with ten marks each, for a total of 50 marks.

## Preparation

* Copy the file `PracticeExam4-Template.hs` to a new file called `PracticeExam4.hs` and write your solutions in `PracticeExam4.hs`.

  __Don't change the header of this file, including the module declaration, and, moreover, don't change the type signature of any of the given functions for you to complete.__

* Solve the exercises below in the file `PracticeExam4.hs` by replacing the default function implementation of `undefined` with your own function.

## Additional Information

* The file `Exam4Types.hs` has various definitions and functions which you are welcome to use when completing the questions.
* This is an open book test.
* You may consult your own notes, the course materials, the official book or [Hoogle](https://hoogle.haskell.org/).
* Feel free to write helper functions whenever convenient.
* All the exercises may be solved without importing additional modules. Do **not** import any modules, as it will interfere with the marking.

---

## Question 1 (10 marks)

Consider the following recursive data type representing a highly simplified hierarchical file system:

```haskell
data FileSystem = File String Int           -- A file with a name and a size in bytes
                | Dir String [FileSystem]   -- A directory with a name and its contents
                deriving (Show, Eq)
```

**Task 1a (5 marks)**: Write a function `totalSize :: FileSystem -> Int` which calculates the total size of all files contained within the filesystem, traversing into all nested directories.

```haskell
totalSize :: FileSystem -> Int
totalSize fs = undefined
```

**Task 1b (5 marks)**: Write a function `findFiles :: String -> FileSystem -> [String]` which returns a list of the names of all **files** (ignoring directory names) whose exact name matches the given string. The list should be populated via a depth-first, left-to-right traversal of the filesystem hierarchy.

```haskell
findFiles :: String -> FileSystem -> [String]
findFiles targetName fs = undefined
```

*Examples*:
```haskell
ghci> let myFs = Dir "root" [File "a.txt" 10, Dir "sub" [File "b.txt" 20, File "a.txt" 30]]
ghci> totalSize myFs
60
ghci> findFiles "a.txt" myFs
["a.txt","a.txt"]
ghci> findFiles "c.txt" myFs
[]
```


---

## Question 2 (10 marks)

In Haskell, we often use `sequence` to execute a list of monadic actions. However, sometimes we want to short-circuit execution based on the *result* of the actions.

**Task**: Implement the function `sequenceWhile`. This function takes a predicate and a list of monadic actions. It executes the actions in order. If the bound result of an action satisfies the predicate, the result is collected, and the function proceeds to the next action. If the result does *not* satisfy the predicate, that result is discarded, execution of all remaining actions is immediately halted, and the collected results are returned within the monad.

```haskell
sequenceWhile :: Monad m => (a -> Bool) -> [m a] -> m [a]
sequenceWhile p actions = undefined
```

*Example behavior*:
```haskell
ghci> sequenceWhile even [return 2, return 4, return 5, return 6]
[2,4]
```
*(Note: Because `5` is not even, `return 6` is entirely unexecuted, demonstrating proper monadic short-circuiting).*

---

## Question 3 (10 marks)

We model a grid-based robot navigator using the `State` monad. The state tracks the robot's coordinates `(x, y)` and the cardinal direction it is currently facing.

```haskell
data Direction = North | East | South | West
  deriving (Eq, Show, Enum)

type Position = (Int, Int)
type RobotState = (Position, Direction)
type Robot a = State RobotState a

data Command = TurnLeft | TurnRight | Forward Int
  deriving (Eq, Show)
```

Assume that moving `North` increases the `y` coordinate, `East` increases the `x` coordinate, `South` decreases `y`, and `West` decreases `x`.

**Task 3a (3 marks)**: Write a function `turnRight :: Robot ()` which updates the state so that the robot faces 90 degrees to the right (e.g., `North` becomes `East`, `West` becomes `North`).

```haskell
turnRight :: Robot ()
turnRight = undefined
```

**Task 3b (4 marks)**: Write a function `forward :: Int -> Robot ()` which moves the robot forward by the specified number of units in its *current* facing direction, updating the coordinates in the state accordingly.

```haskell
forward :: Int -> Robot ()
forward steps = undefined
```

**Task 3c (3 marks)**: Write a function `execute :: [Command] -> Robot ()` which executes a sequence of commands sequentially.

```haskell
execute :: [Command] -> Robot ()
execute cmds = undefined
```

*Examples*:
```haskell
ghci> runState (execute [Forward 2, TurnRight, Forward 3]) ((0,0), North)
((),((3,2),East))
ghci> runState (execute [TurnRight, TurnRight, Forward 5]) ((1,1), North)
((),((1,-4),South))
```


---

## Question 4 (10 marks)

A Latin square of order `n` is an `n × n` matrix in which each row and each column is a mathematically rigorous permutation of the integers from `1` to `n`. 

**Task**: Write a function `isLatinSquare :: [[Int]] -> Bool` which takes a list of lists of integers (representing a matrix) and returns `True` if it strictly forms a Latin square, and `False` otherwise. 

You may assume the input is always a well-formed `n × n` matrix with `n >= 1`.

```haskell
isLatinSquare :: [[Int]] -> Bool
isLatinSquare matrix = undefined
```

*Examples*:
```haskell
ghci> isLatinSquare [[1,2,3],[2,3,1],[3,1,2]]
True
ghci> isLatinSquare [[1,2],[2,2]]
False
ghci> isLatinSquare [[1,2,3],[3,1,2],[2,3,1]]
True
```

---

## Question 5 (10 marks)

Consider the following simplified Algebraic Data Type representing a JSON structure:

```haskell
data JSON = JNull
          | JBool Bool
          | JNum Int
          | JStr String
          | JArr [JSON]
          | JObj [(String, JSON)]
          deriving (Eq, Show)
```

**Task**: Write a rigorous function `stringify :: JSON -> String` that linearly converts a `JSON` value into its compact string representation. 

Formatting axioms:
1. `JNull` strictly becomes `"null"`
2. `JBool True` becomes `"true"`, and `JBool False` becomes `"false"`
3. `JNum n` becomes the string representation of `n` (e.g., `123` -> `"123"`)
4. `JStr s` becomes the string `s` enclosed in double quotes (e.g., `"hello"` -> `"\"hello\""`). Assume `s` requires no internal character escaping.
5. `JArr xs` becomes a comma-separated list of stringified elements surrounded by square brackets (e.g., `"[1,true,null]"`).
6. `JObj kvs` becomes a comma-separated list of `"key":value` pairs surrounded by curly braces (e.g., `"{\"name\":\"Alice\",\"age\":30}"`).

```haskell
stringify :: JSON -> String
stringify json = undefined
```

*Example*:
```haskell
ghci> stringify (JObj [("name", JStr "Alice"), ("scores", JArr [JNum 10, JNum 20])])
"{\"name\":\"Alice\",\"scores\":[10,20]}"
```
