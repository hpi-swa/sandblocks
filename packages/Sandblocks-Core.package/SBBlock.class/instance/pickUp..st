as yet unclassified
pickUp: anEvent

	anEvent hand attachMorph: (SBSelection new 
		methodClass: self containingArtefact;
		colorPolicy: self colorPolicy;
		addMorphBack: self veryDeepCopy)