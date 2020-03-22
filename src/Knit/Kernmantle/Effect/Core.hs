{-# LANGUAGE GADTs #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators       #-}
module Knit.Kernmantle.Effect.Core
  (
    KnitKleisli
  , LogEff(..)
  ) where

import qualified Control.Kernmantle.Rope as Rope
import qualified Polysemy as P
import qualified Knit.Report.EffectStack as K
import qualified Knit.Effect.Logger as K
import qualified Control.Arrow as A

import qualified Data.Text as T

-- Wrap the knit-haskell stack as a Kleisli arrow
-- and then we
-- can dispatch effects to it.  We wil slowly build
-- these effects directly in Kernmantle as well,
-- eventually leaving the base as just the PandocMonad
-- and IO bits, hopefully.
type KnitMonad m = P.Sem (K.KnitEffectStack m)
type KnitKleisli m a b = A.Kleisli (KnitMonad m) a b

arrInSemCore :: (a -> KnitMonad m b) -> KnitKleisli m a b
arrInSemCore = A.Kleisli 

runInSemCore :: KnitMonad m a -> KnitKleisli m () a
runInSemCore = arrInSemCore . const 


-- The Logging Effect
data LogEff a b where
  LogText :: LogEff (K.LogSeverity, T.Text) ()
  
runLogEff :: LogEff a b -> KnitKleisli m a b
runLogEff LogText = A.Kleisli $ uncurry K.logLE 

