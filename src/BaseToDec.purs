module BaseToDec
  ( baseToDec
  )
  where

import Prelude

import Data.Array (findIndex)
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits (toCharArray)
import Types (Base)
import Utils (sum, powerUp, getBaseDigits)


getDecDigitOfBase :: Base -> Char -> Int
getDecDigitOfBase base x = case findIndex (\y -> y == x) (getBaseDigits base) of
    Nothing -> 0
    Just z -> z

getDecDigitsOfBase :: Base -> Array Char -> Array Int
getDecDigitsOfBase base chars = getDecDigitOfBase base <$> chars

baseToDec :: Base -> String -> Int
baseToDec base s = sum $ powerUp $ getDecDigitsOfBase base $ toCharArray s 