as yet unclassified
x: aXBlock y: aYBlock

	self
		addMorphBack: aXBlock;
		addMorphBack: (SBStringMorph new contents: '@');
		addMorphBack: aYBlock