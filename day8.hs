
import Text.ParserCombinators.Parsec
import Control.Arrow
import Control.Monad
import Debug.Trace

-- stack runghc --package parsec day8.hs

sumTuples :: (Num a) => [(a, a)] -> (a, a)
sumTuples = (sum *** sum) . unzip

countString :: String -> (Int, Int) -- (characters in memory, characters of code)
countString s = case parse p "" s of
                  (Right r) -> r
                  (Left err) -> error (show err)
  where p = do char '"'
               result <- many codeChar
               char '"'
               return $ second (+2) $ sumTuples result
        codeChar :: GenParser Char st (Int, Int)
        codeChar = (alphaNum >> return (1, 1)) <|> (char '\\' >> escapeSequence)
        escapeSequence = choice [char 'x' >> hexDigit >> hexDigit >> return (1, 4),
                                 oneOf "\\\"" >> return (1, 2)]

main :: IO ()
main = do
  inputLines <- liftM lines $ readFile "day8.txt"
  let (totalMem, totalCodeChars) = sumTuples $ map countString inputLines
  print $ totalCodeChars - totalMem

