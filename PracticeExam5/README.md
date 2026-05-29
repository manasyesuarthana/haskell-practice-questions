# Practice Exam 5

## Marking Table

The exercises are defined so that it is hard to get a first-class mark.

| Mark         | Cut-off            |
| ------------ | ------------------ |
| 1st          | 35 marks and above |
| upper second | 30-34 marks        |
| lower second | 25-29 marks        |
| third        | 20-24 marks        |
| fail         | 0-19 marks         |

All questions have equal weight, with ten marks each, with a total of 70 marks.

## Preparation

* Do __not__ modify either the file `Types.hs` or the file `PracticeExam5-Template.hs`.
* Copy the file `PracticeExam5-Template.hs` to a new file called `PracticeExam5.hs` and write your solutions in `PracticeExam5.hs`.

  __Don't change the header of this file, including the module declaration, and, moreover, don't change the type signature of any of the given functions for you to complete.__
  
  __If you do make changes, then we will not be able to mark your submission and hence it will receive zero marks!__
  
* Solve the exercises below in the file `PracticeExam5.hs` by replacing the default function implementation of `undefined` with your own function.

## Additional Information

* The file `Types.hs` has various definitions and functions which you are welcome to use when completing the questions.
* This file is already in scope when you load `PracticeExam5.hs`.
* This is an open book test.
* You may consult your own notes, the course materials, the official book or [Hoogle](https://hoogle.haskell.org/).
* Feel free to write helper functions whenever convenient.
* All the exercises may be solved without importing additional modules. Do **not** import any modules beyond what is already imported, as it will interfere with the marking.

---

## Question 1 — String Processing (10 marks)

Write a function `duplicateDigits` that takes a string and returns a new string where every digit character (i.e. `'0'` through `'9'`) is duplicated, while all other characters remain unchanged.

You may use the function `isDigit :: Char -> Bool` from `Data.Char` (already imported via `Types.hs`).

```haskell
duplicateDigits :: String -> String
duplicateDigits s = undefined
```

### Examples

```hs
ghci> duplicateDigits "abc123"
"abc112233"

ghci> duplicateDigits "h3ll0 w0rld"
"h33ll00 w00rld"

ghci> duplicateDigits ""
""

ghci> duplicateDigits "hello"
"hello"

ghci> duplicateDigits "42"
"4422"
```

### Hints

* Recall that strings in Haskell are lists of characters: `type String = [Char]`.
* Pattern match on the empty string and `(c:cs)`.
* Use guards to distinguish digit characters from non-digit characters.

---

## Question 2 — Digit Predicates (10 marks)

We say a non-negative integer is **super-odd** if *every one* of its decimal digits is odd (i.e. each digit is 1, 3, 5, 7, or 9).

For example:
- `1357` is super-odd because all digits (1, 3, 5, 7) are odd.
- `1234` is **not** super-odd because the digits 2 and 4 are even.
- `0` is **not** super-odd because 0 is even.

**Task**: Implement the following function which checks whether a given integer is super-odd.

```haskell
superOdd :: Int -> Bool
superOdd n = undefined
```

### Examples

```hs
ghci> superOdd 1357
True

ghci> superOdd 1234
False

ghci> superOdd 9
True

ghci> superOdd 0
False

ghci> superOdd 13579
True

ghci> superOdd 22
False
```

### Hints

* You will likely need a helper to decompose an integer into its digits. One approach: convert the integer to a `String` via `show`, then convert each character back to an `Int` using `digitToInt :: Char -> Int` (available from `Data.Char`, already imported).
* The function `all :: (a -> Bool) -> [a] -> Bool` may be useful.
* Use `abs` to handle the sign of the number, or assume non-negative inputs only.

---

## Question 3 — Tree Anagrams (10 marks)

Consider the following type of binary trees with data at the leaves:

```haskell
data Tree a = Leaf a
            | Branch (Tree a) (Tree a)
            deriving (Show, Eq)
```

Two trees are **anagrams** of each other if one can be obtained from the other by swapping the left and right subtrees at zero or more `Branch` nodes. In other words, the trees have the same "shape up to reflection" and carry the same leaf values.

**Task**: Write a function that checks whether two trees are anagrams.

```haskell
areTreeAnagrams :: Eq a => Tree a -> Tree a -> Bool
areTreeAnagrams t1 t2 = undefined
```

### Examples

```hs
ghci> areTreeAnagrams (Leaf 1) (Leaf 1)
True

ghci> areTreeAnagrams (Leaf 1) (Leaf 2)
False

ghci> areTreeAnagrams (Branch (Leaf 1) (Leaf 2)) (Branch (Leaf 2) (Leaf 1))
True

ghci> areTreeAnagrams (Branch (Leaf 1) (Leaf 2)) (Branch (Leaf 1) (Leaf 2))
True

ghci> areTreeAnagrams (Branch (Leaf 1) (Leaf 2)) (Leaf 1)
False

ghci> let t1 = Branch (Branch (Leaf 'a') (Leaf 'b')) (Leaf 'c')
ghci> let t2 = Branch (Leaf 'c') (Branch (Leaf 'b') (Leaf 'a'))
ghci> areTreeAnagrams t1 t2
True
```

### Hints

* A `Leaf` is only an anagram of another `Leaf` with the same value.
* A `Branch l r` is an anagram of `Branch l' r'` if **either**: 
  - `l` is an anagram of `l'` **and** `r` is an anagram of `r'`, **or**
  - `l` is an anagram of `r'` **and** `r` is an anagram of `l'`.
* A `Leaf` is never an anagram of a `Branch` (and vice versa).

---

## Question 4 — Knapsack Packing (10 marks)

Consider a collection of items, each with a fixed weight:

```haskell
data Item = Gem | Scroll | Potion | Shield
            deriving (Show, Eq, Ord, Enum, Bounded)

class Weighable a where
  weight :: a -> Int

instance Weighable Item where
  weight Gem    = 1
  weight Scroll = 2
  weight Potion = 3
  weight Shield = 5
```

A **knapsack** of capacity `w` is any *multiset* (i.e. repetitions allowed) of items whose total weight is **at most** `w`. We represent a knapsack as a list `[Item]`.

**Task**: Write a function that enumerates *all* possible knapsacks for a given weight capacity, including the empty knapsack.

```haskell
knapsack :: Int -> [[Item]]
knapsack w = undefined
```

### Examples

```hs
ghci> knapsack 0
[[]]

ghci> knapsack 1
[[Gem],[]]

ghci> knapsack 2
[[Gem,Gem],[Gem],[Scroll],[]]

ghci> length (knapsack 5)
29
```

> **Note**: The exact ordering of the output lists does not matter for marking — only the set of results must be correct.

### Hints

* When `w < 0`, there are no valid knapsacks (return `[]`).
* When `w == 0`, the only valid knapsack is the empty one (`[[]]`).
* When `w > 0`, for each item `x` whose weight does not exceed `w`, you can place `x` in the knapsack and recursively fill the remaining capacity `w - weight x`. Don't forget to also include the option of *not adding any more items* (the empty knapsack `[]`).
* Use the `Enum` and `Bounded` instances to enumerate all items: `[minBound..maxBound]`.
* A list comprehension is a natural fit here.

---

## Question 5 — Sieve of Eratosthenes (10 marks)

The [Sieve of Eratosthenes](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) is a classic algorithm for finding all prime numbers up to a given limit `n`. It works as follows:

1. Start with a list of boolean flags of length `n`, all initially set to `True`. The flag at position `i` (1-indexed) represents whether `i` is *potentially prime*.
2. Starting from `p = 2`, if the flag at position `p` is `True`, then mark all **proper multiples** of `p` (i.e. `2p, 3p, 4p, ...`) as `False`. Do **not** mark `p` itself as `False`.
3. Move to the next value of `p` and repeat. You can stop once `p * p > n`.
4. The positions that are still `True` (and are ≥ 2) are the primes.

Implement the sieve via the following three functions:

### Part (a): `crossOff`

```haskell
crossOff :: Int -> [Bool] -> [Bool]
crossOff n xs = undefined
```

Given a prime `n` and a boolean list `xs` (1-indexed conceptually), `crossOff` sets to `False` every position `i` in `xs` such that `i > 1`, `i /= n`, and `i` is a multiple of `n`.

### Part (b): `sieveFrom`

```haskell
sieveFrom :: Int -> [Bool] -> [Bool]
sieveFrom n xs = undefined
```

`sieveFrom n xs` performs the sieve starting from candidate `n`. If `n * n` exceeds the length of `xs`, the sieve is done — return `xs`. Otherwise, if position `n` is `True`, cross off multiples of `n` and recurse with `n + 1`; if position `n` is `False`, simply recurse with `n + 1`.

### Part (c): `primesUpTo`

```haskell
primesUpTo :: Int -> [Int]
primesUpTo n = undefined
```

Use `sieveFrom` (starting from 2, with a list of `n` `True` values) to produce the list of all primes up to `n`.

### Examples

```hs
ghci> crossOff 2 [True, True, True, True, True, True, True, True, True, True]
[True,True,True,False,True,False,True,False,True,False]

ghci> crossOff 3 [True,True,True,False,True,False,True,False,True,False]
[True,True,True,False,True,False,True,False,False,False]

ghci> primesUpTo 10
[2,3,5,7]

ghci> primesUpTo 30
[2,3,5,7,11,13,17,19,23,29]

ghci> primesUpTo 2
[2]

ghci> length (primesUpTo 100)
25
```

### Hints

* For `crossOff`, a list comprehension over indices `[1..length xs]` can be useful. Use `(!!)` (0-indexed) to access the current value and conditionally flip it to `False`.
* For `sieveFrom`, use `(!!)` to check whether position `n` is still marked `True`.
* For `primesUpTo`, initialize the boolean list with `replicate n True`, run the sieve, and collect indices that remain `True` and are `>= 2`.

---

## Question 6 — Pretty-Printing Bracket Expressions (10 marks)

Consider the following types for representing expressions made of balanced parentheses `()`, square brackets `[]`, and curly braces `{}`:

```haskell
data Token = Paren   Expr
           | Bracket Expr
           | Brace   Expr
           deriving (Show, Eq)

data Expr = E [Token]
          deriving (Show, Eq)
```

An `Expr` is a (possibly empty) sequence of tokens. Each `Token` wraps an inner `Expr` inside one of the three bracket types. For example:

- `E []` represents the empty string `""`
- `E [Paren (E [])]` represents `"()"`
- `E [Paren (E []), Bracket (E [])]` represents `"()[]"`
- `E [Paren (E [Bracket (E [Brace (E [])])])]` represents `"([{}])"`

**Task**: Write a function that converts an `Expr` into the corresponding string of balanced brackets.

```haskell
prettyShow :: Expr -> String
prettyShow e = undefined
```

### Examples

```hs
ghci> prettyShow (E [])
""

ghci> prettyShow (E [Paren (E [])])
"()"

ghci> prettyShow (E [Paren (E []), Bracket (E []), Brace (E [])])
"()[]{}"

ghci> prettyShow (E [Paren (E [Bracket (E [Brace (E [])])])])
"([{}])"

ghci> prettyShow (E [Paren (E [Paren (E [])]), Bracket (E [Brace (E [])])])
"(())[{}]"
```

### Hints

* Pattern match on the `E` constructor: the base case is `E []` (the empty expression).
* For a non-empty token list, pattern match on the head token (`Paren e`, `Bracket e`, or `Brace e`) and the tail.
* Recursively call `prettyShow` on both the *inner* expression `e` and the *remaining* tokens `E ts`.
* Use `++` to concatenate the opening bracket, the inner string, the closing bracket, and the rest.

---

## Question 7 — Parsing Bracket Expressions (10 marks)

The file `Types.hs` provides a complete monadic parser library (as covered in the lectures on monadic parsing). The key definitions are:

```haskell
newtype Parser a = P (String -> [(a, String)])

parse :: Parser a -> String -> [(a, String)]  -- run a parser

-- Available combinators:
char  :: Char -> Parser Char       -- parse a specific character
(<|>) :: Parser a -> Parser a -> Parser a  -- try first parser, else second
many  :: Parser a -> Parser [a]    -- zero or more repetitions
pure  :: a -> Parser a             -- succeed without consuming input
```

Using these combinators and `do` notation, write a parser `parseExpression` that parses a string of balanced brackets into an `Expr` value.

```haskell
parseExpression :: Parser Expr
parseExpression = undefined
```

You will likely need to define helper parsers for each bracket type (parentheses, square brackets, curly braces). These can be defined locally using `where`.

### Examples

```hs
ghci> parse parseExpression "()"
[(E [Paren (E [])],"")]

ghci> parse parseExpression "()[]{}"
[(E [Paren (E []),Bracket (E []),Brace (E [])],"")]

ghci> parse parseExpression "([{}])"
[(E [Paren (E [Bracket (E [Brace (E [])])])],"")]

ghci> parse parseExpression "(())[{}]"
[(E [Paren (E [Paren (E [])]),Bracket (E [Brace (E [])])],"")] 

ghci> parse parseExpression ""
[(E [],"")]

ghci> parse parseExpression "((("
[(E [],"(((")]
```

Note: an invalid or incomplete input does **not** cause a crash — the parser simply returns how far it got. In the last example, the parser successfully parses the empty expression `E []` and leaves `"((("` unconsumed.

### Hints

* Define a helper `parseToken :: Parser Token` that tries to parse a single `Paren`, `Bracket`, or `Brace` token using `<|>`.
* For each bracket type, use `do` notation to: consume the opening bracket with `char`, recursively parse the inner expression with `parseExpression`, consume the closing bracket, and return the appropriate `Token`.
* `parseExpression` itself should use `many parseToken` to parse zero or more tokens, then wrap them in `E`.
* The structure mirrors the grammar:
  ```
  expr  ::= token*
  token ::= '(' expr ')' | '[' expr ']' | '{' expr '}'
  ```
