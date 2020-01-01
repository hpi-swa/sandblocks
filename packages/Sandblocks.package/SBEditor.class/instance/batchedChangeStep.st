selection
batchedChangeStep

	" send this message when you are updating the tree rapidly for each update, but don't want to submit a command for each update, only at the end "
	compileTime = #compileOnChange ifTrue: [self saveTryFixing: false]