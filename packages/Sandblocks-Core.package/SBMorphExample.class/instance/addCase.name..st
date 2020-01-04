as yet unclassified
addCase: aBlock name: aString

	cases addMorphBack: (SBMorphExampleCase new
		name: aString caseBlock: aBlock;
		when: #run send: #runCase: to: self)