module DecToBase where

import Prelude

import Data.Int (fromString)
import Data.Maybe (Maybe(..), maybe)
import Data.String.CodeUnits (fromCharArray)
import Types (Base(..))
import Utils (getItem, getBaseDigits)

getBaseAsInt :: Base -> Int
getBaseAsInt Hex = 16
getBaseAsInt Base52 = 52
getBaseAsInt _ = 10

lookupBaseDigit :: Base -> Int -> Char
lookupBaseDigit b i = case getItem i (getBaseDigits b) of
    Nothing -> '-'
    Just x -> x 

decDigits :: Base -> Int -> Array Int
-- Decimal representation of the digit in Base x
decDigits base dec =
    if q == 0 then [r] else
        if q < b then [q, r] else 
            (decDigits base q) <> [r]
    where b = getBaseAsInt base
          q = dec `div` b
          r = dec `mod` b

decToBase :: Base -> String -> String
decToBase base dec = fromCharArray $ lookupBaseDigit base <$> (decDigits base $ maybe 0 (\x -> x) (fromString dec))