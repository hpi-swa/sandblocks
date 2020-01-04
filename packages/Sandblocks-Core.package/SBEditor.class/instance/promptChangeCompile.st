initialize-release
promptChangeCompile

	| index labels |
	labels := {'Compile on save'. 'Compile on change'}.
	index := UIManager default chooseFrom: labels.
	index < 1 ifTrue: [^ self].
	
	compileTimeButton contents: (labels at: index).
	compileTime := index = 1 ifTrue: [#compileOnSave] ifFalse: [#compileOnChange]