Class {
	#name : #RPTestModel,
	#superclass : #RPModel,
	#category : #'RatPack-Testing'
}

{ #category : #'needed methods' }
RPTestModel class >> dataTypes [ 

^ Dictionary newFrom: { 'salary'-> 'INT'.
						'name'-> 'VARCHAR(30)'}
	
]

{ #category : #'needed methods' }
RPTestModel class >> defaultRoute [ 

	^ 'routeName'
]

{ #category : #'needed methods' }
RPTestModel class >> defaultValues [  

^ Dictionary newFrom: { 'salary'-> 1.
						'name'-> 'Max Mustermann'}
	
]

{ #category : #'needed methods' }
RPTestModel class >> foreignKeys [ 

^ Dictionary new	
]

{ #category : #'helper function' }
RPTestModel class >> fullJson [
	
	^ '{"salary":20,"name":"Tim Tester"}'
]

{ #category : #'helper function' }
RPTestModel class >> fullObject [
	
	^ Json readFrom: (ReadStream on: self fullJson)
]

{ #category : #'helper function' }
RPTestModel class >> otherFullJson [
	
	^ '{"salary":40,"name":"Werner Wild"}'
]

{ #category : #'needed methods' }
RPTestModel class >> overridesDefaultRoute [ 

	^ true
	

]

{ #category : #'helper function' }
RPTestModel class >> partialJson [
	
	^ '{"salary":42}'
]

{ #category : #'needed methods' }
RPTestModel class >> refClass [

	^ RPTestClass
	
]

{ #category : #'needed methods' }
RPTestModel class >> tableName [
	
	^ self refClass name asString
]
