Extension { #name : #SBBlock }

{ #category : #'*Sandblocks-JavascriptReact' }
SBBlock >> isSBJsComponentReplacement [

	^false
]

{ #category : #'*Sandblocks-JavascriptReact' }
SBBlock >> ownerOfType: aString [

	| currentOwner |
	currentOwner := self owner.
	[currentOwner type ~= aString] whileTrue: [currentOwner := currentOwner owner].
	^ currentOwner
]
