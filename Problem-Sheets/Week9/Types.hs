module Types where

import Control.Monad.State
import Control.Monad.Except
import Control.Monad.Error.Class 

data CalcExpr = Val Int
              | Add CalcExpr CalcExpr
              | Mult CalcExpr CalcExpr
              | Div CalcExpr CalcExpr
              | Sub CalcExpr CalcExpr

data CalcCmd = EnterC
             | StoreC Int CalcCmd
             | AddC Int CalcCmd
             | MultC Int CalcCmd
             | DivC Int CalcCmd
             | SubC Int CalcCmd

type CS a = StateT Int (Either String) a

expr1 = Mult (Add (Val 4) (Val 7)) (Div (Val 10) (Val 2))
expr2 = Sub (Val 10) (Div (Val 14) (Val 0))

cmd1 = StoreC 7 (AddC 14 (DivC 3 EnterC))
cmd2 = StoreC 10 (MultC 2 (DivC 0 EnterC))

data Dir = File String String
         | SubDir String [Dir]
         deriving Show

recipes :: Dir
recipes = SubDir "Recipes" [ SubDir "Tex-Mex" [ File "Tacos" "meat, cheese, tomato"
                                              , File "Burrito" "tortilla, rice, beans"
                                              ]
                           , SubDir "Italian" [ File "Pizza" "dough, sauce, pepperoni"
                                              , File "Bolognese" "pasta, ground beef, tomato sauce"
                                              ]
                           , SubDir "French"  [ File "Ratatouille" "tomato, bell peppers, eggplant"
                                              , File "Croque Monsieur" "toast, cheese, ham"
                                              ]
                           ]


-- Functors --
-- consider the data type:

data Bin a = Lf
           | Nd a (Bin a) (Bin a)

-- provide a functor for this data type
instance Functor Bin where
    fmap f (Nd x l r) = Nd (f x) (fmap f l) (fmap f r) 
    fmap f (Lf) = Lf

-- consider the following data type whch takes the "sum" of two constructors
data FSum f g a = FLeft (f a) | FRight (g a)
  deriving Show

-- Show that if both f and g are functors, then so is FSum f g.
instance (Functor f, Functor g) => Functor (FSum f g) where
    fmap f (FLeft x) = FLeft (fmap f x)
    fmap f (FRight x) = FRight (fmap f x)