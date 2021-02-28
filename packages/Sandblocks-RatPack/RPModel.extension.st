Extension { #name : #RPModel }

{ #category : #'*Sandblocks-RatPack' }
RPModel >> jsonWriteOn: aStream [

	aStream nextPutAll: self asJson.
]

{ #category : #'*Sandblocks-RatPack' }
RPModel >> objectAsDict [

	^ self class createAttributeDictionaryFor: self object
]

{ #category : #'*Sandblocks-RatPack' }
RPModel >> objectAsJson [

	^ self objectAsDict asJsonString
]
