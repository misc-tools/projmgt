{-# LANGUAGE OverloadedStrings #-}

module Main where

import Turtle 
import Turtle.Format
import qualified Control.Foldl as Fold 

projectsDir = "/home/vietnguyen/projects"

type ProjectName = String
type OrgName = String 

-- | List all organizations 
listOrgs :: IO () -- [OrgName]
listOrgs = do
  view $ filename <$> (ls projectsDir)

-- | List all projects belonging to an organization
listProjects :: OrgName -> IO [ProjectName]
listProjects = undefined 

-- | Filter any files in the root project folder 
findInfantFiles :: Shell Text 
findInfantFiles = grep (has ".")  (format fp <$> (ls projectsDir))

checkInfantFiles :: IO () 
checkInfantFiles = do 
  putStrLn "===\nCheck if there is any file in the root project folder: " 
  n <- fold findInfantFiles Fold.length
  if n == 0 then putStrLn "No file!"
  else do 
    putStrLn "File(s): "
    stdout findInfantFiles
    putStrLn "Need to remove these files!" 
    putStrLn "==="
    
-- removeInfantFiles :: IO ()
-- removeInfantFiles = sh (do 
--                          infantFile <- findInfantFiles
--                          liftIO (rm (FilePath infantFile))
--                        )

main :: IO ()
main = do 
  checkInfantFiles
