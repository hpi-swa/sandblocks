as yet unclassified
widget: aMorph shortcut: aShortcut do: aBlock

	action := aBlock.
	self addMorphBack: aMorph.
	aShortcut ifNotNil: [
		self addMorphBack: (StringMorph new
			contents: aShortcut displayString;
			color: Color gray)]