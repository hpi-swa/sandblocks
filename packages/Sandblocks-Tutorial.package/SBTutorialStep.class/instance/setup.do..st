as yet unclassified
setup: anEditor do: aBlock

	selector := thisContext sender method homeMethod selector.
	setup := aBlock.
	self reset: anEditor.
	self stepIndex > 1 ifTrue: [
		buttons addMorphBack: (SBButton new
			balloonText: 'Previous Task';
			icon: SBIcon iconArrow_left shortcut: nil do: [self previous])].
	self stepIndex < self class tutorialSteps size ifTrue: [
		buttons addMorphBack: (SBButton new
			balloonText: 'Next Task';
			icon: SBIcon iconArrow_right shortcut: nil do: [self next])]