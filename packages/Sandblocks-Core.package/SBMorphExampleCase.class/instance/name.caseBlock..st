initialization
name: aString caseBlock: aBlock

	self
		removeAllMorphs;
		addMorphBack: (SBIcon iconRefresh color: Color white; on: #click send: #run to: self);
		addMorphBack: (nameInput := SBTextBubble new contents: aString);
		addMorphBack: aBlock;
		addMorphBack: (statusLabel := (SBStringMorph new on: #click send: #toggleRestart to: self));
		updateLabel