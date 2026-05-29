import Types
import Tests
import Data.List

-- sophisticated expressions with extra task
-- inspired from the answer key


-- approach:
-- cover the most basic base cases first, in this case it is Val and Var.
-- from there build up to other cases that has the operations covered by the previous one. e.g. Plus and Times have cases covered by Val and Var.
-- Move on to more complex cases afterwards and so on...

eval :: Env -> Expr -> Maybe Value
eval _ (Val x) = Just x
eval env (Var nm) = env nm
eval env (Plus e e') = case (eval env e, eval env e') of
        (Just (IVal a), Just (IVal b)) -> Just (IVal (a + b))
        _ -> error "Type mismatch or inputted variable not defined in env. Please define the variable you passed and only use the IVars type."


eval env (Times e e') = case (eval env e, eval env e) of
        (Just (IVal a), Just (IVal b)) -> Just (IVal (a * b))
        _ -> error "Type mismatch or inputted variable not defined in env. Please define the variable you passed and only use the IVars type."

eval env (If e e' e'') = case eval env e of
        Just (BVal True) -> eval env e'
        Just (BVal False) -> eval env e''
        Just (IVal _) -> error "Error - If expression returned an IVal instead of BVal."
        _ -> Nothing

eval env (And e e') = case (eval env e, eval env e') of
        (Just (BVal True), Just (BVal True)) -> Just (BVal True)
        (Just (BVal False), _) -> Just (BVal False)
        (_, Just (BVal False)) -> Just (BVal False)
        (Just (IVal _), _) -> error "Unexpected Input in one or both expressions - Please only pass BVars."
        (_, Just (IVal _)) -> error "Unexpected Input in one or both expressions - Please only pass BVars."
        _ -> Nothing

eval env (Or e e') = case (eval env e, eval env e') of
        (Just (BVal False), Just (BVal False)) -> Just (BVal False)
        (Just (BVal True), _) -> Just (BVal True)
        (_, Just (BVal True)) -> Just (BVal True)
        (Just (IVal _), _) -> error "Unexpected Input in one or both expressions - Please only pass BVars."
        (_, Just (IVal _)) -> error "Unexpected Input in one or both expressions - Please only pass BVars."
        _ -> Nothing

eval env (Not e) = case eval env e of
    (Just (BVal True)) -> Just (BVal True)
    (Just (BVal False)) -> Just (BVal False)
    (Just (IVal _)) -> error "Unexpected Input - Please only pass BVars."
    _ -> Nothing

eval env (Lt e e') = case (eval env e, eval env e') of
    (Just (IVal a), Just (IVal b)) -> Just (BVal (a < b))
    (Just (BVal a), Just (BVal b)) -> Just (BVal (a < b))
    _ -> Nothing


fromJust :: Maybe Value -> Value
fromJust Nothing = undefined
fromJust (Just x) = x

-- cycle decomposition

-- using the "Worker Wrapper patter"
{--
Instead of passing 3 or 4 arguments into every recursive call, we use the Worker-Wrapper Pattern.

The Wrapper (cycleOf): 
This is the public-facing function. Its job is to handle the initial setup—it captures the "constant" variables (start and perm) and launches the recursion.

The Worker (go): 
This is the local helper defined in the where clause. Because it is defined inside the wrapper, it has access to the wrapper’s arguments via Lexical Scoping.
--}

cycleOf :: Int -> Perm -> [Int]
cycleOf start perm = start : go (perm !! start)
  where
    go current
      | current == start = []
      | otherwise        = current : go (perm !! current)

-- note: the results are sorted.
-- we do a brute force approach:
    -- get all possible cycles from 0 to length perm - 1
    -- sort all the elements of the result -> this will produce duplicates of the same cycle.
    -- pass the result into the removeDuplicates function which will return all the unique cycles, sorted.
    
cycles :: Perm -> [[Int]]
cycles [] = [[]]
cycles perm = removeDuplicates $ map sort [cycleOf i perm | i <- [0..length perm - 1]]

removeDuplicates :: Eq a => [a] -> [a]
removeDuplicates [] = []
removeDuplicates (x:xs) | x `elem` xs = removeDuplicates xs
                        | otherwise = x : removeDuplicates xs

