saving
veryDeepCopyWith: deepCopier

	| new |
	"Avoid having copies of browsers. Therefore we exclude the whole replacement and simply return a copy an equivalent annotation.
	If only the browser would be omitted, then the replacement would still try to refresh its non exsistent examples when asked for its sourceString.
	Therfore the best solution is to simply give a copy of the examples array."
	new := String streamContents: [:stream |
		stream nextPutAll: 'class {'.
		self writeSourceOn: stream.
		stream nextPutAll: '}'].
	^ (SBJavascript parseElement: new) access body member