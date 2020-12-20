as yet unclassified
currentFocus: m

	currentFocus := m.
	self isSelected ifFalse: [^ m ifNotNil: #select].
	currentFocusIndicator detach.
	currentFocus ifNotNil: [
		currentFocus attachDecorator: currentFocusIndicator.
		currentFocus ensureVisible]