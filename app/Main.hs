{-# LANGUAGE OverloadedStrings #-}
module Main where

import Turtle 

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

-- | Check if there is any file (not folder) in the root project folder 
checkInfantFile :: IO ()
checkInfantFile = undefined
-- checkInfantFile = do 
--   listFilesAndFoldersInRoot <- liftIO $ filename <$> (ls projectsDir)
--   go listFilesAndFoldersInRoot
--      where go [] = putStrLn ""
--            go (x : xs) = case extension x of 
--                            Just ext -> putStrLn $ x + "is a file and need to be deleted" >> go xs
--                            Nothing -> go xs

                    

main :: IO ()
main = listOrgs 
