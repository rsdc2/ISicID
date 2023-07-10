module Main where

import Prelude

import BaseToDec (baseToDec)
import DecToBase (decToBase)
import Effect.Console (log)
import Types (Base(..))

-- main = do
--   log ("The answer is " <> show answer)

main = do
  log ("The answer is " <> (show $ baseToDec Hex "AF"))
