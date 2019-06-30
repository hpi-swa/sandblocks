as yet unclassified
endInput

	currentInput ifNil: [^ self].
	
	currentInput stopEditing.
	currentInputCommand
		newText: currentInput contents;
		newMorph: currentInput.
	
	currentInputCommand hasChange ifTrue: [
		self do: currentInputCommand].
	
	currentInput := nil.
	currentInputCommand := nil.