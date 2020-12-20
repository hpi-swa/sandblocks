as yet unclassified
saveTryFixing: aBoolean quick: anotherBoolean

	stream position: self submorphs second parsedContents.
	self stream: stream.
	^ true