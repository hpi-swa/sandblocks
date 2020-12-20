as yet unclassified
drawDropHighlightOn: aCanvas

	self highlightedForDrop ifTrue: [
		self fixedNumberOfChildren
			ifTrue: [
				aCanvas frameRectangle: self bounds width: 3 color: Color red]
			ifFalse: [ | dropLocation |
				dropLocation := self dropLocationDo: [:position :morph :horizontal |
					aCanvas
						frameRectangle: self bounds width: 3 color: (Color red alpha: 0.3);
						line: position
							to: position + (horizontal ifTrue: [morph width @ 0] ifFalse: [0 @ morph height])
							width: 6
							color: Color red]]]