actions
declareInstanceVariable: aString

	self do: ((SBDeclareInstanceVariableCommand newFor: SBNullSavable new)
		class: self method methodClass;
		select: self selection;
		name: aString)