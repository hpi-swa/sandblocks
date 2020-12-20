as yet unclassified
newFor: aBubble

	^ aBubble selector = 'asRegex'
		ifTrue: [
			self new regexString: aBubble receiver contents examples: #()]
		ifFalse: [
			self new
				regexString: aBubble arguments first contents
				examples: (aBubble arguments second childSandblocks collect: #contents)]