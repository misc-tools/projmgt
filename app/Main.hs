{-# LANGUAGE OverloadedStrings #-}

module Main where

import Turtle 
import Turtle.Format
import qualified Control.Foldl as Fold 
import System.Console.ANSI
import qualified Filesystem.Path as Path
import qualified GitHub as GH

projectsDir = "/home/vietnguyen/projects"

type ProjectName = Text
type OrgName = Text

-- | List all organizations 
printOrgs :: IO ()
printOrgs = do
  putStrLnColor Yellow "CURRENT ORGANIZATIONS:"
  view $ getName . toText . filename <$> (ls projectsDir)


printProjects :: IO ()
printProjects = do
  putStrLnColor Yellow "CURRENT PROJECTS:"
  sh (do 
       org <- ls projectsDir
       liftIO (setSGR [SetColor Foreground Vivid Blue])
       liftIO (print $ format fp (filename org))
       liftIO (setSGR [Reset])
       liftIO (view (listProjects org))
     )


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
  putStrLnColor Yellow "Check if there is any file in the root project folder: " 
  n <- fold findInfantFiles Fold.length
  if n == 0 then putStrLnColor Green "No file!"
  else do
    putStrLnColor Red "File(s):"                                  
    stdout findInfantFiles
    putStrLnColor Red "Need to remove these files!" 
    removeInfantFiles
    putStrLn "Files removed."


putStrColor :: Color -> String -> IO ()
putStrColor c s = do
  setSGR [SetColor Foreground Vivid c]
  putStr s
  setSGR [Reset]

putStrLnColor :: Color -> String -> IO ()
putStrLnColor c s = do
  putStrColor c s
  putStrLn ""
  
removeInfantFiles :: IO ()
removeInfantFiles = sh (do 
                         infantFile <- findInfantFiles
                         liftIO (rm $ fromText infantFile)
                       )


main :: IO ()
main = do 
  checkInfantFiles
  putStrLn ""
  printOrgs
  putStrLn ""
  printProjects
