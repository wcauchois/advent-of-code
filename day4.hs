
import Crypto.Hash.MD5
import Data.Maybe(fromJust)
import qualified Data.ByteString.Char8 as B
import qualified Data.ByteString.Base16 as B16
import Data.List(find)

-- stack runghc --package cryptohash --package base16-bytestring day4.hs

hashString :: String -> String
hashString = B.unpack . B16.encode . hash . B.pack

satisfies :: String -> Bool
satisfies = all (=='0') . take 6

main :: IO ()
main = do
  let secretKey = "yzbqklnj"
  let miner i = satisfies $ hashString $ secretKey ++ (show i)
  print $ fromJust $ find miner [1..]

