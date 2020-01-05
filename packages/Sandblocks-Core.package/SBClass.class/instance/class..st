as yet unclassified
class: aClass

	className contents: aClass name.
	superClassName contents: (aClass superclass ifNil: ['ProtoObject'] ifNotNil: #name).
	instanceVariables contents: (aClass instVarNames collect: [:name | SBDeclarationForInstanceVariable new contents: name]).
	class := aClass