as yet unclassified
selector

	^ cancelled ifTrue: [nil] ifFalse: [editor method selector]