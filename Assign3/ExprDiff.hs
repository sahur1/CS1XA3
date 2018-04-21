{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE UndecidableInstances #-}

{-|
Module      : ExprDiff
Description : cointains methods over the 
  Expr datatype tht helps with making and
  evaluating diferentiable expressions.
Copyright   : (c) Ritwik Jain Sahu @2018
License     : WTFPL
Maintainer  : github.com/sahur1
Stability   : experimental
Portability : POSIX
-}
module ExprDiff where

import ExprType

import qualified Data.Map as Map
{-
    Default Methods:
      !+,!*,var,val: are function wrappers for Expr
                     constructors that perform
                     additional simplification
-}


-- * core functions
class DiffExpr a where
  -- | Takes a dictionary of variable-identifiers and values, and uses it to compute the Expr.
  eval :: Map.Map String a -> Expr a -> a
  -- | Takes a dictionary (complete or incomplete) and uses it to reduce Expr as much as possible.
  simplify :: Map.Map String a -> Expr a -> Expr a
  -- | Given a var identifier, differentiate in terms of that identifier
  partDiff :: String -> Expr a -> Expr a


  {- Default Methods -}

  -- | converts !+ into Add e1 e2
  (!+) :: Expr a -> Expr a -> Expr a
  e1 !+ e2 = simplify (Map.fromList []) $ Add e1 e2
  -- | applies multiplication to an Expr type and returns the same wrapped type
  (!*) :: Expr a -> Expr a -> Expr a
  e1 !* e2 = simplify (Map.fromList []) $ Mult e1 e2
  -- | convert a number based a and a number power b into const a^b
  (!^) :: Expr a -> Expr a -> Expr a
  e1 !^ e2 = simplify (Map.fromList []) $ Exp e1 e2
  -- | will convert x into cos x
  mycos :: Expr a -> Expr a
  mycos e1 = simplify (Map.fromList []) $ Cos e1 
  -- | will convert x into sin x
  mysin :: Expr a -> Expr a
  mysin e1 = simplify (Map.fromList []) $ Sin e1

  -- | takes a and converts to e^a
  natexp :: Expr a -> Expr a 
  natexp e1 = simplify (Map.fromList []) $ NatExp e1   

  val :: a -> Expr a
  val x = Const x
  var :: String -> Expr a
  var x = Var x


-- ** instance of DiffExpr
instance (Eq a, Floating a) => DiffExpr a where
  eval vrs (Add e1 e2)  = eval vrs e1 + eval vrs e2
  eval vrs (Mult e1 e2) = eval vrs e1 * eval vrs e2
  eval vrs (Exp e1 e2) = eval vrs e1 ** eval vrs e2 
  eval vrs (Cos x) =  cos (eval vrs x) 
  eval vrs (Sin x) = sin (eval vrs x)
  eval vrs (NatExp x) = exp (eval vrs x)
  eval vrs (Const x) = x
  eval vrs (Var x) = case Map.lookup x vrs of
                       Just v  -> v
                       Nothing -> error "failed lookup in eval"


  
  partDiff t (Var x) | x == t = Const 1
                     | otherwise = (Const 0)
  partDiff _ (Const _) = Const 0
  partDiff t (Add e1 e2) =(Add (partDiff t e1) (partDiff t e2))
  partDiff t (Mult e1 e2) = (Add (Mult (partDiff t e1) e2) (Mult e1 (partDiff t e2)))
  partDiff t (Cos x) =(Mult (Const (-1) ) (Mult (partDiff t x) (Sin x)))
  partDiff t (Sin x) = (Mult (partDiff t x) (Cos x))
  partDiff t (NatExp x) = Mult (NatExp x) (partDiff t x)


  simplify vrs (Const x) = (Const x)
 
  simplify vrs (Var x) = case Map.lookup x vrs of
                       Just v  -> (Const v)
                       Nothing -> (Var x)
 
  simplify vrs (Add a b) =
    case (simplify vrs a, simplify vrs b) of

      (Const 0, x) -> simplify vrs x
      (x, Const 0) -> simplify vrs x
 
      (Const x, Const y) -> Const (x+y)
 
      (Const x, y) -> (Add (simplify vrs y) (Const x))
 
      (Add z (Const y), Const x) -> simplify vrs (Add (simplify vrs z) (Const (x+y)))
 
      (x, y) -> (Add x y)
 
  simplify vrs (Mult a b) =
    case (simplify vrs a, simplify vrs b) of

      (Const 0, y) -> (Const 0)
      (y, Const 0) -> (Const 0)
 
      (Const 1, y) -> (simplify vrs y)
      (y, Const 1) -> (simplify vrs y)
 
      (Const x, Const y) -> Const (x*y)
 
      (Const x, y) -> (Mult (simplify vrs y) (Const x))
 
      (Mult z (Const y), Const x) -> simplify vrs (Mult (simplify vrs z) (Const (x*y)))
 
      (x, y) -> (Mult x y)