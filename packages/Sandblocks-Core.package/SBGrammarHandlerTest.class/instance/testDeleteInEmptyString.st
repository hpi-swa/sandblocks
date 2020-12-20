tests
testDeleteInEmptyString

	| block editor string |
	string := SBString new contents: ''.
	block := '[]' parseAsSandblock.
	editor := self editorFor: block.
	block addMorphBack: string.
	editor startInput: string at: 0 replacingContents: false.
	editor selection keyStroke: (self keyboardEvent: Character backspace).
	self assert: block statements isEmpty