as yet unclassified
writeSourceOn: aStream

	examples hasSubmorphs
		ifTrue: [
			aStream nextPut: $(; nextPutAll: self className; nextPutAll: ' regex: '.
			text contents storeOn: aStream.
			aStream nextPutAll: ' examples: #('.
			examples submorphs do: [:morph | morph contents storeOn: aStream] separatedBy: [aStream space].
			aStream nextPutAll: '))']
		ifFalse: [
			text contents storeOn: aStream.
			aStream nextPutAll: ' asRegex']