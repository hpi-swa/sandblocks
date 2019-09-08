as yet unclassified
label: aString

	label contents: aString.
	self listCentering: (aString ifEmpty: [#center] ifNotEmpty: [#topLeft])