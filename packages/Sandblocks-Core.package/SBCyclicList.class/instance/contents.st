as yet unclassified
contents

	^ Array streamContents: [:stream |
		self do: [:value | stream nextPut: value]]