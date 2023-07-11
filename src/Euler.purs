-- Taken from https://github.com/purescript/documentation/blob/master/guides/Getting-Started.md, last accessed 2023-07-11

module Euler where

import Prelude

import Data.List (range, filter)
import Data.Foldable (sum)

ns = range 0 999

multiples = filter (\n -> mod n 3 == 0 || mod n 5 == 0) ns

answer = sum multiples