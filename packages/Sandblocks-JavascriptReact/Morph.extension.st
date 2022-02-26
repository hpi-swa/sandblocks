Extension { #name : #Morph }

{ #category : #'*Sandblocks-JavascriptReact' }
Morph >> collectComponentUsageReplacements [

	| componentUsageReplacements |
	componentUsageReplacements := Set new.
	self submorphsDo: [:morph | componentUsageReplacements addAll: morph collectComponentUsageReplacements].
	^ componentUsageReplacements
]
