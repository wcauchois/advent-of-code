
import Control.Arrow

-- stack runghc day10.hs

convertRuns :: (Eq a) => [a] -> [(Int, a)]
convertRuns [] = []
convertRuns (x : xs) = helper xs x 1
  where helper [] cur count = [(count, cur)]
        helper (x : xs) cur count
          | cur == x = helper xs cur (count + 1)
          | otherwise = (count, cur) : helper xs x 1

flattenTuples :: [(a, a)] -> [a]
flattenTuples = concat . map (\(a, b) -> [a, b])

stringToInts :: String -> [Int]
stringToInts = map $ read . (:[])

intsToString :: [Int] -> String
intsToString = concat . map show

lookAndSay :: [Int] -> [Int]
lookAndSay = flattenTuples . convertRuns

main :: IO ()
main = do
  let inputInts = stringToInts "1321131112"
      numIterations = 40
      result = (iterate lookAndSay inputInts) !! numIterations
  print $ length result

