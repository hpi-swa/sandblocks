action
addAll: aCollection in: anOwnerMorph at: aNumber

	undo add: [aCollection do: [:m | m delete]].
	aCollection withIndexDo: [:m :index |
		anOwnerMorph addMorph: m asElementNumber: aNumber + index.
		self added: m]