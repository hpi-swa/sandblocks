as yet unclassified
self: aBlock args: aCollectionBlock label: aString

	self
		removeAllMorphs;
		addMorphBack: (icon := ECSIcon iconPause color: Color white);
		addMorphBack: (nameInput := SBTextBubble new contents: aString);
		addMorphBack: (SBStringMorph new contents: 'self:');
		addMorphBack: aBlock;
		addMorphBack: (SBStringMorph new contents: 'args:');
		addMorphBack: aCollectionBlock;
		updateIcon