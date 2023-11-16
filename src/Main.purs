module Main (main)
  where

import Prelude

import BaseToDec (baseToDec)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import DecToBase (decToBase)
import Effect (Effect)
import Effect.Console (log)
import Effect.Exception (error, throw, throwException)
import Errors as Err
import StringFormat (checkBase52ValidLength, checkDecBelowMax, checkValidCompressedForm, checkValidISicTokenID, format, removeFormatting)
import Types (Base(..))
import Web.DOM (Document, NonElementParentNode)
import Web.DOM.Document (toNonElementParentNode)
import Web.DOM.Element as Element
import Web.DOM.Node (setTextContent)
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.Event (EventType(..))
import Web.Event.EventTarget (EventTarget, addEventListener, eventListener)
import Web.Event.Internal.Types (Event)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement (toEventTarget)
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.HTMLInputElement as HTMLInputElement
import Web.HTML.Window (document)


click :: EventType
click = EventType "click"

windowDoc :: Effect HTMLDocument.HTMLDocument
windowDoc = document =<< window

doc :: Effect Document
doc = do 
  d <- windowDoc
  pure $ HTMLDocument.toDocument d

docAsNode :: Effect NonElementParentNode
docAsNode = do
  d <- doc
  pure $ toNonElementParentNode d

textInput :: Effect Element.Element
textInput = getElem "text-input"

getElem :: String -> Effect Element.Element
getElem id = do
  docNode <- docAsNode
  elem <- getElementById id docNode
  case elem of 
    Nothing -> throwException $ error ("Did not find node" <> id)
    Just x -> pure x

compressButton :: Effect Element.Element
compressButton = getElem "compress-btn"

decompressButton :: Effect Element.Element
decompressButton = getElem "decompress-btn"

showValue :: (String -> String) -> String -> Effect Unit
showValue f s = log $ f s

showValue' :: (String -> String) -> String -> Effect Unit
showValue' f s = do
  outputElem <- getElem "result"
  setElemTextContent (f s) outputElem

showValueEvent :: (String -> String) -> Element.Element -> Event -> Effect Unit
showValueEvent f elem _ = do
  s <- getInputValue elem
  showValue' f s

decompressID :: String -> String
decompressID s = case checkValidISicTokenID s of
  Right true -> Err.alreadyDecompressedErr
  _ -> case checkBase52ValidLength s of
    Left err -> err
    Right true -> case checkValidCompressedForm s of
      Left err -> err
      Right true -> convertToISic s
      Right false -> Err.invalidISicIDErr
    Right false -> "Error"
  
compressID :: String -> String
compressID s = case checkValidCompressedForm s of
  Right true -> Err.alreadyCompressedErr
  _ -> case checkValidISicTokenID s of
    Left err -> err
    Right true -> case checkDecBelowMax s of
      Left err -> err
      Right true -> convertToBase52 s
      Right false -> Err.iSicTooLargeErr
    Right false -> Err.invalidISicIDFormatErr

convertToBase52 :: String -> String
convertToBase52 = decToBase Base52 <<< removeFormatting

convertToISic :: String -> String
convertToISic = format <<< show <<< baseToDec Base52

getInputValue :: Element.Element -> Effect String
getInputValue x = 
  let elem = HTMLInputElement.fromElement x
  in case elem of
    Nothing -> pure $ "Could not make HTMLInputElement from element"
    Just htmlinputelem -> HTMLInputElement.value htmlinputelem

setInputValue :: String -> Element.Element -> Effect Unit
setInputValue s elem = case HTMLInputElement.fromElement elem of
  Nothing -> throw "Could not make HTMLInputElement from element"
  Just htmlinputelem -> HTMLInputElement.setValue s htmlinputelem

setElemTextContent :: String -> Element.Element -> Effect Unit
setElemTextContent s elem = 
  let node = Element.toNode elem
  in setTextContent s node

createEventTarget' :: Element.Element -> Maybe EventTarget
createEventTarget' elem = do
  htmlelem <- HTMLElement.fromElement elem
  pure $ toEventTarget htmlelem

createEventTarget :: Element.Element -> Effect EventTarget
createEventTarget elem = case createEventTarget' elem of 
    Nothing -> throw "Could not create event target"
    Just x -> pure $ x

main :: Effect Unit
main = do
  inputVal <- textInput
  compressListener <- eventListener $ showValueEvent compressID inputVal
  decompressListener <- eventListener $ showValueEvent decompressID inputVal

  compressEventTarget <- createEventTarget =<< compressButton
  decompressEventTarget <- createEventTarget =<< decompressButton
  
  addEventListener click compressListener false compressEventTarget 
  addEventListener click decompressListener false decompressEventTarget 