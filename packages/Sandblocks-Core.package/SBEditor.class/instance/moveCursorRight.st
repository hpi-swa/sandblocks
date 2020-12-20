actions input
moveCursorRight
	<inputAction>

	self textMorph
		moveCursor: 1
		ifAtBound: [ | next |
			next := self class navigation nextFrom: self selection do: [:b |
				(self selection canJumpTo: b) ifTrue: [b] ifFalse: [nil]].
			next ifNotNil: [self select: next; startInput: next at: 0 replacingContents: false]]
		wordWise: (ActiveEvent commandKeyPressed or: [ActiveEvent controlKeyPressed])