as yet unclassified
initialize
	super initialize.
	value := 1.
	self color: Color white.
	self extent: self tileSize.
	self changeTableLayout.
	self cellPositioning: #center.
	self listCentering: #center.
	self wrapCentering: #center.
	self borderStyle: BorderStyle simple.
	self borderColor: Color black.
	self borderWidth: 1.
	self addMorphBack: (label := StringMorph new contents: '1')