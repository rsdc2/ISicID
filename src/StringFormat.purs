module StringFormat
  ( format
  , removeFormatting
  , rjust
  )
  where

import Data.Either
import Effect.Exception
import Prelude

import Data.Array (take, drop)
import Data.String (length)
import Data.String.CodeUnits (fromCharArray, toCharArray)
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
-- $ take 4 $ drop 1 $ take 6 $ drop 4 $ 