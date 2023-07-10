module ISicID
  ( answer
  , decDigits
  , digitsUcase
  , getItem
  , Base (..)
  )
  where

import Prelude
import Data.Array ((!!), (..), intercalate, singleton, head)
import Data.Maybe (maybe, Maybe(..), isNothing)
import Data.String (toUpper)
import Data.String.CodeUnits (fromCharArray, toCharArray)


digits0to9 = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

digitsLcase = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
digitsUcase = upper <$> digitsLcase

hexDigits = digits0to9 <> ['A', 'B', 'C', 'D', 'E', 'F']
base52Digits = digitsLcase <> digitsUcase


data Base = 
      Hex
    | Base52
    | Dec

upper :: Char -> Char
upper c = case head $ toCharArray $ toUpper $ fromCharArray [c] of
    Just x -> x
    Nothing -> '-'

getItem :: Int -> Array Char -> Maybe Char
getItem i xs = xs !! i 

getBaseDigits :: Base -> Array Char
getBaseDigits Hex = hexDigits
getBaseDigits Base52 = base52Digits
getBaseDigits _ = digits0to9

getBaseAsInt :: Base -> Int
getBaseAsInt Hex = 16
getBaseAsInt Base52 = 52
getBaseAsInt _ = 10

lookupBaseDigit :: Base -> Int -> Char
lookupBaseDigit b i = case getItem i (getBaseDigits b) of
    Nothing -> '-'
    Just x -> x 

-- decDigits :: Base -> Int -> Array Int
-- decDigits base dec 
--     | q == 0 = [r]
--     | q < b = [q, r]
--     | otherwise = (decDigits base q) <> [r]
--     where b = getBaseAsInt base
--           q = dec `div` b
--           r = dec `mod` b

decDigits :: Base -> Int -> Array Int
decDigits base dec =
    if q == 0 then [r] else
        if q < b then [q, r] else 
            (decDigits base q) <> [r]
    where b = getBaseAsInt base
          q = dec `div` b
          r = dec `mod` b

decToBase :: Base -> Int -> String
decToBase base dec = fromCharArray $ (lookupBaseDigit base <$> decDigits base dec)

answer = decToBase Hex 33
