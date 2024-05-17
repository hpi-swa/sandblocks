Class {
	#name : #MyImageFilter,
	#superclass : #Object,
	#category : #'Joana-Core'
}

{ #category : #'as yet unclassified' }
MyImageFilter >> main [

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: 'example'.
	original := SBVariant
		named: 'original'
		associations: {'' -> [Images cat]. '' -> [Images berries]}
		activeIndex: 1
		id: 'a126c416-5581-6145-9e64-a990e19e22a5'
		isActive: true.
	filtered := SBVariant
		named: 'filtered'
		associations: {
			'emboss' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: 'factor:'
						associations: {'' -> [1]. '' -> [0.3]. '' -> [2.2]}
						activeIndex: 3
						id: '0e40aa63-5c5b-8c42-9182-f34f73fed9b5'
						isActive: true)
					bias: (SBVariant
						named: 'bias:'
						associations: {'' -> [0]. '' -> [1]}
						activeIndex: 2
						id: '67e9b295-d0aa-2340-ab34-1091e70c12a1'
						isActive: true)].
			'dimmed' -> [ImageOperations dimmed: original].
			'as8Bit' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: 'b647d310-06e1-d947-b154-42e0edaa948a'
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]
]
