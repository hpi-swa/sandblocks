as yet unclassified
merge: aMorph withLabels: aStringCollection type: aSymbol

	" add new ones "
	aMorph submorphCount + 1 to: aStringCollection size do: [:index |
		aMorph addMorphBack: (SBNewNodeSocket new type: aSymbol)].
	
	" remove left overs "
	aStringCollection size + 1 to: aMorph submorphCount do: [:index |
		aMorph removeMorph: aMorph lastSubmorph].
	
	" update label "
	aMorph submorphs with: aStringCollection do: [:morph :label  | morph label: label]