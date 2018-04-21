<h1>Haskell Math Library 2018</h1>
 <a href="http://ugweb.cas.mcmaster.ca/~sahur1/docs" target="_blank">Documentation</a>

<h3>Basic Functionalities:</h3>
	<li> An expression datatype that can encode:</li>
			<li>Addition</li>
			<li>Multiplication</li>
			<li>Cos, Sin, Exp (natural)</li>
			<li>Variables</li>
			<li>Constants</li>
			</br>
	 <li>Can partially evaluate an expression</li>
	 </br><li>Can perform partial differentiation</li>
	 </br><li>Can perform some simplification of expressions</li>
	 </br><li>Can parse certain strings into an expression datatype (specify required format in documentation)</li>

</br>
<p>Note: All the evaluation, simplification and partDifferention are basic 1st level.</p>


<h1>Core Functionality Testing:</h1>

1) simplify (Map.fromList [("y", 15)]) ((Var "x")  !+ (Var "y") !+ (Const 42) !+ (Const 23))
> ((Var "x")) !+ ((Val. 80.0))

2) partDiff "x" (Mult (Var "x") (Var "y"))
> (((Val. 1.0)) !* ((Var "y"))) !+ (((Var "x")) !* ((Val. 0.0)))

3) eval (Map.fromList [("x", 25), ("y", 10.45), ("z", 20)]) ((Var "x") !+ (Var "y") !+ (Var "z") !+ (Const 2) !+ (Const 3) !+ (Const 4))
> 64.45


Special thanks to https://github.com/wengy12 and https://github.com/sahnik1 or making this possible. Cheers!
