as yet unclassified
self: aBlock args: aCollectionBlock label: aString

	self
		removeAllMorphs;
		addMorphBack: (icon := SBIcon iconPause small; color: Color white);
		addMorphBack: (nameInput := SBTextBubble new contents: aString);
		addMorphBack: (SBStringMorph new contents: 'self:');
		addMorphBack: aBlock;
		addMorphBack: (SBStringMorph new contents: 'args:');
		addMorphBack: aCollectionBlock;
		addMorphBack: (returnValue := SBStringMorph new contents: '');
		updateIcon