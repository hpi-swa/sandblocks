converting
writeSourceOn: aStream

	self isMethodBody ifFalse: [aStream nextPut: $[].
	
	(bindings hasSubmorphs and: [self isMethodBody not]) ifTrue: [
		bindings submorphsDo: [:m | aStream nextPut: $:. m writeSourceOn: aStream. aStream space].
		aStream nextPut: $|; space].
	
	temporaries writeSourceOn: aStream.
	temporaries hasSubmorphs ifTrue: [aStream cr].
	
	self submorphs allButFirst do: [:m | m writeSourceOn: aStream] separatedBy: [aStream nextPut: $.; cr].
	
	self isMethodBody ifFalse: [aStream nextPut: $]]