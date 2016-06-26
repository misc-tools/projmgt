{-# LANGUAGE OverloadedStrings #-}

module Main where

import Turtle 
import Turtle.Format
import qualified Control.Foldl as Fold 
import System.Console.ANSI

projectsDir = "/home/vietnguyen/projects"

type ProjectName = String
type OrgName = String 

-- | List all organizations 
listOrgs :: IO () -- [OrgName]
listOrgs = do
  putStrLn "===\n Current Organizations:"
  view $ getName . toText . filename <$> (ls projectsDir)
  putStrLn "==="
    where getName (Left a) = ""
          getName (Right s) = s
        
-- | List all projects belonging to an organization
listProjects :: OrgName -> IO [ProjectName]
listProjects = undefined 

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
  listOrgs
