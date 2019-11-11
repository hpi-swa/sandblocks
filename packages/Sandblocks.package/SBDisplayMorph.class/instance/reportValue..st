as yet unclassified
reportValue: aMorph

	| form |
	form := aMorph imageForm.
	self image: ((form width > 100 or: [form height > 100])
		ifTrue: [form scaledIntoFormOfSize: 100 asPoint]
	 	ifFalse: [form])