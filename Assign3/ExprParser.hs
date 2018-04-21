{-|
Module      : ExprParser
Description : Contains the parse method to convert strings to Expr type
Copyright   : (c) Ritwik Jain Sahu @2018
License     : WTFPL
Maintainer  : github.com/sahur1
Stability   : experimental
Portability : POSIX 
-}

module ExprParser (parseExprD,parseExprF) where

import ExprType
import Text.Parsec
import Text.Parsec.String
import ExprPretty

-- | main parser for doubles
parseExprD :: String -> Expr Double
parseExprD ss = case parse exprD "" ss of
                  Left err -> error $ show err
                  Right expr -> expr

-- | main parser for floats
parseExprF :: String -> Expr Float
parseExprF ss = case parse exprF "" ss of
                  Left err -> error $ show err
                  Right expr -> expr

-- | parses the different types of doubles
exprD :: Parser (Expr Double)
exprD = exprVar <|> exprConstD <|> exprTrigD <|> exprOpD

-- | parses the different types of floats
exprF :: Parser (Expr Float)
exprF = exprVar <|> exprConstF <|> exprTrigF <|> exprOpF



-- | The parser either adds or multiply doubles
exprOpD :: Parser (Expr Double)
exprOpD = do {
                s <- symbol "Add" <|> symbol "Mult";
                ss <- between (symbol "(") (symbol ")") (exprVar <|> exprConstD <|> exprOpD <|> exprOpD);
                ss' <- between (symbol "(") (symbol ")") (exprVar <|> exprConstD <|> exprOpD <|> exprOpD);

                if s == "Add" then
                  return (Add ss ss'); -- Initial s is "Add", return Add
                else -- The only other option is to return "Mult", since it wasn't "Add"
                  return (Mult ss ss');
              }

-- | The parser has an option to either return the cosine operator or the sine operator for doubles
exprTrigD :: Parser (Expr Double)
exprTrigD = do {
               s <- symbol "Cos" <|> symbol "Sin";
               ss <- exprD;

               if s == "Cos" then
                 return (Cos ss);
               else
                 return (Sin ss);
             }


-- | Takes in string const and returns expr type const for doubles
exprConstD :: Parser (Expr Double)
exprConstD = do {
               symbol "Const";
               ss <- double;
               return (Const ss);
             }




-- | The parser either adds or multiply float
exprOpF :: Parser (Expr Float)
exprOpF = do {
                s <- symbol "Add" <|> symbol "Mult";
                ss <- between (symbol "(") (symbol ")") (exprVar <|> exprConstF <|> exprOpF);
                ss' <- between (symbol "(") (symbol ")") (exprVar <|> exprConstF <|> exprOpF);

                {-
                  This parser can only have the option of
                  Adding or Multiplying, so it's necessary
                  to check whether the initial input was
                  "Add" or "Mult", and return the correct
                  result accordingly
                -}
                if s == "Add" then
                  return (Add ss ss'); -- Initial s is "Add", return Add
                else -- The only other option is to return "Mult", since it wasn't "Add"
                  return (Mult ss ss')
              }

-- | The parser has an option to either return the cosine operator or the sine operator for floats
exprTrigF :: Parser (Expr Float)
exprTrigF = do {
               s <- symbol "Cos" <|> symbol "Sin";
               ss <- between (symbol "(") (symbol ")") (exprF);

               if s == "Cos" then
                 return (Cos ss);
               else
                 return (Sin ss);
             }



-- | Takes in string const and returns expr type const for float
exprConstF :: Parser (Expr Float)
exprConstF = do {
               symbol "Const";
               ss <- float;
               return (Const ss);
             }






-- | encoding a variable to expr type
exprVar :: Parser (Expr a) -- Abstracted and available for use whether for float values or double
exprVar = do {
               symbol "Var";
               ss <- many1 letter;
               return (Var ss);
             }



-- * Utility parsers and combinators

parens :: Parser a -> Parser a
parens p = do { char '(';
               cs <- p;
               char ')';
               return cs }

symbol :: String -> Parser String
symbol ss = let
 symbol' :: Parser String
 symbol' = do { spaces;
                ss' <- string ss;
                spaces;
                return ss' }
 in try symbol'

removeRight (Right ss) = ss

digits :: Parser String
digits = many1 digit

negDigits :: Parser String
negDigits = do { neg <- symbol "-";
                dig <- digits;
                return (neg ++ dig) }

integer :: Parser Integer
integer = fmap read $ try negDigits <|> digits

decimalDigits :: Parser String
decimalDigits = do { d <- char '.';
                     rm <- digits;
                     return $ d:rm }

decimalDigits' :: Parser String
decimalDigits' = do { ds <- try negDigits <|> digits;
                   rs <- try decimalDigits <|> return "";
                   return $ ds ++ rs }

double :: Parser Double
double = fmap read $ decimalDigits'

float :: Parser Float
float = fmap read $ decimalDigits'