as yet unclassified
testUseSuggestion

	| message editor |
	message := '5 yourself' parseAsSandblock.
	(editor := self editorFor: message) startInput: message at: 1 replacingContents: false.
	message useSuggestion: 'yourself:'.
	self assert: message arguments last isSelected.
	self assert: message arguments first isUnknown.
	self assert: message selector = 'yourself:'.
	editor undo.
	self assert: message selector = 'yourself'.
	editor redo.
	self assert: message arguments first isUnknown.
	self assert: message selector = 'yourself:'.
	editor startInput: message at: 1 replacingContents: false.
	message useSuggestion: 'from:to:do:'.
	self assert: (message arguments allSatisfy: #isUnknown).
	editor undo.
	editor redo.
	self assert: (message arguments allSatisfy: #isUnknown).
	editor startInput: message at: 1 replacingContents: false.
	message useSuggestion: 'yourself'.
	self assert: message selector = 'yourself'.
	self assert: message messageParts first isSelected