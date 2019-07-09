as yet unclassified
switchToNumberDisplay

	self submorphCount > 1 ifTrue: [self submorphs second delete].
	
	self addMorphBack: (display := ECSGraphPlot new labelColor: Color white; hResizing: #spaceFill)