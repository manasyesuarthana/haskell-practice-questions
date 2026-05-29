module Tests where

import Types

ex1, ex2, ex3, ex4 :: NumExpr Int

ex1 = Abs $ Add (FromInteger 6) (Value 9)

ex2 = Add (Add (Value 4) (Value 5)) (Add (Value 6) (Value 7)) 

ex3 = Mul (Add (Value 4) (Value 5)) (Add (Value 6) (Value 7)) 

ex4 = Add (Mul (Value 4) (Value 5)) (Add (Value 6) (Value 7)) 

-- more test cases I added:

t1, t2, t3, t4, t5, t6, t7, t8 :: NumExpr Int

t1 = Add (Value 1) (Mul (Value 2) (Value 3))

t2 = Mul (Add (Value 1) (Value 2)) (Value 3)

t3 = Add (Add (Value 1) (Value 2)) (Value 3)

t4 = Mul (Value 1) (Mul (Value 2) (Value 3))

t5 = Negate (Add (Value 5) (Value 2))

t6 = Add (Abs (Value (-1))) (Value 1)

t7 = Mul (Negate (Value 2)) (Negate (Value 3))

t8 = Mul (Value 2) (Add (Value 3) (Mul (Value 4) (Value 5)))

t9 = Mul (Value 2) (Negate (Add (Value 3) (Value 4)))

-- sophisticated expressions

exprEx :: Expr
exprEx = If (Lt (Var "x") (Val $ IVal 7)) (Plus (Var "x") (Val $ IVal 14)) (Val $ IVal 0) 

-- cycle decomposition

p :: Perm
p = [5,2,4,0,1,3]

q :: Perm
q = [7,3,2,0,8,9,1,4,6,5]

r :: [Int]
r = [0,3,2] 