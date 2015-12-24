{-# LANGUAGE BangPatterns #-}

import Text.ParserCombinators.Parsec
import Debug.Trace
import Control.Monad
import Data.List

-- stack runghc --package parsec day9.hs

data Distance = Distance String String Int deriving (Show)

parseDistance :: (Monad m) => String -> m Distance
parseDistance input = case parse p "" input of
                        Left err -> fail $ show err
                        Right d -> return d
  where p = do
          origin <- many1 letter
          spacesAround "to"
          destination <- many1 letter
          spacesAround "="
          distance <- liftM read $ many1 digit
          return $ Distance origin destination distance
        spacesAround :: String -> GenParser Char st ()  
        spacesAround s = void $ spaces >> string s >> spaces

flipDistances distances = distances ++ map (\(Distance o dest dist) -> Distance dest o dist) distances

newtype Route = Route [Distance]

unRoute (Route r) = r

totalDistance :: Route -> Int
totalDistance (Route distances) = sum $ map (\(Distance _ _ dist) -> dist) distances

instance Show Route where
  show (Route []) = ""
  show r@(Route distances) =
    intercalate " -> " (map (\(Distance o _ _) -> o) (init distances)) ++
      (case (last distances) of (Distance o dest _) -> " -> " ++ o ++ " -> " ++ dest) ++
      " = " ++ show (totalDistance r)

filterNot f = filter (not . f)

showTrace x = trace (show x) x

genRoutes :: [Distance] -> [Route]
genRoutes distances = map Route $ helper (head cities) distances (tail cities)
  where cities = nub $ concatMap (\(Distance o dest _) -> [o, dest]) distances
        helper :: String ->
                  [Distance] ->
                  [String] ->
                  [[Distance]]
        helper curCity distances [oneRemaining] =
          map (:[]) $ filter (\(Distance o dest _) -> o == curCity && dest == oneRemaining) distances
        helper curCity distances remainingCities =
          --let matching = filter (\(Distance o dest _) -> o == curCity) distances
          --in concatMap (\m -> helper matching
          case partition (\(Distance o dest _) -> o == curCity) distances of
            (matching, notMatching) ->
              concatMap (\(Distance o dest _) -> helper dest notMatching (delete dest remainingCities)) matching

        {-
        helper :: [Distance]
               -> [String]
               -> [[Distance]]
        helper [] [] = error "Bad state"
        helper [d@(Distance o dest _)] remainingCities =
          case remainingCities of
            [c] -> if c == dest then [[d]] else []
            _ -> []
        helper _ [] = []
        helper (d@(Distance o dest _) : ds) remainingCities@(c : cs) =
          (if c == o && dest `elem` cs then map (d:) $ helper ds (delete dest cs) else []) ++ helper ds remainingCities

          -- | c == o = let ds' = filterNot (\(Distance o dest _) -> c == o) ds
                     -- in (map (d:) (helper ds cs)) ++ (helper ds remainingCities)
          -- | otherwise = helper ds remainingCities
          -}

{-
genRoutes :: [Distance] -> [Route]
genRoutes distances = helper (head cities) (tail cities) distances
  where cities = nub $ concatMap (\(Distance o dest _) -> [o, dest]) distances
        helper startingCity [] _ = [[startingCity]]
        helper startingCity restCities availableDistances =
          let matchingDistances = filter (\(Distance o dest _) -> o == startingCity) availableDistances
          in concatMap (\(Distance o dest _) -> map (startingCity:) $ helper dest (delete dest restCities) $
                                                                        filterNot (\(Distance _ dest' _) -> dest' == dest) availableDistances) matchingDistances
-}

main :: IO ()
main = do
  inputText <- readFile "day9-sampleinput.txt"
  distances <- liftM flipDistances $ mapM parseDistance $ lines inputText 
  --print distances
  mapM_ (print . unRoute) $ genRoutes distances

