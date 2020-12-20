as yet unclassified
extractKeywords: aString

	| parts |
	parts := aString splitBy: ':'.
	parts size = 1 ifTrue: [^ parts].
	
	^ parts allButLast collect: [:p | p, ':']