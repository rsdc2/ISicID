module DecToBase
  ( decDigits
  , decToBase
  , getBaseAsInt
  )
  where

import Prelude

import Data.Int as Int
import Data.Maybe (Maybe(..), maybe)
import Data.String.CodeUnits (fromCharArray)
import Types (Base(..))
import Utils (getItem, baseDigits)
import StringFormat (rjust)

getBaseAsInt :: Base -> Int
getBaseAsInt Hex = 16
getBaseAsInt Base52 = 52
getBaseAsInt Base87 = 87
getBaseAsInt _ = 10

lookupBaseDigit :: Base -> Int -> Char
lookupBaseDigit b i = case getItem i (baseDigits b) of
    Nothing -> '?'
    Just x -> x 

-- Decimal representation of the digit in Base x
decDigits :: Base -> Int -> Array Int
decDigits base dec =
    if q == 0 then [r] else
        if q < b then [q, r] else 
            (decDigits base q) <> [r]
    where b = getBaseAsInt base
          q = dec `div` b
          r = dec `mod` b

zeroDigit :: Base -> Char
zeroDigit base = lookupBaseDigit base 0

decToBase :: Base -> String -> String
decToBase base dec = rjust 5 (zeroDigit base)
                        $ fromCharArray 
                        $ lookupBaseDigit base 
                        <$> (decDigits base $ maybe 0 (\x -> x) (Int.fromString dec))

