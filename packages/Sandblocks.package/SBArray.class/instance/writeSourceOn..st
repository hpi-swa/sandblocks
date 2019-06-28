converting
writeSourceOn: aStream

	aStream nextPutAll: '{'.
	self submorphs do: [:m | m writeSourceOn: aStream] separatedBy: [aStream nextPutAll: '. '].
	aStream nextPutAll: '}'