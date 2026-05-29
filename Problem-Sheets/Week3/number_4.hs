{-# Language FlexibleInstances #-}
{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

type Nat = [()]

natZero :: Nat
natZero = []

natOne :: Nat
natOne = [()]

natPlus :: Nat -> Nat -> Nat
natPlus [] y = y
natPlus (():x) y = ():(natPlus x y)

natMinus :: Nat -> Nat -> Nat
natMinus x [] = x
natMinus [] y = []
natMinus (():x) (():y) = natMinus x y

natTimes :: Nat -> Nat -> Nat
natTimes x [] = []
natTimes x (():y) = natPlus x (natTimes x y)

natFromInteger :: Integer -> Nat
natFromInteger n | n <= 0 = []
                  | otherwise = ():natFromInteger(n-1)

integerFromNat :: Nat -> Int
integerFromNat [] = 0
integerFromNat n = length n

instance Num Nat where
  (+) = natPlus
  (-) = natMinus
  (*) = natTimes
  signum _ = natOne
  abs n = n
  fromInteger = natFromInteger

  

  