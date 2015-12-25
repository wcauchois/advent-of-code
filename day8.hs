
import Text.ParserCombinators.Parsec
import Control.Arrow
import Control.Monad
import Debug.Trace

-- stack runghc --package parsec day8.hs

sumTuples :: (Num a) => [(a, a)] -> (a, a)
sumTuples = (sum *** sum) . unzip

fromParse :: Either ParseError a -> a
fromParse (Left err) = error (show err)
fromParse (Right r) = r

countString :: String -> (Int, Int) -- (characters in memory, characters of code)
countString s = fromParse $ parse p "" s
  where p = do char '"'
               result <- many codeChar
               char '"'
               return $ second (+2) $ sumTuples result
        codeChar :: GenParser Char st (Int, Int)
        codeChar = (alphaNum >> return (1, 1)) <|> (char '\\' >> escapeSequence)
        escapeSequence = choice [char 'x' >> hexDigit >> hexDigit >> return (1, 4),
                                 oneOf "\\\"" >> return (1, 2)]

-- super boilerplate from above
encodeString :: String -> String
encodeString s = fromParse $ parse p "" s
  where p = do char '"'
               result <- many codeChar
               char '"'
               return $ "\"\\\"" ++ (concat result) ++ "\\\"\""
        codeChar :: GenParser Char st String
        codeChar = (liftM (:[]) alphaNum) <|> (char '\\' >> escapeSequence)
        hexEscape = do char 'x'
                       d1 <- hexDigit
                       d2 <- hexDigit
                       return $ "\\\\x" ++ [d1, d2]
        simpleEscape :: GenParser Char st String
        simpleEscape =  liftM (("\\\\\\"++) . (:[])) $ oneOf "\\\""
        escapeSequence = hexEscape <|> simpleEscape

main :: IO ()
main = do
  inputLines <- liftM lines $ readFile "day8.txt"
  let (mem1, chars1) = sumTuples $ map countString inputLines
  let (mem2, chars2) = sumTuples $ map (countString . encodeString) inputLines
  --print $ (mem1, chars1)
  --print $ (mem2, chars2)
  print $ chars2 - chars1
  --mapM_ (putStrLn . encodeString) inputLines
  --print $ encodeString "abc"
  --let (totalMem, totalCodeChars) = sumTuples $ map countString inputLines
  --print $ totalCodeChars - totalMem

