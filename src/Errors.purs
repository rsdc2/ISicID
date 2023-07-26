module Errors
  ( alreadyCompressedErr
  , alreadyDecompressedErr
  , base52TooLongErr
  , base52TooShortErr
  , iSicTooLargeErr
  , invalidISicIDErr
  , invalidISicIDFormatErr
  )
  where

iSicTooLargeErr :: String
iSicTooLargeErr = "I.Sicily ID too large. IDs after ISic038020-4031 cannot be converted."

alreadyDecompressedErr ∷ String
alreadyDecompressedErr = "This form is already decompressed."

alreadyCompressedErr ∷ String
alreadyCompressedErr = "This form is already compressed."

couldNotConvertIntErr :: String
couldNotConvertIntErr = "Could not convert integer."

invalidISicIDFormatErr ∷ String
invalidISicIDFormatErr = "Invalid ID format. ISicily token IDs should be of the format ISic012345-6789."

invalidISicIDErr :: String
invalidISicIDErr = "Invalid ID. Compressed IDs should be composed of either upper or lower case Roman characters, and be 5 characters in length."

base52TooShortErr :: String
base52TooShortErr = "Base 52 form is too short. Compressed IDs should be exactly 5 characters in length."

base52TooLongErr :: String
base52TooLongErr = "Base 52 form is too long. Compressed IDs should be exactly 5 characters in length."
