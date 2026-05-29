import Control.Monad.State
import Control.Monad.Except
import Types

facHelper :: Integer -> State Integer ()
facHelper 0 = pure ()
facHelper n = do
            modify(\y -> y * n)
            facHelper(n-1)

factorial :: Integer -> Integer
factorial n = snd (runState (facHelper n) 1)

eval :: MonadError String m => CalcExpr -> m Int
eval (Val n) = pure n
eval (Add e e') = do
                v1 <- eval e
                v2 <- eval e'
                return (v1 + v2)
eval (Div e e') = do
                v1 <- eval e
                v2 <- eval e'
                case v2 of
                    0 -> throwError "Division by Zero"
                    _ -> return (v1 `div` v2)

run :: (MonadState Int m, MonadError String m) => CalcCmd -> m ()
run EnterC = return ()
run (StoreC n cmd) = do 
                    put n
                    run (cmd)
run (AddC n cmd) = do
                modify(\x -> x + n)
                run (cmd)
run (SubC n cmd) = do
                modify(\x -> x - n)
                run (cmd)
run (DivC n cmd) = do
                case n of
                    0 -> throwError "Division by Zero"
                    _ -> modify(\x -> x `div` n)
                         run (cmd)