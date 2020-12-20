as yet unclassified
contents: aString

	text contents: ((aString notEmpty and: [aString last = $:]) ifTrue: [aString allButLast] ifFalse: [aString])