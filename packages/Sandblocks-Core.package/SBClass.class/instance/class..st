as yet unclassified
class: aClass

	className contents: aClass name.
	superClassName contents: (aClass superclass ifNil: ['ProtoObject'] ifNotNil: #name).
	instanceVariables contents: (aClass instVarNames collect: [:name | SBName contents: name]).
	classVariables contents: (aClass classVarNames collect: [:name | SBName contents: name]).
	poolDictionaries contents: (aClass sharedPools collect: [:pool | SBTextBubble new contents: (aClass environment keyAtIdentityValue: pool ifAbsent: ['private'])]).
	category contents: (aClass environment organization categoryOfElement: aClass theNonMetaClass name).
	class := aClass