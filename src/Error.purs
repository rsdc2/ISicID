module Error
  ( throwError
  )
  where

import Prelude
import Data.Either

throwError :: Int -> Either String Int
throwError i 
    | i < 5 = Left "Too low"
    | otherwise = Right i
