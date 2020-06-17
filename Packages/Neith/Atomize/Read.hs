module Main where

import Data.Text.IO
import Prelude hiding (readFile, writeFile)
import qualified Data.Text as T
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  file <- readFile 
