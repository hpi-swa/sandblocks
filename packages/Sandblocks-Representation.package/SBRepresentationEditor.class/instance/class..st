as yet unclassified
class: aClass

	object := aClass.
	self classLabel contents: ((aClass ifNotNil: #name) ifNil: ['']).
	self
		addMorph: (aClass class methodDict at: #matches: ifPresent: [:method | method methodNode body asSandblock] ifAbsent: [SBBlockBody empty])
		asElementNumber: 4.
	self
		addMorph: (aClass class methodDict at: #newFor: ifPresent: [:method | method methodNode body asSandblock] ifAbsent: [SBBlockBody empty])
		asElementNumber: 6