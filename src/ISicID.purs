module ISicID
  ( answer
  , decDigits
  , digitsUcase
  , getItem
  , Base (..)
  )
  where

import Prelude
import Data.Array ((!!), (..), (:), intercalate, singleton, head, findIndex, length, uncons, foldr, foldl)
import Data.Int (pow)
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
decToBase base dec = fromCharArray $ lookupBaseDigit base <$> decDigits base dec

-- unsafeHead :: Array a -> a
-- unsafeHead x:xs = x

-- baseToDecRec :: Array Char -> Int
-- baseToDecRec [] = 0
-- baseToDecRec as = case uncons as of
--     Just { head: x, tail: [] } -> 
--         case findIndex (\y -> y == x) hexDigits of
--             Nothing -> 1000000000
--             Just dec -> dec
--     Just { head: x, tail: xs } -> 
--         case findIndex (\y -> y == x) hexDigits of
--             Nothing -> 1000000000
--             Just dec -> pow (length xs) dec + (baseToDecRec xs)
--     Nothing -> 0


-- getDecDigitOfHex :: Char -> Int
-- getDecDigitOfHex x = case findIndex (\y -> y == x) hexDigits of
--     Nothing -> 0
--     Just z -> z

getDecDigitOfBase :: Base -> Char -> Int
getDecDigitOfBase base x = case findIndex (\y -> y == x) (getBaseDigits base) of
    Nothing -> 0
    Just z -> z

getDecDigitsOfBase :: Base -> Array Char -> Array Int
getDecDigitsOfBase base chars = getDecDigitOfBase base <$> chars

baseToDec :: Base -> Array Char -> Int
baseToDec base chars = sum $ powerUp $ getDecDigitsOfBase base chars 

powerUp :: Array Int -> Array Int
powerUp as = case uncons as of
    Just { head:x, tail:[] } -> [x]
    Just { head:x, tail:xs } -> [x * pow 16 (length xs)] <> powerUp xs
    Nothing -> [0]

sum :: Array Int -> Int
sum xs = foldr (+) 0 xs

-- hexToDec :: String -> String
-- hexToDec s = show $ baseToDecRec $ toCharArray s


-- answer = decToBase Hex 33
answer = show $ baseToDec Base52 ['C', 'D', '1']
-- answer = show $ pow 2 <$> findIndex (\x -> x=='A') hexDigits
