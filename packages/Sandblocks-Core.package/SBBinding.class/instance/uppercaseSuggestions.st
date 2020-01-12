as yet unclassified
uppercaseSuggestions

	self flag: #todo. "pool dict etc"
	^ Array streamContents: [:stream |
		Smalltalk keysAndValuesDo: [:key :value |
			(key sandblockMatch: self contents) ifTrue: [
				stream nextPut: (SBSuggestionItem selector: key label: ((value isBehavior and: [key == value name]) ifTrue: ['class'] ifFalse: ['global']))]]]