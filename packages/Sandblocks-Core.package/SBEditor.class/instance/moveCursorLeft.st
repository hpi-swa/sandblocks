actions input
moveCursorLeft
	<inputAction>

	self textMorph
		moveCursor: -1
		ifAtBound: [ | next |
			next := self class navigation previousFrom: self selection do: [:b |
				(self selection canJumpTo: b) ifTrue: [b] ifFalse: [nil]].
			next ifNotNil: [self select: next; startInput: next at: 900000000 replacingContents: false]]
		wordWise: (ActiveEvent commandKeyPressed or: [ActiveEvent controlKeyPressed])