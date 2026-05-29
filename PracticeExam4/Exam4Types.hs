module Exam4Types where

import Control.Monad.State

-- Question 1: FileSystem
data FileSystem = File String Int
                | Dir String [FileSystem]
                deriving (Show, Eq)

-- Question 3: Robot State
data Direction = North | East | South | West
  deriving (Eq, Show, Enum)

type Position = (Int, Int)
type RobotState = (Position, Direction)
type Robot a = State RobotState a

data Command = TurnLeft | TurnRight | Forward Int
  deriving (Eq, Show)

-- Question 5: JSON
data JSON = JNull
          | JBool Bool
          | JNum Int
          | JStr String
          | JArr [JSON]
          | JObj [(String, JSON)]
          deriving (Eq, Show)
