as yet unclassified
connectFrom: aMorph to: anotherMorph

	scroll addMorph: ((SBConnectorLine new connectorType: #dots)
		color: Color black;
		connect: aMorph to: anotherMorph;
		yourself)