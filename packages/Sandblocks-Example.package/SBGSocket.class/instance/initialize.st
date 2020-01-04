as yet unclassified
initialize
	super initialize.
	self changeTableLayout; addMorphBack: (label := TextMorph new);
		addMorphBack: (Morph new extent: 12 asPoint); color: Color transparent