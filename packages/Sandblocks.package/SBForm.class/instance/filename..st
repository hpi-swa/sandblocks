as yet unclassified
filename: aString

	| form |
	filename := aString.
	
	[form := Form fromFileNamed: aString] on: Error do: [
		image visible: false; ignoreLayout: true.
		infoLabel contents: 'invalid image'.
		^ self].
	
	infoLabel contents: form extent asString.
	image visible: true; ignoreLayout: false; image: (form scaledIntoFormOfSize: 48 asPoint)