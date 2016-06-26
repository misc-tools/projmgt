{-# LANGUAGE OverloadedStrings #-}

module Main where

import Turtle 
import Turtle.Format
import qualified Control.Foldl as Fold 
import System.Console.ANSI
import qualified Filesystem.Path as Path

projectsDir = "/home/vietnguyen/projects"

type ProjectName = Text
type OrgName = Text

-- | List all organizations 
printOrgs :: IO ()
printOrgs = do
  putStrLn "===\n Current Organizations:"
  view $ getName . toText . filename <$> (ls projectsDir)
  putStrLn "==="

printProjects :: IO ()
printProjects = do
  putStrLn "===\nCurrent projects"
  sh (do 

       org <- ls projectsDir
       liftIO (putStrLn "---")
       liftIO (print $ format fp (filename org))
       liftIO (putStrLn "---")
       liftIO (view (listProjects org))
     )
  putStrLn "==="

getName :: Either Text Text -> Text
getName (Left a) = ""
getName (Right s) = s
        
-- | List all projects belonging to an organization
listProjects :: Path.FilePath -> Shell ProjectName
listProjects orgFilePath = getName . toText . filename <$> (ls orgFilePath)

findOrgs :: Shell Text 
findOrgs = grep (noneOf ".") (format fp <$> (ls projectsDir))

-- | Filter any files in the root project folder 
findInfantFiles :: Shell Text 
findInfantFiles = grep (has ".")  (format fp <$> (ls projectsDir))

checkInfantFiles :: IO () 
checkInfantFiles = do 
  putStrLn "===\nCheck if there is any file in the root project folder: " 
  n <- fold findInfantFiles Fold.length
  if n == 0 then do
              setSGR [SetColor Foreground Vivid Green]              
              putStrLn "No file!"
              setSGR [Reset]
  else do 
    setSGR [SetColor Foreground Vivid Red]
    putStrLn "File(s): "           
    stdout findInfantFiles
    putStrLn "Need to remove these files!" 
    setSGR [Reset]
    removeInfantFiles
    putStrLn "Files removed."
  putStrLn "==="
    
removeInfantFiles :: IO ()
removeInfantFiles = sh (do 
                         infantFile <- findInfantFiles
                         liftIO (rm $ fromText infantFile)
                       )


main :: IO ()
main = do 
  checkInfantFiles
  printOrgs
  printProjects
