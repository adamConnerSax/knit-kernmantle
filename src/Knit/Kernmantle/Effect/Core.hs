{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators       #-}
module Knit.Kernmantle.Effect.Core
  (
    KnitKleisli
  , LogEff(..)
  ) where

import qualified Control.Kernmantle.Rope as Rope
import           Control.Kernmantle.Rope ((&))
import           Data.Profunctor.Trans (type (~>))
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
-- Basically, leave the truly monadic bits in the core
-- and move anything fundamentally applicative to
-- the arrow/kernmantle layer.
type KnitMonad m = P.Sem (K.KnitEffectStack m)
type KnitKleisli m = A.Kleisli (KnitMonad m) 

-- this will evolve as we reinterpret and manage effects above the monadic Knit core
type KnitCore m = KnitKleisli m 

arrKnitMonad :: (a -> KnitMonad m b) -> KnitCore m a b
arrKnitMonad = A.Kleisli 

runInKnitMonad :: KnitMonad m a -> KnitCore m () a
runInKnitMonad = arrKnitMonad . const 

-- run
type KnitPipeline m a b = Rope.AnyRopeWith '[ '("log", LogEff), '("knitCore", KnitCore m)] '[] a b

runKnitPipeline :: KnitPipeline m a b -> a -> KnitMonad m b
runKnitPipeline pipeline input = pipeline
                                 & Rope.loosen
                                 & Rope.weaveK #log runLogEffInKnitMonad
                                 & Rope.weave' #knitCore id
                                 & Rope.untwine
                                 & (flip A.runKleisli input)
                                 
                                 

-- The Logging Effect
data LogEff a b where
  LogText :: LogEff (K.LogSeverity, T.Text) ()

runLogEffInKnitMonad :: a `LogEff` b -> a -> KnitMonad m b
runLogEffInKnitMonad LogText = uncurry K.logLE

interpLogEff :: a `LogEff` b -> Rope.AnyRopeWith '[ '("knitCore", KnitCore m)] '[] a b 
interpLogEff  = Rope.strand #knitCore . A.Kleisli . runLogEffInKnitMonad

