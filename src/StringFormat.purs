module StringFormat
  ( checkBaseFormValidLength
  , checkDecBelowMax
  , checkValidCompressedForm
  , checkValidISicTokenID
  , format
  , removeFormatting
  , rjust
  )
  where

import Prelude

import Data.Array (take, drop)
import Data.Either (Either(..))
import Data.Int as Int
import Data.Maybe (Maybe(..))
import Data.String (length, replace, Pattern(..), Replacement(..))
import Data.String.CodeUnits (fromCharArray, toCharArray)
import Data.String.Regex (Regex, parseFlags, regex, test)
import Errors as Err
import Utils (charToStr)

rjust :: Int -> Char -> String -> String
rjust i c s = 
    let l = length s 
    in if l == i then s else
        if l < i then rjust i c $ charToStr c <> s else
            s

format :: String -> String
format s = 
    let cs = toCharArray $ rjust 11 '0' s
    in "ISic" <> (fromCharArray $ take 6 cs <> ['-'] <> drop 6 cs)

removeFormatting :: String -> String
removeFormatting = 
    replace (Pattern "ISic") (Replacement "") <<< replace (Pattern "-") (Replacement"")

createRegex :: String -> Either String Regex
createRegex s = case regex s (parseFlags "g") of
    Left err -> Left err
    Right reg -> Right reg

checkValidISicTokenID :: String -> Either String Boolean
checkValidISicTokenID s = case createRegex "^ISic[0-9]{6}-[0-9]{5}$" of
    Left err -> Left err
    Right reg -> Right (test reg s)

isicToInt :: String -> Maybe Int
isicToInt = Int.fromString <<< removeFormatting

checkDecBelowMax :: String -> Either String Boolean
checkDecBelowMax s = case isicToInt s of 
    Nothing -> Left "Could not convert to integer"
    Just i
        -- | i <= 5457149006 -> Right true
        | i <= 2147483647 -> Right true
        | otherwise -> Right false

checkBaseFormValidLength :: String -> Either String Boolean
checkBaseFormValidLength s 
    | length s == 5 = Right true
    | length s < 5 = Left Err.base52TooShortErr
    | length s > 5 = Left Err.base52TooLongErr
    | otherwise = Left "Error"

checkValidCompressedForm :: String -> Either String Boolean
checkValidCompressedForm s = case createRegex "^[a-zA-Z0-9ΓΔΘΛΞΠΣΦΨΩβδζηθλμνξπστφχψ]{5}$" of
    Left err -> Left err
    Right reg -> Right (test reg s)