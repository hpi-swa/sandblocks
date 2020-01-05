as yet unclassified
update

	self block
		setProperty: #sandblockBlockColor toValue: (active parsedContents ifTrue: [previousBlockColor] ifFalse: [Color white]);
		changed