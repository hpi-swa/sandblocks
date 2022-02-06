Extension { #name : #Morph }

{ #category : #'*Sandblocks-JavascriptReact' }
Morph >> collectComponentUsageReplacements [

	|componentUsageReplacements|
	componentUsageReplacements := OrderedCollection new.
	self submorphsDo: [:morph | componentUsageReplacements addAll: (morph collectComponentUsageReplacements)].
	^ componentUsageReplacements
]
