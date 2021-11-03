Class {
	#name : #SBTreeDecorator,
	#superclass : #SBBlockDecorator,
	#instVars : [
		'children',
		'depth',
		'mod',
		'parent',
		'x',
		'ancestor',
		'shift',
		'change'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #'as yet unclassified' }
SBTreeDecorator class >> createExampleIn: aContainer [

	| child1 child2 root child3 |
	root := SBTreeDecorator new.
	aContainer addMorph: (SBStPlayground new
		attachDecorator: root;
		detachDecorators: SBForceMoveDecorator).
	child1 := root addExampleChildIn: aContainer.
	child2 := root addExampleChildIn: aContainer.
	child3 := root addExampleChildIn: aContainer.
	child1
		addExampleChildIn: aContainer;
		addExampleChildIn: aContainer.
	child3
		addExampleChildIn: aContainer;
		addExampleChildIn: aContainer.
	root layout
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> addChild: aDecorator [

	self children add: aDecorator.
	aDecorator parent: self.
	self morph containingFloat owner addMorphBack: (SBConnectorLine connect: self morph to: aDecorator morph)
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> addExampleChildIn: aContainer [

	| child |
	child := SBTreeDecorator new.
	aContainer addMorph: (SBStPlayground new
		attachDecorator: child;
		detachDecorators: SBForceMoveDecorator;
		attachDecorator: SBMoveDecorator new).
	self addChild: child.
	^ child
]

{ #category : #accessing }
SBTreeDecorator >> ancestor [

	^ ancestor
]

{ #category : #accessing }
SBTreeDecorator >> ancestor: anObject [

	ancestor := anObject
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> apportion: defaultAncestor [

	| left shift sil sir sol sor vil vir vol vor newDefaultAncestor |
	newDefaultAncestor := defaultAncestor.
	left := self leftSibling.
	left ifNotNil: [
		vir := self.
		vor := self.
		vil := left.
		vol := self leftMostSibling.
		sir := self mod.
		sor := self mod.
		sil := vil mod.
		sol := vol mod.
		[vil children notEmpty and: vir children notEmpty] whileTrue: [
			vil := vil children last.
			vir := vir children first.
			vol := vol children first.
			vor := vor children last.
			shift := vil x + sil - (vir x + sir) + self distance.
			vor ancestor: self.
			shift > 0 ifTrue: [ | a |
				a := (self parent children includes: vil ancestor)
					ifTrue: [vil ancestor]
					ifFalse: [defaultAncestor].
				a moveSubtree: self by: shift.
				sir := sir + shift.
				sor := sor + shift].
			sil := sil + vil mod.
			sir := sir + vir mod.
			sol := sol + vol mod.
			sor := sor + vor mod.
			(vil children notEmpty and: vor children isEmpty)
				ifTrue: [vor mod: vor mod + sil - sor]
				ifFalse: [
					(vir children notEmpty and: vol children isEmpty) ifTrue: [vol mod: vol mod + sir - sol].
					newDefaultAncestor := self]]].
	^ newDefaultAncestor
]

{ #category : #accessing }
SBTreeDecorator >> change [

	^ change
]

{ #category : #accessing }
SBTreeDecorator >> change: anObject [

	change := anObject
]

{ #category : #accessing }
SBTreeDecorator >> children [

	^ children
]

{ #category : #accessing }
SBTreeDecorator >> children: anObject [

	children := anObject
]

{ #category : #accessing }
SBTreeDecorator >> depth [

	^ depth
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> depth: aValue [

	depth := aValue
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> distance [

	^ 1
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> example [

	SBMorphExample
		setUp: [SBBlock new]
		cases: {
			SBMorphExampleCase
				name: 'example 1'
				caseBlock: [:container | SBTreeDecorator createExampleIn: container]}
		extent: 1000 @ 1000
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> executeShifts [

	| shift change |
	shift := 0.
	change := 0.
	self children reverseDo: [:child |
		child x: child x + shift.
		child mod: child mod + shift.
		change := change + child change.
		shift := shift + child shift + change]
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> firstWalk [

	| left |
	left := self leftSibling.
	
	self children
		ifEmpty: [left ifNil: [self x: 0] ifNotNil: [self x: left x + self distance]]
		ifNotEmpty: [ | defaultAncestor midpoint |
			defaultAncestor := self children first.
			self children do: [:child |
				child depth: self depth + 1.
				child firstWalk.
				defaultAncestor := child apportion: defaultAncestor].
			self executeShifts.
			midpoint := self children first x + self children last x / 2.
			left ifNil: [self x: midpoint] ifNotNil: [
				self x: left x + self distance.
				self mod: self x - midpoint]]
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> initialize [

	super initialize.
	children := OrderedCollection new.
	depth := 0.
	parent := nil.
	mod := 0.
	shift := 0.
	change := 0
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> layout [

	self
		firstWalk;
		secondWalk: 0
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> leftMostSibling [

	self parent ifNil: [^ nil] ifNotNil: [^ self parent children first]
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> leftSibling [

	self parent ifNil: [^ nil] ifNotNil: [ | last |
		last := nil.
		self parent children do: [:child | child = self ifTrue: [^ last] ifFalse: [last := child]].
		^ self parent children]
]

{ #category : #accessing }
SBTreeDecorator >> mod [

	^ mod
]

{ #category : #accessing }
SBTreeDecorator >> mod: anObject [

	mod := anObject
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> moveSubtree: node by: shift [

	| numberOfSubtrees |
	numberOfSubtrees := node siblingIndex - self siblingIndex.
	node change: node change - shift / numberOfSubtrees.
	node shift: node shift + shift.
	node x: node x + shift.
	node mod: node mod + shift.
	self change: self change + shift / numberOfSubtrees
]

{ #category : #accessing }
SBTreeDecorator >> parent [

	^ parent
]

{ #category : #accessing }
SBTreeDecorator >> parent: anObject [

	parent := anObject
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> secondWalk: modSum [

	self x: self x + modSum.
	self morph position: self x @ self depth * 150.
	self children do: [:child | child secondWalk: modSum + self mod]
]

{ #category : #accessing }
SBTreeDecorator >> shift [

	^ shift
]

{ #category : #accessing }
SBTreeDecorator >> shift: anObject [

	shift := anObject
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> siblingIndex [

	^ self parent ifNotNil: [self parent children indexOf: self] ifNil: [0]
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> traverse [

	| index desiredX |
	index := 0.
	self x: 0.
	self children do: [:child |
		child depth: self depth + 1.
		child traverse.
		index := index + 1.
		child x: index].
	desiredX := self children length - 1 / 2
]

{ #category : #accessing }
SBTreeDecorator >> x [

	^ x
]

{ #category : #'as yet unclassified' }
SBTreeDecorator >> x: aValue [

	x := aValue
]
