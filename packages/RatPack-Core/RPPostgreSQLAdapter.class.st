Class {
	#name : #RPPostgreSQLAdapter,
	#superclass : #RPDatabase,
	#instVars : [
		'connection',
		'connectionArguments'
	],
	#category : #'RatPack-Core'
}

{ #category : #connection }
RPPostgreSQLAdapter >> connectTo: aDBName on: aHost at: aPort as: aUser with: aPassword [ 

	self connectionArguments: ( PGConnectionArgs
									hostname: aHost
									portno: aPort
									databaseName: aDBName
									userName: aUser
									password: aPassword)
]

{ #category : #accessing }
RPPostgreSQLAdapter >> connection [

	connection ifNil: [connection := PGConnection new].
	
	^ connection connectionArgs: self connectionArguments
]

{ #category : #accessing }
RPPostgreSQLAdapter >> connectionArguments [

	^ connectionArguments ifNil: [ connectionArguments := PGConnectionArgs
									hostname: 'localhost'
									portno: 5432
									databaseName: 'squeakdb'
									userName: 'postgres'
									password: 'bird']
]

{ #category : #accessing }
RPPostgreSQLAdapter >> connectionArguments: aConnectionArgumentObject [

	connectionArguments := aConnectionArgumentObject

]

{ #category : #'sql helpers' }
RPPostgreSQLAdapter >> convertAssociationToSQLString: anAssociation [

	^ (anAssociation key) , ' ', (anAssociation value)
]

{ #category : #'sql helpers' }
RPPostgreSQLAdapter >> convertModelToSQLString: aRPModelClass [

	^ (aRPModelClass dataTypes associations collect: 
		[:assoc | self convertAssociationToSQLString: assoc]) joinSeparatedBy: ', '	
]

{ #category : #'table handling' }
RPPostgreSQLAdapter >> createTableFor: aRPModelClass [

	self executeSQLStatement: (self getCreateTableString: aRPModelClass)
]

{ #category : #'object handling' }
RPPostgreSQLAdapter >> deleteObject: anId from: aRPModelClass [
	
	^ self executeSQLStatement:  ('DELETE FROM ', (aRPModelClass tableName), ' WHERE ', (aRPModelClass idColumnName),  '= ', anId)
]

{ #category : #'table handling' }
RPPostgreSQLAdapter >> dropTableFor: aRPModelClass [
	
	self executeSQLStatement: ('DROP TABLE IF EXISTS ', (aRPModelClass tableName)) 
	
]

{ #category : #'sql helpers' }
RPPostgreSQLAdapter >> executeSQLStatement: anSQLStatement [
	
	| response |
	self connection startup.
	response := self connection execute: anSQLStatement.
	self connection terminate.
	^ response
]

{ #category : #'sql helpers' }
RPPostgreSQLAdapter >> getColumnNames: aRPModelClass [
	
	^ aRPModelClass dataTypes keys joinSeparatedBy: ', '




		
 
]

{ #category : #'sql helpers' }
RPPostgreSQLAdapter >> getCreateTableString: anRPModel [
	
	^ 'CREATE TABLE ', (anRPModel tableName), ' (ID serial Primary Key, ' , (self convertModelToSQLString: anRPModel) , ')'
]

{ #category : #'sql helpers' }
RPPostgreSQLAdapter >> getInsertionStringFor: anObject of: anRPModelClass [
	
	| valueString columnString|
	valueString := self getValueStringFor: anObject of: anRPModelClass.
	columnString := self getColumnNames: anRPModelClass.
	
	^ 'INSERT INTO ', (anRPModelClass tableName), ' (',  columnString , ') VALUES (', valueString, ') RETURNING ID'
	
]

{ #category : #'sql helpers' }
RPPostgreSQLAdapter >> getSQLValueOf: anObject ofModel: aRPModelClass from: attribute [ 

	" escape string characters if needed"
	((aRPModelClass dataTypes at: attribute) includesSubString:   'VARCHAR')
			ifFalse: [^ anObject instVarNamed: attribute]
		 	ifTrue: [^ '''', (anObject instVarNamed: attribute), '''']
]

{ #category : #'sql helpers' }
RPPostgreSQLAdapter >> getUpdateStringOf: anObject with: anId from: anRPModelClass [

	| updatedValues |
	updatedValues := self getUpdatedValues: anObject from: anRPModelClass.

	^ ('UPDATE ', (anRPModelClass tableName), 
			' SET ', (updatedValues joinSeparatedBy: ', '),
			' WHERE ',  (anRPModelClass idColumnName),  ' = ', anId)
	
]

{ #category : #'sql helpers' }
RPPostgreSQLAdapter >> getUpdatedValues: anObject from: aRPModelClass [

	
	^ aRPModelClass dataTypes keys 
			collect: [:attribute | attribute, ' = ', (self getSQLValueOf: anObject ofModel: aRPModelClass from: attribute)]
]

{ #category : #'sql helpers' }
RPPostgreSQLAdapter >> getValueStringFor: anObject of: aRPModelClass [
	
	| strings |
	strings := aRPModelClass dataTypes keys 
		collect: [:attribute | self getSQLValueOf: anObject ofModel: aRPModelClass from: attribute].
	^ strings joinSeparatedBy: ', '




		
 
]

{ #category : #'object handling' }
RPPostgreSQLAdapter >> loadModelObject: anId from: anRPModelClass [

	| response objectDictionaries statement |
	statement := 'SELECT * FROM ', (anRPModelClass tableName), ' WHERE ', (anRPModelClass idColumnName),  '=', anId.
	response := self executeSQLStatement: statement.
	objectDictionaries :=  self transformToCollection: response. 
	objectDictionaries ifEmpty: [^ self notify: 'Object not found!'].

	^ anRPModelClass constructModel: (objectDictionaries first)
			
	
]

{ #category : #'object handling' }
RPPostgreSQLAdapter >> loadModelObjectsOf: anRPModelClass [

	| response objectsAsDicts |
	response := self executeSQLStatement: ('SELECT * FROM ', (anRPModelClass tableName)).
	objectsAsDicts := self transformToCollection: response. 
	
	^ objectsAsDicts collect: [:each | (anRPModelClass constructModel: each)]
]

{ #category : #'object handling' }
RPPostgreSQLAdapter >> persist: anObject from: aRPModelClass [
	
	| objectDictionaries response |
	response := self executeSQLStatement: (self getInsertionStringFor: anObject of: aRPModelClass).
	objectDictionaries :=  self transformToCollection: response.

	^ (objectDictionaries at: 1) at: #id
]

{ #category : #'object handling' }
RPPostgreSQLAdapter >> rowToDict: aPGRow [

	^ aPGRow dictionary collect: [:index | aPGRow at: index]
]

{ #category : #'object handling' }
RPPostgreSQLAdapter >> transformToCollection: aPGResponse [

	^ aPGResponse dataRows collect: [ :row | self rowToDict: row]



	
]

{ #category : #'object handling' }
RPPostgreSQLAdapter >> update: anObject with: anId from: aRPModelClass [

	self executeSQLStatement: (self getUpdateStringOf: anObject with: (anId asNumber) from: aRPModelClass)
]
