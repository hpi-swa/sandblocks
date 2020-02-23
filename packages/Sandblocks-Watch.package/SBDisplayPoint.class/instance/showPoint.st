as yet unclassified
showPoint

	pointers := Array streamContents: [:stream |
		self sandblockEditor allActiveMorphExamples do: [:example |
			example view addMorph: (stream nextPut: (Morph new extent: 8 asPoint; center: lastPoint; color: Color green))]]