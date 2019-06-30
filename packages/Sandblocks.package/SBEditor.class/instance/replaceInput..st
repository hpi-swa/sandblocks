input
replaceInput: aMorph
	" inform the editor that the current input morph has been replaced by another where input should continue "

	self assert: currentInput notNil.
	currentInput := aMorph.
	self select: aMorph