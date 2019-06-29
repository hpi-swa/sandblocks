as yet unclassified
endInput

	currentInput ifNil: [^ self].
	
	currentInput stopEditing.
	currentInputCommand newText: currentInput contents.
	
	currentInputCommand newText ~= currentInputCommand previousText ifTrue: [
		self do: currentInputCommand].
	
	currentInput := nil.
	currentInputCommand := nil.