as yet unclassified
isBinary

	^ self selector ifNotEmpty: [:s | s allSatisfy: #isSpecial] ifEmpty: [false]