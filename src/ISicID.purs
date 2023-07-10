module ISicID
  ( answer
  , decDigits
  , getItem
  )
  where

import Prelude
import Data.Array (intercalate)
import Data.Array ((!!), (..))
import Data.Maybe (maybe, Maybe(..), isNothing)

digits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] <> ['A', 'B', 'C', 'D', 'E', 'F']

getItem :: Int -> Array Char -> Maybe Char
getItem i xs = xs !! i 

lookup :: Int -> Char
lookup i = case getItem i digits of
    Nothing -> 'X'
    Just x -> x 

decDigits :: Int -> Int -> Array Int
decDigits dec base = 
    let q = dec `div` base
        r = dec `mod` base
    in (if q < base then [q] else decDigits q base) <> [r]

answer = intercalate " " $ show <$> lookup <$> decDigits 10 16

