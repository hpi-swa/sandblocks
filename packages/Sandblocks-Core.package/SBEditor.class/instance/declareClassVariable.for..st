actions
declareClassVariable: aString for: aClass

	| class |
	class := self openClass: aClass.
	self do: ((SBInsertCommand newFor: class)
		container: class classVariables;
		index: class classVariables submorphCount + 1;
		morph: (SBName contents: aString))