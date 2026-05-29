module Types where 

data NumExpr a = Value a
            | FromInteger Integer
            | Negate (NumExpr a)
            | Abs (NumExpr a)
            | SigNum (NumExpr a)
            | Add (NumExpr a) (NumExpr a)
            | Mul (NumExpr a) (NumExpr a)

-- this was my brute force solution:
instance Show a => Show(NumExpr a) where
  show (Value x)       = show x
  show (FromInteger n) = "fromInteger(" ++ show n ++ ")"
  show (Negate e)      = "negate(" ++ show e  ++ ")"
  show (Abs e)         = "abs(" ++ show e ++ ")"        
  show (SigNum e)      = "signum(" ++ show e ++ ")"

  show (Add e e')      = show e ++ "+" ++ show e'
  show (Mul e e') = case e of
                        Add _ _ -> 
                            case e' of 
                                Add _ _ -> "(" ++ show e ++ ")" ++ "*" ++ "(" ++ show e' ++ ")"
                                _ -> "(" ++ show e ++ ")" ++ "*" ++ show e'
                        _ -> case e' of
                            Add _ _ -> show e ++ "*" ++ "(" ++ show e' ++ ")"
                            _ -> show e ++ "*" ++ show e'

-- a better solution provided by the answer key:

-- show1 :: Show a => NumExpr a -> String
-- show1 (Add e e') = show1 e ++ "+" ++ show e' -- this is the same as my solution. For 'Add' expressions, we remove the outer brackets.
-- show1 e = show2 e -- otherwise, we go to the show2 function

-- show2 :: Show a => NumExpr a -> String
-- show2 (Mul e e') = show2 e ++ "*" ++ show2 e' -- if it is a Mul expression, we recursively do show2 on the internal expressions.
-- show2 e = show3 e -- this is the function that the expressions will be passed into if it is not Mul

-- -- for the rest of the expressions, we do not change anything
-- show3 :: Show a => NumExpr a -> String
-- show3 (Value x) = show x
-- show3 (FromInteger n) = "fromInteger(" ++ show n ++ ")"
-- show3 (Negate e) = "negate(" ++ show e ++ ")"
-- show3 (Abs e) = "abs(" ++ show e ++ ")"
-- show3 (SigNum e) = "signum(" ++ show e ++ ")"
-- show3 e = "(" ++ show1 e ++ ")" -- otherwise, we go back the show1.

-- -- conclusion: this is a more structured approach of my solution as well.
-- -- rather than using case of's like what I did above, this approach splits the function into three: for Add, Mul, and the rest of the expressions.
-- -- this allows us to separate the logic for each type of expression and avoid conflicts. 
-- -- It is essentially the same as the brute force solution, but way more structured. 

-- instance Show a => Show (NumExpr a) where
--     show = show1

-- Expressions in an Environment
data Value = BVal Bool
           | IVal Int
           deriving (Show,Eq)

data Expr = Val Value 
          | Var String
          | Plus Expr Expr
          | Times Expr Expr 
          | If Expr Expr Expr 
          | And Expr Expr
          | Or Expr Expr
          | Not Expr 
          | Lt Expr Expr
          deriving (Show,Eq)


-- the env type is used to store values into variables (e.g. x = 14 hence bind (bind emptyEnv (IVal 14) "x"))
type Env = String -> Maybe Value
           
emptyEnv :: Env
emptyEnv _ = Nothing 

bind :: Env -> String -> Value -> Env 
bind env nm v nm' | nm == nm' = Just v
bind env nm v nm' | otherwise = env nm' 

lookupEnv :: Env -> String -> Maybe Value
lookupEnv env nm = env nm 

type Perm = [Int] 

isPerm :: [Int] -> Bool
isPerm ns = and [ elem k ns | k <- [0..length ns -1] ]
