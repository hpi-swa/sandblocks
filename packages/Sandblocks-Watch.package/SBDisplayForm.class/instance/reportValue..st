as yet unclassified
reportValue: aForm

	self image: ((aForm width > 100 or: [aForm height > 100])
		ifTrue: [aForm scaledIntoFormOfSize: 100 asPoint]
	 	ifFalse: [aForm copy])