module BaseToDec
  ( baseToDec )
  where

import Prelude

import Data.Array (findIndex, uncons, length)
import Data.Int (pow)
import Data.Maybe (Maybe(..))
import Data.String.CodeUnits (toCharArray)
import Types (Base)
import Utils (baseAsDec, baseDigits, sum)

powerUp :: Base -> Array Int -> Array Int
powerUp base as = case uncons as of
    Just { head:x, tail:[] } -> [x]
    Just { head:x, tail:xs } -> [x * pow (baseAsDec base) (length xs)] <> powerUp base xs
    Nothing -> [0]

getDecDigitOfBase :: Base -> Char -> Int
getDecDigitOfBase base x = case findIndex (\y -> y == x) (baseDigits base) of
    Nothing -> 0
    Just z -> z

getDecDigitsOfBase :: Base -> Array Char -> Array Int
getDecDigitsOfBase base chars = getDecDigitOfBase base <$> chars

baseToDec :: Base -> String -> Int
baseToDec base s = sum
                    $ powerUp base
                    $ getDecDigitsOfBase base
                    $ toCharArray s 