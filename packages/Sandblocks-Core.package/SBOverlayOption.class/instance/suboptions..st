as yet unclassified
suboptions: aCollection

	suboptions := aCollection.
	aCollection do: [:morph | morph parentOption: self]