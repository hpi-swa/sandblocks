as yet unclassified
newFor: aBlock

	^ self new
		comment: aBlock arguments first contents
		active: aBlock arguments second parsedContents
		do: aBlock arguments third childSandblocks