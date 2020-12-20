Extension { #name : #ByteArray }

{ #category : #'*RatPack-Core' }
ByteArray >> base64UrlEncoded [
	
	| processedString |
	processedString := self base64Encoded.
	processedString := (processedString subStrings: '=') first.
	processedString := processedString copyReplaceAll: '/' with: '_'.
	processedString := processedString copyReplaceAll: '+' with: '-'.
	^ processedString
]
