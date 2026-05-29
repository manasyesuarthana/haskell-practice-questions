import Control.Monad.State
-- notes about monads.
-- based on: https://www.adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html
-- Functors
-- Functors are basically a wrapper type that will be used by fmap
-- for example, Maybe is a functor because when we run:
-- fmap (+4) Just 5, it results in Just 9
-- In this case, fmap applies the (+4) function to the value inside of the Maybe Functor.
-- We can also do this with lists -- it is also a functor!
-- fmap (+4) [4] == [8]
-- Functions are also functors: we can combine functions
-- foo = fmap (+4) (+9) is the same as foo = (+4) $ (+9) 4
-- <$> is just an infix version of the functor, so we can write the statements above as:
    -- (+4) <$> Just 5 == Just 9
    -- (+4) <$> [4] == [8]
    -- (+4) <$> (+9) == (+4) $ (+9)

-- Applicatives
-- Applicatives takes functors to the next level.
-- In addition to values, applicatives also does the same thing to wrapped functions.
-- It applies the wrapped function to the wrapped value. But keep in mind, it has to be in the same wrapped type.
-- the <*> function is an infix operator that allows us to do this
-- For example:
    -- Just (+4) <*> Just 5 == Just 9


-- Monads
-- These allows us to pass a wrapped function to a function that returns a wrapped value of the same type
-- for example:
maybeHead :: [a] -> Maybe [a]
maybeHead [] = Nothing
maybeHead (x:xs) = Just [x]

-- we can pass a list [1..n] as usual, but what if the list is wrapped in a context like Just?
-- e.g. maybeHead $ Just [1.5] -> normally this would result in an error due to mismatched types.
-- However, with monads, we fix that and automatically parses the value inside of the context to the function:
-- Just [1..5] >>= maybeHead == [1]
-- The '>>=' (bind) operator takes the value inside of the context, and passes it to the function that returns the same context type.

-- class Functor f where
--  fmap :: (a -> b) -> f a -> f b

-- class Functor f => Applicative f where
--  pure  :: a -> f a
--  (<*>) :: f (a -> b) -> f a -> f b

-- class Applicative m => Monad m where
--  return :: a -> m a
--  (>>=)  :: m a -> (a -> m b) -> m b

--  return = pure


-- More monads:
-- The writer monad
-- The state monad
greeter :: State String String
greeter = do
    name <- get -- get the current state
    put "tungtungtung sahur"
    return ("hello, " ++ name ++ "!")


-- monadic fibbonaci function
fibM :: Monad m => Integer -> m Integer
fibM 0 = return 0
fibM 1 = return 1
fibM n  = do
        x <- fibM (n-1)
        y <- fibM (n-2)
        return (x + y)

-- fibM n :: Maybe -> turns this into Maybe Integer
-- fibM n :: [Integer] -> turns this into a List type integer.




