as yet unclassified
class: aClass

	className contents: aClass name.
	superClassName contents: (aClass superclass ifNil: ['ProtoObject'] ifNotNil: #name).
	instanceVariables contents: (aClass instVarNames collect: [:name | SBDeclarationForInstanceVariable new contents: name]).
	classVariables contents: (aClass classVarNames collect: [:name | SBDeclarationForPoolVariable new contents: name]).
	poolDictionaries contents: (aClass sharedPools collect: [:name | SBTextBubble new contents: name]).
	category contents: (aClass environment organization categoryOfElement: aClass name).
	class := aClass