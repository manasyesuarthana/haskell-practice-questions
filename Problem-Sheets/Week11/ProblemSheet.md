# Problem Sheet for Week 11

# Different representation of the tictactoe board

In the [Unbeatable tictactoe lecture notes](https://git.cs.bham.ac.uk/fp/fp-learning-2025/-/blob/main/files/LectureNotes/Sections/tictactoe.md), you find the following definitions:
```haskell
size :: Int
size = 3

type Grid = [[Player]]
```
In this exercise we restrict ourselves to the traditional 3x3 tictactoe, with the following moves:
```
             0 | 1 | 2
            ---+---+---
             3 | 4 | 5
            ---+---+---
             6 | 7 | 8
```
We represent a board by a pair of two lists, for the moves of players
O and X respectively. So we replace the above code by the following:
```haskell
type Move = Int

type Grid = ([Move],[Move])
```
You objective is to modify the tictactoe code to work with this representation. Work with a **copy** of the [Week11-template.hs](Week11-template.hs) file, e.g. `Week11.hs`.

You can test this exercise by running the functions `run` and `play` after you finish, and playing tictactoe against yourself and the computer respectively.

## Variation of tictactoe

Write a modified version of tictactoe, in which the objective is to
force the opponent to make a row, column or diagonal. For this, create
variations of he function `play`, `bestmove` etc. You can do this in
the same file, but this time we are not giving you function templates
to complete. You have to come up with them yourself.