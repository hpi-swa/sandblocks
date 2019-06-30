input
endInput

	currentInput ifNil: [^ self].
	
	modeLabel contents: 'NORMAL'.
	currentInput stopEditing.
	currentInputCommand
		newText: currentInput contents;
		newMorph: currentInput.
	
	currentInputCommand hasChange ifTrue: [
		self do: currentInputCommand].
	
	currentInput := nil.
	currentInputCommand := nil.