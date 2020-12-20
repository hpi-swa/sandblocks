Extension { #name : #String }

{ #category : #'*RatPack-Core' }
String >> base64UrlDecoded [
	
	| processedString |
	processedString := self.
	processedString := processedString copyReplaceAll: '_' with: '/'.
	processedString := processedString copyReplaceAll: '-' with: '+'.
	
	^ processedString  base64Decoded.
	
]

{ #category : #'*RatPack-Core' }
String >> base64UrlEncoded [
	
	| processedString |
	processedString := self base64Encoded.
	processedString := (processedString subStrings: '=') first.
	processedString := processedString copyReplaceAll: '/' with: '_'.
	processedString := processedString copyReplaceAll: '+' with: '-'.
	
	^ processedString
]
