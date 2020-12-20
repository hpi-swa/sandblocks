as yet unclassified
storeOn: aStream
	" NOTE: does not produce valid code! Meant for debugging purposes (morphs are not stored) "

	aStream
		nextPutAll: '(SBAlgebraCommand ';
		nextPutAll: type;
		nextPutAll: ' data: '.
	
	data isArray
		ifTrue: [aStream nextPut: ${. data do: [:e | aStream store: e] separatedBy: [aStream nextPut: $.]. aStream nextPut: $}]
		ifFalse: [
			aStream store: (data isMorph
				ifTrue: ['<morph>']
				ifFalse: [data]).].
				
	aStream
		nextPutAll: ')'