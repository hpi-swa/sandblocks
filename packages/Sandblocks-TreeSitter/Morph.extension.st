Extension { #name : #Morph }

{ #category : #'*Sandblocks-TreeSitter' }
Morph >> allMorphsMutableDo: aBlock [

	submorphs copy do: [:m | m allMorphsMutableDo: aBlock].
	aBlock value: self
]

{ #category : #'*Sandblocks-TreeSitter' }
Morph >> isInlineBlock [

	^ false
]

{ #category : #'*Sandblocks-TreeSitter' }
Morph >> isMetaBlock [

	^ false
]
