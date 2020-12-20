as yet unclassified
formatBlockStartOf: aNode startWithNewLine: aBoolean

	stream nextPut: $[.
	aNode arguments ifNotEmpty: [:args |
		args do: [:arg |
			stream nextPut: $:.
			stream nextPutAll: arg name.
			stream space].
		stream nextPut: $|.
		aBoolean ifFalse: [stream space]]