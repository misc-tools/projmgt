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

main :: IO ()
main = listOrgs 
