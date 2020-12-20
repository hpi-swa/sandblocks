as yet unclassified
capabilitiesFrom: aClass

	^ (aClass class methodDict values select: [:method |
		(method selector beginsWith: 'is') and: [method selector isUnary]]) collect: #selector