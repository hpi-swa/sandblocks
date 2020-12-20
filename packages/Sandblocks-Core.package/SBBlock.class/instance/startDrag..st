as yet unclassified
startDrag: anEvent

	(SBToggledCode
		comment: 'if the preference is on, we absorb the startDrag events'
		active: 1
		do: {
			[
				anEvent yellowButtonPressed and: [SBPreferences rightClickContextMenu]]
		}) ifTrue: [ | canvas |
		canvas := self sandblockEditor canvas.
		anEvent hand newMouseFocus: canvas.
		^ canvas startDrag: (anEvent transformBy: canvas transform asMatrix2x3 invert)].
	
	super startDrag: anEvent.
	
	(self hasDecorator: SBMoveDecorator) ifFalse: [
		(self nearestOwnerThat: [:o | o isSandblock and: [o isSelected]]) ifNotNil: [:o | ^ o pickUp: anEvent].
		^ self
			select;
			pickUp: anEvent].
	
	self sandblockEditor select: self