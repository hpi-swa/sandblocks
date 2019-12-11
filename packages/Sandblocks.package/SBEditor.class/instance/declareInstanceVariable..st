actions
declareInstanceVariable: aString

	self do: ((SBDeclareInstanceVariableCommand newFor: SBNullSavable new)
		class: self method methodClass;
		name: aString)