as yet unclassified
writeSourceOn: aStream

	self submorphCount = 1
		ifTrue: [self firstSubmorph writeSourceOn: aStream]
		ifFalse: [
			aStream nextPut: ${.
			self submorphs do: [:m | m writeSourceOn: aStream] separatedBy: [aStream nextPut: $.].
			aStream nextPut: $}]