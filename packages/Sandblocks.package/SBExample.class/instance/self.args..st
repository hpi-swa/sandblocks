as yet unclassified
self: aBlock args: aCollectionBlock

	self
		removeAllMorphs;
		addMorphBack: (icon := ECSIcon iconPause color: Color white);
		addMorphBack: (SBStringMorph new contents: 'self:');
		addMorphBack: aBlock;
		addMorphBack: (SBStringMorph new contents: 'args:');
		addMorphBack: aCollectionBlock;
		updateIcon