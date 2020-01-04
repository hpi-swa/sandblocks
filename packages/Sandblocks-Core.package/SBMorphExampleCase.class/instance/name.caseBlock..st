as yet unclassified
name: aString caseBlock: aBlock

	self
		removeAllMorphs;
		addMorphBack: (SBIcon iconRefresh color: Color white; on: #click send: #run to: self);
		addMorphBack: (nameInput := SBTextBubble new contents: aString);
		addMorphBack: aBlock;
		addMorphBack: (statusLabel := (SBStringMorph new on: #click send: #promptChangeStatus to: self));
		updateLabel