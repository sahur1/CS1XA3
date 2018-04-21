{-|
Module      : ExprDiff
Description : Makes the expressions pretty
Copyright   : (c) Ritwik Jain Sahu @2018
License     : WTFPL
Maintainer  : github.com/sahur1
Stability   : experimental
Portability : POSIX
TODO Makes the code more readable
-}
module ExprPretty where

import ExprType

parens :: String -> String
parens ss = "(" ++ ss ++ ")"

instance Show a => Show (Expr a) where
  show (Add e1 e2) = parens (show e1) ++ " !+ " ++ parens (show e2)
  show (Mult e1 e2) = parens (show e1) ++ " !* " ++ parens (show e2)
  show (Cos x)  = "Cos" ++ parens (show x)
  show (Sin x) = "Sin" ++ parens (show x)
  show (Var ss)     = parens $ "Var " ++ "\"" ++ ss ++ "\""
  show (Const x)    = parens $ "Val. " ++ show x
  show (NatExp x) = "e^" ++ parens (show x)
  show (Exp e1 e2) = parens (show e1) ++ " !^ " ++ parens (show e2)