as yet unclassified
writeSourceOn: aStream

	self writeSignatureSourceOn: aStream.
	aStream space.
	(SBPragma new selector: self methodInput object asSimpleSetter arguments: {self pathArray submorphs first veryDeepCopy}) writeSourceOn: aStream.
	aStream space.
	self body writeSourceOn: aStream