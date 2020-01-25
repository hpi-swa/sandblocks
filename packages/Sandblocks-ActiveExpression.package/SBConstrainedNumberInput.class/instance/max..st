as yet unclassified
max: aNumber

	super max: aNumber.
	self contents: self value asString, ' /', self max asString