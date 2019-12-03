as yet unclassified
name: aString caseBlock: aBlock

	self
		removeAllMorphs;
		addMorphBack: (SBIcon iconPlay small; color: Color white; on: #click send: #run to: self);
		addMorphBack: (nameInput := SBTextBubble new contents: aString);
		addMorphBack: aBlock