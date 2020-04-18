actions
declareInstanceVariable: aString for: aClass

	| class |
	class := self openClass: aClass.
	self do: ((SBInsertCommand newFor: class)
		container: class instanceVariables;
		index: class instanceVariables submorphCount + 1;
		morph: (SBDeclarationForInstanceVariable new contents: aString))