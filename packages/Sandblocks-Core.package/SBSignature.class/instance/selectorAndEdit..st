as yet unclassified
selectorAndEdit: aString

	self selector: aString.
	
	self containingSandblock sandblockEditor endInput.
	self arguments detect: #isUnknown ifFound: [:u | self sandblockEditor startInput: u at: 0 replacingContents: false] ifNone: []