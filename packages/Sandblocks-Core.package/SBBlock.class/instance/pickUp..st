as yet unclassified
pickUp: anEvent

	| editor |
	editor := self sandblockEditor.
	
	anEvent hand grabMorph: (SBSelection new
		homeArtefact: self containingArtefact;
		methodClass: (self containingArtefact ifNotNil: #relatedClass);
		colorPolicy: self colorPolicy;
		addMorphBack: self veryDeepCopy;
		sourceBlock: self;
		onAbortUndoIn: editor;
		yourself).
	
	anEvent shiftPressed ifFalse: [
		(self parentSandblock deleteCommandFor: self) ifNotNil: [:cmd |
			editor do: (cmd shouldMergeWithNext: true)]]