{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators       #-}
module Knit.Kernmantle.Effect.Pandoc
  (
  ) where


import qualified Knit.Kernmantle.Effect.Core as KC
import qualified Knit.Report.EffectStack as K
import qualified Knit.Effect.Pandoc as K
import qualified Knit.Effect.PandocMonad as K

import qualified Control.Arrow as A
import qualified Polysemy                      as P

import qualified Data.Text as T

newPandoc :: (K.PandocEffects r
             , P.Member K.Pandocs r)
          => K.PandocInfo
          -> A.Kleisli (P.Sem (K.ToPandoc ': r)) a ()
          -> A.Kleisli (P.Sem r) a ()
newPandoc pandocInfo (A.Kleisli f) = A.Kleisli $ K.newPandoc pandocInfo . f

