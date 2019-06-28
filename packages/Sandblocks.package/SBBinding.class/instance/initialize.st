as yet unclassified
initialize

	super initialize.
	
	self addMorphBack: (label := SBTextMorph new).
	self changeTableLayout.
	self vResizing: #shrinkWrap.
	self hResizing: #shrinkWrap