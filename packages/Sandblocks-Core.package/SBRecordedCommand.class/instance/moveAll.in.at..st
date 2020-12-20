action
moveAll: aCollection in: anOwnerMorph at: aNumber

	| previousIndices previousOwners |
	previousOwners := aCollection collect: #owner.
	previousIndices := aCollection collect: #submorphIndex.
	undo add: [aCollection with: previousOwners and: previousIndices do: [:m :owner :index | owner addMorph: m asElementNumber: index]].
	
	aCollection withIndexDo: [:m :index |
		anOwnerMorph addMorph: m asElementNumber: aNumber + index.
		self added: m]