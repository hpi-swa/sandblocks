Extension { #name : #Morph }

{ #category : #'*Sandblocks-JavascriptReact' }
Morph >> collectComponentUsageReplacements [

	| componentUsageReplacements |
	componentUsageReplacements := KeyedSet keyBlock: #componentName.
	self submorphsDo: [:morph | componentUsageReplacements addAll: morph collectComponentUsageReplacements].
	^ componentUsageReplacements
]
