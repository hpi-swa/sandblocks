Class {
	#name : #SBExploriantsView,
	#superclass : #SBNamedBlock,
	#category : #'Sandblocks-Core'
}

{ #category : #'instance creation' }
SBExploriantsView class >> asTabView [

	^ SBTabView
		namedBlocks: (self subclasses collect: #new)
		activeIndex: 1 
]

{ #category : #'instance creation' }
SBExploriantsView class >> block: aSBBlock named: aString [

	"only calling new allowed to guarantee intented purpose"
	self shouldNotImplement 
]

{ #category : #accessing }
SBExploriantsView >> allCompiledMethodsContainingClass: aClass [

	"aClass should have #matchingSelectors implemented"
	^ (((aClass matchingSelectors collect: [:aSelector | self systemNavigation allCallsOn: aSelector]) flatten)
		reject: [:aMethodReference | aMethodReference actualClass = aClass class])
		collect: #compiledMethod
]

{ #category : #accessing }
SBExploriantsView >> allCompiledMethodsContainingVariants [

	^ self allCompiledMethodsContainingClass: SBVariant
]

{ #category : #accessing }
SBExploriantsView >> allMethodBlocksContainingVariants [

	"We are looking for already opened methods so that we can assign the
	variant there as the original in SBVariantProxy. That way, we immediately
	have consistency between changes."
	^ self findExistingOrConvertToBlocks: self allCompiledMethodsContainingVariants 

]

{ #category : #actions }
SBExploriantsView >> clean [

	self block submorphs copy do: #delete
]

{ #category : #building }
SBExploriantsView >> containerRow [

	^  SBRow new
		color: Color transparent;
		vResizing: #shrinkWrap;
		hResizing: #shrinkWrap;
		cellPositioning: #topLeft;
		changeTableLayout;
		listDirection: #leftToRight;
		layoutInset: 8;
		cellGap: 3;
		cellInset: 3;
		borderWidth: 0
]

{ #category : #accessing }
SBExploriantsView >> findExistingOrConvertToBlocks: aCollectionOfCompiledMethods [ 

	^ aCollectionOfCompiledMethods
		collect: [:aCompiledMethod | 
			SBEditor current blockFor: aCompiledMethod withInterfaces: #(#isMethod) 
				ifOpen: [:existingMethodBlock | existingMethodBlock] 
				ifClosed: [aCompiledMethod asSandblock]]
]

{ #category : #initialization }
SBExploriantsView >> initialize [

	super initialize.
	
	self block: (SBBlock new
		changeTableLayout;
		color: Color white;
		listDirection: #topToBottom;
		layoutInset: 3;
		cellGap: 4;
		cellInset: 2;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap)
]

{ #category : #actions }
SBExploriantsView >> visualize [ 

	self subclassResponsibility 
]
