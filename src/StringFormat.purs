module StringFormat
  ( checkValidISicTokenID
  , checkValidCompressedForm
  , format
  , removeFormatting
  , rjust
  )
  where

import Data.Either (Either(..))
import Prelude

import Data.Array (take, drop)
import Data.String (length)
import Data.String.CodeUnits (fromCharArray, toCharArray)
import Data.String.Regex (Regex, parseFlags, regex, test)
import Utils (charToStr)

rjust :: Int -> Char -> String -> String
rjust i c s = 
    let l = length s 
    in if l == i then s else
        if l < i then rjust i c $ charToStr c <> s else
            s

format :: String -> String
format s = 
    let cs = toCharArray $ rjust 10 '0' s
    in "ISic" <> (fromCharArray $ take 6 cs <> ['-'] <> drop 6 cs)

removeFormatting :: String -> String
removeFormatting s = 
    let cs = toCharArray s
    in fromCharArray $ (take 6 $ drop 4 $ cs) <> (drop 11 cs) 

createRegex :: String -> Either String Regex
createRegex s = case regex s (parseFlags "g") of
    Left err -> Left err
    Right reg -> Right reg

checkValidISicTokenID :: String -> Either String Boolean
checkValidISicTokenID s = case createRegex "^ISic[0-9]{6}-[0-9]{4}$" of
    Left err -> Left err
    Right reg -> Right (test reg s)

checkValidCompressedForm :: String -> Either String Boolean
checkValidCompressedForm s = case createRegex "^[a-zA-Z]{5}$" of
    Left err -> Left err
    Right reg -> Right (test reg s)