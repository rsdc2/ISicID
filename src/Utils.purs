module Utils
  ( base52Digits
  , baseAsDec
  , charToStr
  , digits0to9
  , digitsLcase
  , digitsUcase
  , getBaseDigits
  , getItem
  , hexDigits
  , sum
  , upper
  )
  where

import Prelude

import Data.Array (foldr, (!!), head, uncons, length)
import Data.Int (pow)
import Data.Maybe (Maybe(..))
import Data.String (toUpper)
import Data.String.CodeUnits (fromCharArray, toCharArray)
import Types (Base(..))


digits0to9 ∷ Array Char
digits0to9 = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

digitsLcase ∷ Array Char
digitsLcase = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

digitsUcase ∷ Array Char
digitsUcase = upper <$> digitsLcase

hexDigits ∷ Array Char
hexDigits = digits0to9 <> ['A', 'B', 'C', 'D', 'E', 'F']

base52Digits ∷ Array Char
base52Digits = digitsUcase <> digitsLcase

sum :: Array Int -> Int
sum xs = foldr (+) 0 xs

getItem :: Int -> Array Char -> Maybe Char
getItem i xs = xs !! i 

charToStr :: Char -> String
charToStr c = fromCharArray [c]

upper :: Char -> Char
upper c = case head $ toCharArray $ toUpper $ charToStr c of
    Just x -> x
    Nothing -> '?'

getBaseDigits :: Base -> Array Char
getBaseDigits Hex = hexDigits
getBaseDigits Base52 = base52Digits
getBaseDigits _ = digits0to9

baseAsDec :: Base -> Int
baseAsDec Hex = 16
baseAsDec Base52 = 52
baseAsDec _ = 10