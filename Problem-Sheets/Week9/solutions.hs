import Types
import Control.Monad.State
import Control.Monad.Except
import Control.Monad.Error.Class 
import Control.Monad.Writer

-- Computing Factorial with the State Monad --

-- Consider the following Java method:
{-- 
int fac (int n) {
  int y = 1;
  while (n > 1} {
   y = y * n;
   n--;
   }
  }
  return y;

--}

-- Write this as a Haskell function using the state monad:
facHelper :: Integer -> State Integer ()
facHelper 0 = pure ()
facHelper n = do
    modify (\y -> y * n)
    facHelper (n - 1)

factorial :: Integer -> Integer
factorial n = snd (runState (facHelper n) 1)

-- Monadic Calculator -- 

-- calculator expressions --
eval :: MonadError String m => CalcExpr -> m Int
eval (Val x) = pure x

eval (Add e e') = do
    v1 <- eval e
    v2 <- eval e'
    return (v1 + v2)

eval (Sub e e') = do
    v1 <- eval e
    v2 <- eval e'
    return (v1 - v2)

eval (Mult e e') = do
    v1 <- eval e
    v2 <- eval e' 
    return (v1 * v2)

eval (Div e e') = do
    v1 <- eval e
    v2 <- eval e'
    case v2 of 
        0 -> throwError ("Division by Zero")
        _ -> return (v1 `div` v2)


-- calculators with states --
run :: (MonadState Int m, MonadError String m) => CalcCmd -> m ()
run (StoreC n cs) = do
                modify(\x -> n)
                case cs of
                    EnterC -> return ()
                    _ -> run cs

run (AddC n cs) = do
            modify(\x -> x + n)
            case cs of
                EnterC -> return ()
                _ -> run cs

run (SubC n cs) = do
            modify(\x -> x - n)
            case cs of
                EnterC -> return ()
                _ -> run cs

run (MultC n cs) = do
            modify(\x -> x * n)
            case cs of
                EnterC -> return ()
                _ -> run cs 

run (DivC n cs) | n == 0 = throwError "Division by zero"
                | otherwise = do
                            modify(\x -> x `div` n)
                            case cs of 
                                EnterC -> return ()
                                _ -> run cs 

            
-- Using Monads to Manipulate Directories --

logTraverse :: Dir -> Writer [String] ()
logTraverse (File s1 s2) = do
                tell ["Passing file: " ++ show s1 ++ "with recipe: " ++ show s2]
                return ()

logTraverse (SubDir name subdirs) = do
                tell ["Entering directory: " ++ show name]
                mapM_ logTraverse subdirs
                tell ["Leaving directory: " ++ show name]
                return ()

countFiles :: Dir -> State Int ()
countFiles (File _ _) = do
                    modify(\x -> x + 1)
                    return ()

countFiles (SubDir _ subdirs) = do
                    mapM_ countFiles subdirs
                    return ()


-- Functors --
-- answered on Types.hs


