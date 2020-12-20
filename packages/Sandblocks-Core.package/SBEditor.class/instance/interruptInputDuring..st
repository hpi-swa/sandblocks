input
interruptInputDuring: aBlock

	| cursor |
	self selection ifNil: [^ aBlock value].
	
	cursor := self selection currentTextMorph ifNotNil: #cursor.
	self endInput.
	aBlock value.
	cursor ifNotNil: [self maybeStartInputAt: cursor]