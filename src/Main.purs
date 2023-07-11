module Main where

import Prelude

import BaseToDec (baseToDec)
import DecToBase (decToBase)
import Effect.Console (log)
import StringFormat (format)
import Types (Base(..))

-- main = do
--   log ("The answer is " <> show answer)

main = do
  -- log ("The answer is " <> (show $ baseToDec Base52 "AF"))
  -- log ("The answer is " <> decToBase Base52 10010)
  log ("The answer is " <> (format <<< show $ baseToDec Base52 "zzzzz"))
