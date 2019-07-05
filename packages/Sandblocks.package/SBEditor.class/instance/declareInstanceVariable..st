actions
declareInstanceVariable: aString

	self do: (SBDeclareInstanceVariableCommand new
		class: self method methodClass;
		name: aString)