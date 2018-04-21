{-|
Module      : ExprDiff
Description : Contains a Datatype and all fields
Copyright   : (c) Ritwik Jain Sahu @2018
License     : WTFPL
Maintainer  : github.com/sahur1
Stability   : experimental
Portability : POSIX
TODO This module defines constructors for Expr datatype and gets variables for them
-}
module ExprType where
import Data.List


-- * Data Type: Expr

-- | makes a data type that contains all operators needed in assignment
data Expr a = Add (Expr a) (Expr a) -- ^ addition operator of type Expr
            | Mult (Expr a) (Expr a) -- ^ multiply operator of type Expr
            | Cos (Expr a) -- ^ cosine operator of type Expr
            | Sin (Expr a) -- ^ sine operator of type Expr
            | Exp (Expr a) (Expr a) -- ^ This constructor represents the exponent operator of type Expr. It represents the first the First Expr a to the power of the second.
            | NatExp (Expr a) -- ^ e to the power of Expr a
            | Const a -- ^ wraps a constant
            | Var String -- ^ wraps a variable
  deriving Eq


-- ** getVars

-- | Encoding the expression types into a list of strings that can be evaluated 
getVars :: Expr a -> [String] 
getVars (Add e1 e2)  = getVars e1 `union` getVars e2
getVars (Mult e1 e2) = getVars e1 `union` getVars e2
getVars (Cos e) = getVars e
getVars (Sin e) = getVars e
getVars (NatExp e) = getVars e
getVars (Exp e1 e2) = getVars e1 `union` getVars e2
getVars (Const _)    = []
getVars (Var ident)  = [ident]