as yet unclassified
updatePosition

	SBToggledCode
		comment: 'No idea why this is necessary, but otherwise we''re at 0@0'
		active: 1
		do: {
			[
				currentRepresentation owner ifNotNil: [:m | m layoutChanged fullBounds]]
		}.
	self position: currentRepresentation right @ self top