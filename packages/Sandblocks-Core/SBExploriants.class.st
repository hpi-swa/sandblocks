Class {
	#name : #SBExploriants,
	#superclass : #SBBlock,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'Sandblocks-Core'
}

{ #category : #accessing }
SBExploriants class >> deleteUniqueInstance [ 

	uniqueInstance := nil
]

{ #category : #'instance creation' }
SBExploriants class >> new [

	^ self error: 'Singleton. Use #uniqueInstance'
]

{ #category : #accessing }
SBExploriants class >> uniqueInstance [ 

	^ uniqueInstance ifNil: [uniqueInstance := super new]
]

{ #category : #comparing }
SBExploriants >> = other [

	^ self class = other class
]

{ #category : #accessing }
SBExploriants >> allMethodsContainingVariants [

	^ ((self systemNavigation allCallsOn: SBVariant matchingSelector) 
		reject: [:aMethodReference | aMethodReference actualClass = SBVariant class])
		collect: #compiledMethod
]

{ #category : #initialization }
SBExploriants >> initialize [

	super initialize.
	
	self
		attachDecorator: SBMoveDecorator new;
		changeTableLayout;
		listDirection: #topToBottom;
		layoutInset: 8;
		cellGap: 16;
		cellInset: 10;
		hResizing: #shrinkWrap;
		vResizing: #shrinkWrap
]

{ #category : #initialization }
SBExploriants >> visualize [

	self submorphs copy do: #delete.

	self allMethodsContainingVariants 
		collect: [:aCompiledMethod | 
			self blockFor: aCompiledMethod withInterfaces: #(#isEditor) 
				ifOpen: [:existingMethodBlock | existingMethodBlock] 
				ifClosed: [aCompiledMethod asSandblock]]
		thenDo: [:aSBStMethod | 
			self addMorphBack: aSBStMethod methodHeader copy.
			aSBStMethod containedVariants do: [:aSBVariant | 
				self addMorphBack: (SBVariantProxy for: aSBVariant)].
			self addMorphBack: (LineMorph from: 0@0 to: 50@0 color: Color black width: 2)].
	
		
	
]
