# Practice Exam 7

## Marking Table

The exercises are defined so that it is hard to get a first-class mark.

| Mark         | Cut-off            |
| ------------ | ------------------ |
| 1st          | 35 marks and above |
| upper second | 30-34 marks        |
| lower second | 25-29 marks        |
| third        | 20-24 marks        |
| fail         | 0-19 marks         |

Questions 1–5 have equal weight (10 marks each, 50 total). Questions 6 and 7 are bonus questions worth 10 extra marks each.

## Preparation

* Do __not__ modify either the file `Types.hs` or the file `PracticeExam7-Template.hs`.
* Copy the file `PracticeExam7-Template.hs` to a new file called `PracticeExam7.hs` and write your solutions in `PracticeExam7.hs`.

  __Don't change the header of this file, including the module declaration, and, moreover, don't change the type signature of any of the given functions for you to complete.__

* Solve the exercises below in the file `PracticeExam7.hs` by replacing the default function implementation of `undefined` with your own function.

## Additional Information

* The file `Types.hs` has various definitions and functions which you are welcome to use when completing the questions.
* This is an open book test.
* Feel free to write helper functions whenever convenient.
* All the exercises may be solved without importing additional modules. Do **not** import any modules beyond what is already imported.

---

## Question 1 — Rose Trees (10 marks)

A **rose tree** (also called a multi-way tree) is a tree where each node can have any number of children:

```haskell
data Rose a = Rose a [Rose a]
            deriving (Show, Eq)
```

A **leaf** is a node with an empty list of children. Example trees are provided in `Types.hs`:

```
roseEx3:
       1
     / | \
    2  3  4
   / \    |
  5   6   7
```

### Part (a): `roseSize` (3 marks)

Count the total number of nodes in a rose tree.

```haskell
roseSize :: Rose a -> Int
roseSize t = undefined
```

### Part (b): `roseLeaves` (3 marks)

Collect the values at all **leaf** nodes (nodes with no children), in left-to-right order.

```haskell
roseLeaves :: Rose a -> [a]
roseLeaves t = undefined
```

### Part (c): `rosePaths` (4 marks)

Return all paths from the root to each leaf, where each path is a list of values.

```haskell
rosePaths :: Rose a -> [[a]]
rosePaths t = undefined
```

### Examples

```hs
ghci> roseSize roseEx1
1

ghci> roseSize roseEx3
7

ghci> roseLeaves roseEx2
[2,3,4]

ghci> roseLeaves roseEx3
[5,6,3,7]

ghci> rosePaths roseEx1
[[1]]

ghci> rosePaths roseEx3
[[1,2,5],[1,2,6],[1,3],[1,4,7]]
```

### Hints

* For `roseSize`, the size is 1 (for the root) plus the sum of the sizes of all children. The `map` and `sum` functions are useful.
* For `roseLeaves`, a leaf is a `Rose x []` — pattern match on this case. For internal nodes, use `concatMap`.
* For `rosePaths`, a leaf has a single path `[[x]]`. For internal nodes, prepend the root value to every path from every child.

---

## Question 2 — Caesar Cipher (10 marks)

The Caesar cipher is a simple encryption method that shifts each letter by a fixed number of positions in the alphabet, wrapping around. Non-letter characters are left unchanged.

You may use the following from `Data.Char` (already imported): `ord`, `chr`, `isLower`, `isUpper`.

### Part (a): `caesarShift` (4 marks)

Shift a single character by `n` positions. Handle both lowercase and uppercase letters. Non-letter characters are returned unchanged.

```haskell
caesarShift :: Int -> Char -> Char
caesarShift n c = undefined
```

### Part (b): `caesarEncode` (3 marks)

Encode an entire string using the given shift factor.

```haskell
caesarEncode :: Int -> String -> String
caesarEncode n s = undefined
```

### Part (c): `caesarDecode` (3 marks)

Decode an encoded string using the given shift factor.

```haskell
caesarDecode :: Int -> String -> String
caesarDecode n s = undefined
```

### Examples

```hs
ghci> caesarShift 3 'a'
'd'

ghci> caesarShift 3 'z'
'c'

ghci> caesarEncode 3 "haskell is fun"
"kdvnhoo lv ixq"

ghci> caesarDecode 3 "kdvnhoo lv ixq"
"haskell is fun"

ghci> caesarEncode 13 "Hello World"
"Uryyb Jbeyq"

ghci> caesarDecode 13 "Uryyb Jbeyq"
"Hello World"
```

### Hints

* Convert a character to a 0-based index using `ord c - ord 'a'` (for lowercase) or `ord c - ord 'A'` (for uppercase).
* Add the shift and take `mod 26` to wrap around.
* Convert back using `chr (ord 'a' + n)`.
* `caesarDecode` can be defined very simply in terms of `caesarEncode`.

---

## Question 3 — State Monad (Shopping Cart) (10 marks)

A shopping cart is modelled as a list of `(item name, price)` pairs:

```haskell
type Cart = [(String, Int)]
type ShopState = State Cart
```

### Part (a): `addItem` (3 marks)

Add an item with a given name and price to the cart.

```haskell
addItem :: String -> Int -> ShopState ()
addItem name price = undefined
```

### Part (b): `removeItem` (4 marks)

Remove the **first** occurrence of an item by name. Return `True` if the item was found and removed, `False` otherwise.

```haskell
removeItem :: String -> ShopState Bool
removeItem name = undefined
```

### Part (c): `getTotal` (3 marks)

Compute the total price of all items in the cart.

```haskell
getTotal :: ShopState Int
getTotal = undefined
```

### Examples

```hs
ghci> runState (addItem "apple" 3) []
((),[("apple",3)])

ghci> runState (addItem "apple" 3 >> addItem "bread" 5 >> getTotal) []
(8,[("bread",5),("apple",3)])

ghci> runState (addItem "apple" 3 >> addItem "bread" 5 >> removeItem "apple") []
(True,[("bread",5)])

ghci> runState (removeItem "milk") []
(False,[])
```

### Hints

* Use `get` to read the cart and `put` to write a modified cart.
* For `removeItem`, the function `span :: (a -> Bool) -> [a] -> ([a], [a])` is useful: it splits a list at the first element that **doesn't** satisfy the predicate.
* For `getTotal`, `sum (map snd cart)` sums the prices.

---

## Question 4 — List Processing (10 marks)

### Part (a): `groupConsecutive` (5 marks)

Group consecutive equal elements of a list together.

```haskell
groupConsecutive :: Eq a => [a] -> [[a]]
groupConsecutive xs = undefined
```

### Part (b): `windows` (5 marks)

Return all contiguous subsequences (sliding windows) of length `n` from a list.

```haskell
windows :: Int -> [a] -> [[a]]
windows n xs = undefined
```

### Examples

```hs
ghci> groupConsecutive "aabbccca"
["aa","bb","ccc","a"]

ghci> groupConsecutive [1,1,2,3,3,3,4]
[[1,1],[2],[3,3,3],[4]]

ghci> groupConsecutive ([] :: [Int])
[]

ghci> groupConsecutive "abcde"
["a","b","c","d","e"]

ghci> windows 3 [1,2,3,4,5]
[[1,2,3],[2,3,4],[3,4,5]]

ghci> windows 2 "abcde"
["ab","bc","cd","de"]

ghci> windows 5 [1,2,3]
[]

ghci> windows 1 [1,2,3]
[[1],[2],[3]]
```

### Hints

* For `groupConsecutive`, match on `(x:xs)` and use `takeWhile (== x)` to grab the run, then `dropWhile (== x)` to get the rest and recurse.
* For `windows`, if the list has fewer than `n` elements, return `[]`. Otherwise, `take n xs` is the first window, and you recurse on `tail xs`.

---

## Question 5 — Merge Sort (10 marks)

Implement the classic merge sort algorithm via three functions.

### Part (a): `merge` (4 marks)

Merge two **sorted** lists into a single sorted list.

```haskell
merge :: Ord a => [a] -> [a] -> [a]
merge xs ys = undefined
```

### Part (b): `halve` (2 marks)

Split a list into two roughly equal halves. Use `splitAt` and `div`.

```haskell
halve :: [a] -> ([a], [a])
halve xs = undefined
```

### Part (c): `msort` (4 marks)

Sort a list using merge sort. Split the list in half, recursively sort each half, and merge the results. Base cases: empty and singleton lists are already sorted.

```haskell
msort :: Ord a => [a] -> [a]
msort xs = undefined
```

### Examples

```hs
ghci> merge [1,3,5] [2,4,6]
[1,2,3,4,5,6]

ghci> merge [1,2,3] []
[1,2,3]

ghci> halve [1,2,3,4,5,6]
([1,2,3],[4,5,6])

ghci> halve [1]
([],[1])

ghci> msort [4,1,3,5,2]
[1,2,3,4,5]

ghci> msort "haskell"
"aehklls"

ghci> msort ([] :: [Int])
[]
```

### Hints

* `merge` should pattern match on both lists: if either is empty, return the other. Otherwise compare the heads and recurse.
* `halve xs = splitAt (length xs \`div\` 2) xs` is the simplest approach.
* `msort` needs two base cases (`[]` and `[x]`) to ensure termination. For the recursive case, split with `halve`, sort both halves, and `merge` them.

---

## Question 6 (EXTRA) — Parsing Key-Value Pairs (10 marks)

The file `Types.hs` provides a complete monadic parser library. Using it, write a parser `parseKeyValue` that parses a string of the form `"key=value"` into a pair `(key, value)`.

Rules:
- The **key** consists of one or more lowercase letters.
- The **separator** is the character `'='`.
- The **value** consists of one or more alphanumeric characters.

```haskell
parseKeyValue :: Parser (String, String)
parseKeyValue = undefined
```

### Examples

```hs
ghci> parse parseKeyValue "name=John"
[("name","John"),"")]

ghci> parse parseKeyValue "age=25"
[("age","25"),"")]

ghci> parse parseKeyValue "x=1 rest"
[("x","1")," rest")]

ghci> parse parseKeyValue "=bad"
[]
```

Note: in the third example, the parser stops after consuming `"x=1"` and leaves `" rest"` unconsumed. In the fourth example, the parser fails because there are no lowercase letters before `=`.

### Hints

* Use `some lower` to parse one or more lowercase letters (the key).
* Use `char '='` to consume the separator.
* Use `some alphanum` to parse one or more alphanumeric characters (the value).
* Combine them with `do` notation and return a tuple `(k, v)`.

---

## Question 7 (EXTRA) — Expression Evaluation (10 marks)

Consider the following type for arithmetic expressions with division:

```haskell
data Expr = Val Int
          | Add Expr Expr
          | Sub Expr Expr
          | Mul Expr Expr
          | Div Expr Expr     -- can fail with division by zero
          deriving (Show, Eq)
```

Division by zero should be handled gracefully using `Maybe`: a successful evaluation returns `Just n`, while division by zero anywhere in the expression returns `Nothing`.

Example expressions are provided in `Types.hs`:

```
expr1 = Add (Val 2) (Val 3)                                           -- 2 + 3 = 5
expr2 = Mul (Add (Val 1) (Val 2)) (Val 4)                             -- (1+2) * 4 = 12
expr3 = Div (Val 10) (Val 0)                                          -- 10 / 0 = error!
expr4 = Add (Div (Val 10) (Val 2)) (Mul (Val 3) (Sub (Val 5) (Val 1))) -- 10/2 + 3*(5-1) = 17
```

### Part (a): `evalExpr` (6 marks)

Evaluate an expression, returning `Nothing` if any division by zero occurs. Use the **Maybe monad** (`do` notation) to propagate errors automatically.

```haskell
evalExpr :: Expr -> Maybe Int
evalExpr e = undefined
```

### Part (b): `showExpr` (4 marks)

Pretty-print an expression using infix notation with **full parenthesisation** (every binary operation is wrapped in parentheses). `Val n` is shown as just `show n`.

```haskell
showExpr :: Expr -> String
showExpr e = undefined
```

### Examples

```hs
ghci> evalExpr expr1
Just 5

ghci> evalExpr expr2
Just 12

ghci> evalExpr expr3
Nothing

ghci> evalExpr expr4
Just 17

ghci> evalExpr (Div (Val 10) (Sub (Val 3) (Val 3)))
Nothing

ghci> evalExpr (Add (Val 1) (Div (Val 5) (Val 0)))
Nothing

ghci> showExpr expr1
"(2 + 3)"

ghci> showExpr expr2
"((1 + 2) * 4)"

ghci> showExpr expr4
"((10 / 2) + (3 * (5 - 1)))"
```

### Hints

* For `evalExpr`, pattern match on each constructor. For `Val n`, return `Just n`. For binary operations, use `do` notation to evaluate both sub-expressions, then combine. For `Div`, check if the divisor is 0 **after** evaluating it.
* The key advantage of using the Maybe monad: if **any** sub-expression fails (returns `Nothing`), the failure propagates automatically — you don't need to write explicit `case Nothing -> Nothing` checks.
* For `showExpr`, `Val n` maps to `show n`. Each binary operation `op` maps to `"(" ++ showExpr e1 ++ " op " ++ showExpr e2 ++ ")"`.
* Use `div` for integer division (not `/` which is for fractional types).
