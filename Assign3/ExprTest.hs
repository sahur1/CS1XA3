{-|
Module      : ExprDiff
Description : Contains tests for the methods
Copyright   : (c) Ritwik Jain Sahu @2018
License     : WTFPL
Maintainer  : github.com/sahur1
Stability   : experimental
Portability : POSIX
TODO This module contains tests to check the functionality of the library
-}
module ExprTest where

import           ExprDiff
import           ExprParser
import           ExprPretty
import           ExprType

import qualified Data.Map.Strict as Map
import           Test.QuickCheck

-- | tests Add
sampleExpr1 :: Expr Double
sampleExpr1 = ((var "x") !+ (var "y")) 


-- | tests ability to take a list and convert into an Expr
listToExpr1 :: [Double] -> Expr Double
listToExpr1 [x]    = Const x
listToExpr1 (x:xs) = Add (Const x) (listToExpr1 xs)
listToExpr1 []     = error "Not list to expression for empty"


-- | tests validity of Add
evalProp1 :: Double -> Double -> Bool
evalProp1 a b = eval (Map.fromList [("x",a),("y",b)]) (Add (Var "x") (Var "y")) == a + b
testEvalProp1 = quickCheck evalProp1

-- | tests validity of Mult
evalProp2 :: Double -> Double -> Bool
evalProp2 a b = eval (Map.fromList [("x",a),("y",b)]) (Mult (Var "x") (Var "y")) == a * b
testEvalProp2 = quickCheck evalProp2

-- | tests validity of Cos
evalProp6 :: Double -> Bool
evalProp6 a = eval (Map.fromList [("x",a)]) (Cos (Var "x")) == cos(a)
testEvalProp6 = quickCheck evalProp6

-- | tests validity of Sin
evalProp7 :: Double -> Bool
evalProp7 a = eval (Map.fromList [("x",a)]) (Sin (Var "x")) == sin(a)
testEvalProp7 = quickCheck evalProp7

