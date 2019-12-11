*Sandblocks
fromSide: aSymbol

	aSymbol = #left ifTrue: [^ -1 @ 0].
	aSymbol = #right ifTrue: [^ 1 @ 0].
	aSymbol = #top ifTrue: [^ 0 @ -1].
	aSymbol = #bottom ifTrue: [^ 0 @ 1].
	^ self assert: false