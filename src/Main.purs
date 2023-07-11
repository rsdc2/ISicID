module Main
  ( createEventTarget
  , getInputValue
  , main
  , setInputValue
  , showValue
  )
  where

import Prelude

import BaseToDec (baseToDec)
import Data.Array.NonEmpty (elem)
import Data.Either (Either(..))
import Data.Foldable (traverse_)
import Data.Int (fromStringAs)
import Data.Maybe (Maybe(..))
import Data.Maybe (maybe)
import DecToBase (decToBase)
import Effect (Effect(..))
import Effect.Console (log)
import Effect.Exception (error, throw, throwException, try)
import Error (throwError)
import StringFormat (format, removeFormatting)
import Types (Base(..))
import Web.DOM (Document, Node, NonElementParentNode)
import Web.DOM.Document (createElement, doctype, toNonElementParentNode)
import Web.DOM.Element as Element
import Web.DOM.Node (appendChild, setTextContent, textContent)
import Web.DOM.NonElementParentNode (getElementById)
import Web.Event.Event (EventType(..))
import Web.Event.EventTarget (EventTarget, addEventListener, eventListener)
import Web.Event.Internal.Types (Event)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.HTMLElement (fromElement, tabIndex, toEventTarget)
import Web.HTML.HTMLElement as HTMLElement
import Web.HTML.HTMLInputElement as HTMLInputElement
import Web.HTML.Window (document)

click :: EventType
click = EventType "click"

htmlDoc :: Effect HTMLDocument.HTMLDocument
htmlDoc = document =<< window

doc :: Effect Document
doc = do 
  d <- htmlDoc
  pure $ HTMLDocument.toDocument d

docAsNode :: Effect NonElementParentNode
docAsNode = do
  d <- doc
  log "got doc"
  pure $ toNonElementParentNode d

textInput :: Effect Element.Element
textInput = do 
  log ("textInput")
  getElem "input" "text-input"

getElem :: String -> String -> Effect Element.Element
getElem t id = do
  docNode <- docAsNode
  elem <- getElementById id docNode
  case elem of 
    Nothing -> throwException $ error ("Did not find node" <> id)
    Just x -> pure x

getElem' :: String -> String -> Effect (Either String Element.Element)
getElem' t id = do
  docNode <- docAsNode
  getElementById' id docNode

getElementById' :: String -> NonElementParentNode -> Effect (Either String Element.Element)
getElementById' id docNode = do
  result <- getElementById id docNode
  case result of 
    Nothing -> pure $ Left "Error"
    Just x -> pure $ Right x

createElem :: String -> Effect Element.Element
createElem t = do
  d <- doc
  createElement t d

compressButton :: Effect Element.Element
compressButton = do
  log "compressButton" 
  getElem "button" "compress-btn"

compressButton' :: Effect (Maybe Element.Element)
compressButton' = getElementById "compress-btn" =<< docAsNode

decompressButton :: Effect Element.Element
decompressButton = do
  log "decompressButton" 
  getElem "button" "decompress-btn"

showValue :: (String -> String) -> String -> Effect Unit
showValue f s = do 
  log "showValue"
  log $ f s

showValueEvent :: (String -> String) -> Element.Element -> Event -> Effect Unit
showValueEvent f el _ = do
  log ("Showing event")
  s <- getInputValue el
  showValue f s

decompressID :: String -> String
decompressID s = format <<< show <<< baseToDec Base52 $ s

compressID :: String -> String
compressID s = decToBase Base52 $ removeFormatting s
-- compressID s = removeFormatting s

getInputValue :: Element.Element -> Effect String
getInputValue x = 
  let elem = HTMLInputElement.fromElement x
  in case elem of
    Nothing -> pure $ "Error"
    Just htmlinputelem -> HTMLInputElement.value htmlinputelem

setInputValue :: String -> Element.Element -> Effect Unit
setInputValue s elem = case HTMLInputElement.fromElement elem of
  Nothing -> throw "error"
  Just htmlinputelem -> HTMLInputElement.setValue s htmlinputelem

createEventTarget :: Element.Element -> Maybe EventTarget
createEventTarget elem = do
  htmlelem <- HTMLElement.fromElement elem
  pure $ toEventTarget htmlelem

logClick :: Event -> Effect Unit
logClick _ = log "button clicked"

main :: Effect Unit
main = do
  -- htmlDoc <- document =<< window
  -- body <- maybe (throw "Could not find body element") pure =<< HTMLDocument.body htmlDoc
  -- let
  --   doc = HTMLDocument.toDocument htmlDoc

  -- -- Create DOM elements
  -- divElem <- createElement "div" doc
  -- h1Elem <- createElement "h1" doc
  -- inputElem <- createElement "input" doc
  -- pElem <- createElement "p" doc
  -- compressElem <- createElement "button" doc
  -- decompressElem <- createElement "button" doc

  -- -- Convert DOM (or HTML) elements to DOM nodes
  -- let
  --   bodyNode = HTMLElement.toNode body
  --   divNode = Element.toNode divElem
  --   h1Node = Element.toNode h1Elem
  --   inputNode = Element.toNode inputElem
  --   pNode = Element.toNode pElem
  --   compressNode = Element.toNode compressElem
  --   decompressNode = Element.toNode decompressElem

  -- -- Fill in some contents
  -- setTextContent "Enter I.Sicily ID" h1Node
  -- setTextContent "Compress" compressNode
  -- setTextContent "Decompress" decompressNode

  -- -- Define structure in DOM
  -- appendChild divNode bodyNode
  -- appendChild h1Node divNode
  -- appendChild inputNode divNode
  -- appendChild compressNode divNode
  -- appendChild decompressNode divNode
  -- appendChild pNode divNode
  ti <- textInput

  let compressEv = showValueEvent compressID ti
  let decompressEv = showValueEvent decompressID ti
  compressListener <- eventListener compressEv
  decompressListener <- eventListener decompressEv

  logclickListener <- eventListener logClick

  compressButton' <- compressButton
  decompressButton' <- decompressButton

  compressEventTarget <- case createEventTarget compressButton' of 
    Nothing -> throw "Could not create event target"
    Just x -> pure $ x

  decompressEventTarget <- case createEventTarget decompressButton' of 
    Nothing -> throw "Could not create event target"
    Just x -> pure $ x
  
  addEventListener click compressListener true compressEventTarget 
  addEventListener click decompressListener true decompressEventTarget 

