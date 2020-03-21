{-# LANGUAGE GADTs #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators       #-}
module Knit.Kernmantle.Report
  (
  ) where


import qualified Knit.Kernmantle.Effect.Core as KC
import qualified Knit.Report as K

import qualified Data.Text as T

newPandoc :: K.PandocInfo -> KC.KnitKleisli m K.PandocWithRequirements ()
newPandoc pandocInfo = KC.arrInSemCore (K.newPandoc pandocInfo)

