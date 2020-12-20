as yet unclassified
matches: anObject

	"| string |
	string := (anObject isString or: [anObject isText])
		ifTrue: [anObject string]
		ifFalse: [
			((anObject respondsTo: #contents) and: [anObject contents isString]) ifTrue: [anObject contents] ifFalse: [^ false]].
	"
	
	^ anObject isText