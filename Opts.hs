-- | Option parser

module Opts
    ( Options(..)
    , getOpts
    ) where

import           Control.Applicative (Alternative(..))
import           Data.Monoid ((<>))
import qualified Options.Applicative as O
import           PPDiff (ColorEnable(..))

data Options = Options
    { shouldUseEditor :: Bool
    , shouldDumpDiffs :: Bool
    , shouldUseColor :: Maybe ColorEnable
    , shouldSetConflictStyle :: Bool
    }

parser :: O.Parser Options
parser =
    Options
    <$> O.switch
        ( O.long "editor" <> O.short 'e'
          <> O.help "Execute $EDITOR for each conflicted file that remains conflicted"
        )
    <*> O.switch
        ( O.long "diff" <> O.short 'd'
          <> O.help "Dump the left/right diffs from base in each conflict remaining"
        )
    <*> ( O.flag' (Just EnableColor)
          (O.long "color" <> O.short 'c' <> O.help "Enable color")
          <|> O.flag' (Just DisableColor)
              (O.long "no-color" <> O.short 'C' <> O.help "Disable color")
          <|> pure Nothing
        )
    <*> ( O.switch
          ( O.long "style" <> O.short 's'
            <> O.help "Configure git's global merge.conflictstyle to diff3 if needed"
          )
        )

opts :: O.ParserInfo Options
opts =
    O.info (O.helper <*> parser) $
    O.fullDesc
    <> O.progDesc
       "Resolve any git conflicts that have become trivial by editing operations.\n\
       \Go to http://github.com/ElastiLotem/resolve-trivial-conflicts for example use."
    <> O.header "resolve-trivial-conflicts - Become a conflicts hero"

getOpts :: IO Options
getOpts = O.execParser opts

