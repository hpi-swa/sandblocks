as yet unclassified
createExample: aString

	^ SBTextBubble new
		contents: aString;
		when: #contentsChanged send: #checkExamples to: self;
		yourself