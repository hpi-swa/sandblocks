as yet unclassified
updateExplorers

	| context |
	context := self currentStackFrame context.
	temporaries ifNotNil: #delete.
	self addMorphBack: (temporaries := (SBExplorer on: (Array streamContents: [:stream |
		context tempNames doWithIndex: [:name :index |
			stream nextPut: name -> (context tempAt: index)]])) toggleCollapsed).
	explorer ifNotNil: #delete.
	self addMorphBack: (explorer := SBExplorer on: context receiver) toggleCollapsed