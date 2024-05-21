Class {
	#name : #Measurements,
	#superclass : #Object,
	#category : #'Joana-Core'
}

{ #category : #'as yet unclassified' }
Measurements >> filterAll [

	^ {
	"nur über code"
	[Measurements new filterNothing]. 
	[Measurements new filterOnlyExample]. 
	[Measurements new filterOnlyVariants]. 
	[Measurements new filterExampleWatch].  
	[Measurements new filterAllElements].
	"manuell sandblock bauen und example ausführen was da drin ist"
	[Measurements new filterNothingExample].
	[Measurements new filterExampleWatchExample].


	[Measurements new filterAllElementsExampleBerries8Bit ].
	[Measurements new filterAllElementsExampleBerriesDimmed].

	[Measurements new filterAllElementsExampleBerriesEmboss030].
	[Measurements new filterAllElementsExampleBerriesEmboss031].
	[Measurements new filterAllElementsExampleBerriesEmboss100].
	[Measurements new filterAllElementsExampleBerriesEmboss101].
	[Measurements new filterAllElementsExampleBerriesEmboss220].
	[Measurements new filterAllElementsExampleBerriesEmboss221].


	[Measurements new filterAllElementsExampleCat8Bit ].
	[Measurements new filterAllElementsExampleBerriesDimmed].

	[Measurements new filterAllElementsExampleCatEmboss030].
	[Measurements new filterAllElementsExampleCatEmboss031].
	[Measurements new filterAllElementsExampleCatEmboss100].
	[Measurements new filterAllElementsExampleCatEmboss101].
	[Measurements new filterAllElementsExampleCatEmboss220].
	[Measurements new filterAllElementsExampleCatEmboss221].
	} collect: #value.
]

{ #category : #'with code - filters' }
Measurements >> filterAllElements [

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 1
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.
	
	"warmup"
	1 to: self runs do: [:i | RuntimeComparisons new main].
	
	^ (([1 to: self runs do: [:i | RuntimeComparisons new main]] timeToRun) / self runs) asFloat
	
	
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleBerries8Bit [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 2
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 2
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 3
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleBerriesDimmed [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 2
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 2
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 2
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleBerriesEmboss030 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 2
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 2
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 1
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleBerriesEmboss031 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 2
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 2
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 2
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleBerriesEmboss100 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 2
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 1
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleBerriesEmboss101 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 2
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 2
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleBerriesEmboss220 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 2
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 3
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 1
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleBerriesEmboss221 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 2
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 3
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 2
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleCat8Bit [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 2
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 3
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleCatDimmed [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 2
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 2
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleCatEmboss030 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 2
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 1
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleCatEmboss031 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 2
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 2
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleCatEmboss100 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 1
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleCatEmboss101 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 2
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleCatEmboss220 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 3
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 1
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterAllElementsExampleCatEmboss221 [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 3
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 2
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
]

{ #category : #'with code - filters' }
Measurements >> filterExampleWatch [

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := Images cat.
	filtered := ImageOperations emboss: original factor: 1.0 bias: 0.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.
	
	"warmup"
	1 to: self runs do: [:i | RuntimeComparisons new main].
	
	^ (([1 to: self runs do: [:i | RuntimeComparisons new main]] timeToRun) / self runs) asFloat
	
	
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterExampleWatchExample [

	| sandblock example watch result |

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := Images cat.
	filtered := ImageOperations emboss: original factor: 1.0 bias: 0.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.
	
	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	^ result
	
	


]

{ #category : #'with sandblocks - filters' }
Measurements >> filterGatherWidgets [

	| sandblock example result editor |

	editor := SBEditor open.
	SBMultiverse resolveIn: editor. "NO OTHER WIDGETS!"

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 1
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	editor openMorph: sandblock.
	example startRunning.

	"warmup"
	1 to: self runs do: [:i | 
		SBMultiverse bigbangInEditorWithoutKaboom: editor].
	
	result:= (([1 to: self runs do: [:i | 
		SBMultiverse bigbangInEditorWithoutKaboom: editor]] timeToRun) / self runs) asFloat.
	
	"teardown"
	editor close.
	
	^ result
	
	


]

{ #category : #'with sandblocks - filters' }
Measurements >> filterGenerateMultiverse [

	| sandblock example result editor multiverse |

	editor := SBEditor open.
	SBMultiverse resolveIn: editor. "NO OTHER WIDGETS!"

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 1
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	editor openMorph: sandblock.
	example startRunning.
	multiverse := SBMultiverse bigbangInEditorWithoutKaboom: editor.

	"warmup"
	1 to: self runs do: [:i | 
		multiverse kaboom].
	
	result:= (([1 to: self runs do: [:i | 
		multiverse kaboom]] timeToRun) / self runs) asFloat.
	
	"teardown"
	editor close.
	
	^ result
	
	


]

{ #category : #'with code - filters' }
Measurements >> filterNothing [

	MyImageFilter compile: 'main

	| original filtered |
	original := Images cat.
	filtered := ImageOperations emboss: original factor: 1.0 bias: 0.
	^ filtered'.
	
	"warmup"
	1 to: self runs do: [:i | RuntimeComparisons new main].
	
	^ (([1 to: self runs do: [:i | RuntimeComparisons new main]] timeToRun) / self runs) asFloat
	
	
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterNothingExample [

	| sandblock example|

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := Images cat.
	filtered := ImageOperations emboss: original factor: 1.0 bias: 0.
	^ filtered'.
	
	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.

	"warmup"
	1 to: self runs do: [:i | example runSynch].
	
	^ (([1 to: self runs do: [:i | example runSynch ]] timeToRun) / self runs) asFloat
]

{ #category : #'with code - filters' }
Measurements >> filterOnlyExample [

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := Images cat.
	filtered := ImageOperations emboss: original factor: 1.0 bias: 0.
	^ filtered'.
	
	"warmup"
	1 to: self runs do: [:i | RuntimeComparisons new main].
	
	^ (([1 to: self runs do: [:i | RuntimeComparisons new main]] timeToRun) / self runs) asFloat
	
	
]

{ #category : #'with code - filters' }
Measurements >> filterOnlyVariants [

	MyImageFilter compile: 'main

	| original filtered |
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 2
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ filtered'.
	
	"warmup"
	1 to: self runs do: [:i | RuntimeComparisons new main].
	
	^ (([1 to: self runs do: [:i | RuntimeComparisons new main]] timeToRun) / self runs) asFloat
	
	
]

{ #category : #'with sandblocks - filters' }
Measurements >> filterVisualizeMultiverse [

	| sandblock example result editor multiverse exploriants |

	editor := SBEditor open.
	SBMultiverse resolveIn: editor. "NO OTHER WIDGETS!"

	MyImageFilter compile: 'main

	| original filtered |
	self example: [MyImageFilter new] args: [{}] label: ''example''.
	original := SBVariant
		named: ''original''
		associations: {'''' -> [Images cat]. '''' -> [Images berries]}
		activeIndex: 1
		id: ''a126c416-5581-6145-9e64-a990e19e22a5''
		isActive: true.
	filtered := SBVariant
		named: ''filtered''
		associations: {
			''emboss'' -> [
				ImageOperations
					emboss: original
					factor: (SBVariant
						named: ''factor:''
						associations: {'''' -> [1]. '''' -> [0.3]. '''' -> [2.2]}
						activeIndex: 1
						id: ''0e40aa63-5c5b-8c42-9182-f34f73fed9b5''
						isActive: true)
					bias: (SBVariant
						named: ''bias:''
						associations: {'''' -> [0]. '''' -> [1]}
						activeIndex: 1
						id: ''67e9b295-d0aa-2340-ab34-1091e70c12a1''
						isActive: true)].
			''dimmed'' -> [ImageOperations dimmed: original].
			''as8Bit'' -> [ImageOperations as8Bit: original]}
		activeIndex: 1
		id: ''b647d310-06e1-d947-b154-42e0edaa948a''
		isActive: true.
	^ SBExampleWatch report: filtered for: 391394467 modifying: [:each | each]'.

	"get sandblock"
	sandblock := (MyImageFilter compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	editor openMorph: sandblock.
	example startRunning.
	multiverse := SBMultiverse bigbangInEditorSynchKaboom: editor.
	SBExploriants deleteUniqueInstance.
	exploriants := SBExploriants uniqueInstance.
	editor openMorph: exploriants.
	 
	"warmup"
	1 to: self runs do: [:i | 
		exploriants multiverse: multiverse.
		(exploriants namedBlocks detect: #isCustomView) views do: #visualize.
		exploriants namedBlocks do:#visualize.].
	
	result:= (([1 to: self runs do: [:i |
		exploriants multiverse: multiverse.
		(exploriants namedBlocks detect: #isCustomView) views do: #visualize.
		exploriants namedBlocks do:#visualize.]] timeToRun) / self runs) asFloat.
	
	"teardown"
	editor close.
	
	^ result
	
	


]

{ #category : #'as yet unclassified' }
Measurements >> runAll [

	^ {
	"nur über code"
	[Measurements new runtimeNothing]. 
	[Measurements new runtimeOnlyExample]. 
	[Measurements new runtimeOnlyVariants]. 
	[Measurements new runtimeExampleWatch].  
	[Measurements new runtimeAllElements].
	"manuell sandblock bauen und example ausführen was da drin ist"
	[Measurements new runtimeNothingExample].
	[Measurements new runtimeExampleWatchExample].

	[Measurements new runtimeAllElementsExampleSortedHashSet ].
	[Measurements new runtimeAllElementsExampleRandomHashSet].
	[Measurements new runtimeAllElementsExampleRandomCustom100].
	[Measurements new runtimeAllElementsExampleRandomCustom1000].
	[Measurements new runtimeAllElementsExampleRandomCustom10000].
	[Measurements new runtimeAllElementsExampleSortedCustom100].
	[Measurements new runtimeAllElementsExampleSortedCustom1000].
	[Measurements new runtimeAllElementsExampleSortedCustom10000].
	} collect: #value.
]

{ #category : #constants }
Measurements >> runs [

	^ 30
]

{ #category : #'with code' }
Measurements >> runtimeAllElements [

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 1
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 1
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 1
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"warmup"
	1 to: self runs do: [:i | RuntimeComparisons new main].
	
	^ (([1 to: self runs do: [:i | RuntimeComparisons new main]] timeToRun) / self runs) asFloat
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeAllElementsExampleRandomCustom100 [

	| sandblock example watch result |

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 2
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 1
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 2
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeAllElementsExampleRandomCustom1000 [

	| sandblock example watch result |

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 2
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 2
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 2
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeAllElementsExampleRandomCustom10000 [

	| sandblock example watch result |

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 2
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 3
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 2
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeAllElementsExampleRandomHashSet [

	| sandblock example watch result |

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 2
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 1
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 1
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeAllElementsExampleSortedCustom100 [

	| sandblock example watch result |

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 1
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 1
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 2
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeAllElementsExampleSortedCustom1000 [

	| sandblock example watch result |

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 1
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 2
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 2
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeAllElementsExampleSortedCustom10000 [

	| sandblock example watch result |

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 1
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 3
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 2
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeAllElementsExampleSortedHashSet [

	| sandblock example watch result |

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 1
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 1
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 1
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	
	^ result
	
	


]

{ #category : #'with code' }
Measurements >> runtimeExampleWatch [

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := (1 to: 1000000) collect: [:aNumber | aNumber].
	set := HashSet new.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"warmup"
	1 to: self runs do: [:i | RuntimeComparisons new main].
	
	^ (([1 to: self runs do: [:i | RuntimeComparisons new main]] timeToRun) / self runs) asFloat
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeExampleWatchExample [

	| sandblock example watch result |

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := (1 to: 1000000) collect: [:aNumber | aNumber].
	set := HashSet new.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	watch := sandblock containedExampleWatches first.
	SBExampleWatch registerWatch: watch.

	"warmup"
	1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example].
	
	result:= (([1 to: self runs do: [:i | 
		watch exampleStarting: example.
		example runSynch.
		watch exampleFinished: example]] timeToRun) / self runs) asFloat.
	
	"teardown"
	SBExampleWatch unregisterWatch: watch.
	^ result
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeGatherWidgets [

	| sandblock example result editor |

	editor := SBEditor open.
	SBMultiverse resolveIn: editor. "NO OTHER WIDGETS!"

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 1
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 1
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 1
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	editor openMorph: sandblock.
	example startRunning.

	"warmup"
	1 to: self runs do: [:i | 
		SBMultiverse bigbangInEditorWithoutKaboom: editor].
	
	result:= (([1 to: self runs do: [:i | 
		SBMultiverse bigbangInEditorWithoutKaboom: editor]] timeToRun) / self runs) asFloat.
	
	"teardown"
	editor close.
	
	^ result
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeGenerateMultiverse [

	| sandblock example result editor multiverse |

	editor := SBEditor open.
	SBMultiverse resolveIn: editor. "NO OTHER WIDGETS!"

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 1
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 1
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 1
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.
	editor openMorph: sandblock.
	example startRunning.
	multiverse := SBMultiverse bigbangInEditorWithoutKaboom: editor.

	"warmup"
	1 to: self runs do: [:i | 
		multiverse kaboom].
	
	result:= (([1 to: self runs do: [:i | 
		multiverse kaboom]] timeToRun) / self runs) asFloat.
	
	"teardown"
	editor close.
	
	^ result
	
	


]

{ #category : #'with code' }
Measurements >> runtimeNothing [

	RuntimeComparisons compile: 'main
	| workload set |
	workload := (1 to: 1000000) collect: [:aNumber | aNumber].
	set := HashSet new.
	[workload do: [:aNumber | set add: aNumber]] timeToRun'.

	"warmup"
	1 to: self runs do: [:i | RuntimeComparisons new main].
	
	^ (([1 to: self runs do: [:i | RuntimeComparisons new main]] timeToRun) / self runs) asFloat
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeNothingExample [

	| sandblock example|

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := (1 to: 1000000) collect: [:aNumber | aNumber].
	set := HashSet new.
	[workload do: [:aNumber | set add: aNumber]] timeToRun'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	example := sandblock containedExamples first.

	"warmup"
	1 to: self runs do: [:i | example runSynch].
	
	^ (([1 to: self runs do: [:i | example runSynch ]] timeToRun) / self runs) asFloat
	
	


]

{ #category : #'with code' }
Measurements >> runtimeOnlyExample [

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := (1 to: 1000000) collect: [:aNumber | aNumber].
	set := HashSet new.
	[workload do: [:aNumber | set add: aNumber]] timeToRun'.

	"warmup"
	1 to: self runs do: [:i | RuntimeComparisons new main].
	
	^ (([1 to: self runs do: [:i | RuntimeComparisons new main]] timeToRun) / self runs) asFloat
	
	


]

{ #category : #'with code' }
Measurements >> runtimeOnlyVariants [

	RuntimeComparisons compile: 'main
	| workload set |
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 1
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 1
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 1
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
		[workload do: [:aNumber | set add: aNumber]] timeToRun'.

	"warmup"
	1 to: self runs do: [:i | RuntimeComparisons new main].
	
	^ (([1 to: self runs do: [:i | RuntimeComparisons new main]] timeToRun) / self runs) asFloat
	
	


]

{ #category : #'with sandblocks' }
Measurements >> runtimeVisualizeMultiverse [

	| sandblock example result editor multiverse exploriants |

	editor := SBEditor open.
	SBMultiverse resolveIn: editor. "NO OTHER WIDGETS!"

	RuntimeComparisons compile: 'main
	| workload set |
	self example: [RuntimeComparisons new] args: [{}] label: ''example''.
	workload := SBVariant
		named: ''workload''
		associations: {
			''ordered'' -> [(1 to: 1000000) collect: [:aNumber | aNumber]].
			''random'' -> [(1 to: 1000000) collect: [:aNumber | Random new next]]}
		activeIndex: 1
		id: ''6e1ceaf8-c636-2a48-9a38-d0f1b5aa9179''
		isActive: true.
	set := SBVariant
		named: ''set''
		associations: {
			'''' -> [HashSet new].
			'''' -> [
				CustomHashSet reserve: (SBVariant
					named: ''reserve:''
					associations: {'''' -> [100]. '''' -> [1000]. '''' -> [10000]}
					activeIndex: 1
					id: ''3c9b78de-a961-1b40-9629-2c9db7d9c24f''
					isActive: true)]}
		activeIndex: 1
		id: ''ad068d8c-76f1-6347-81f6-55d1300ca3d3''
		isActive: true.
	SBExampleWatch
		report: [workload do: [:aNumber | set add: aNumber]] timeToRun
		for: 653165203
		modifying: [:each | each]'.

	"get sandblock"
	sandblock := (RuntimeComparisons compiledMethodAt: #main) asSandblock. 
	editor openMorph: sandblock.
	example := sandblock containedExamples first.
	example startRunning.
	multiverse := SBMultiverse bigbangInEditorSynchKaboom: editor.
	SBExploriants deleteUniqueInstance.
	exploriants := SBExploriants uniqueInstance.
	editor openMorph: exploriants.
	 
	"warmup"
	1 to: self runs do: [:i | 
		exploriants multiverse: multiverse.
		(exploriants namedBlocks detect: #isCustomView) views do: #visualize.
		exploriants namedBlocks do:#visualize.].
	
	result:= (([1 to: self runs do: [:i |
		exploriants multiverse: multiverse.
		(exploriants namedBlocks detect: #isCustomView) views do: #visualize.
		exploriants namedBlocks do:#visualize.]] timeToRun) / self runs) asFloat.
	
	"teardown"
	editor close.
	
	^ result
	
	


]
