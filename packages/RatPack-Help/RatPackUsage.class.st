Class {
	#name : #RatPackUsage,
	#superclass : #RatPackHelp,
	#category : #'RatPack-Help'
}

{ #category : #accessing }
RatPackUsage class >> bookName [

	^'Using Ratpack'
]

{ #category : #pages }
RatPackUsage class >> overview [
	^HelpTopic 
		title: 'Overview'
		contents: 'In this section, we will go over basic steps that you probably want to do in order to use RatPack.' 
]

{ #category : #pages }
RatPackUsage class >> page1 [
	^HelpTopic 
		title: '1. Setting up an Application'
		contents: 'RatPack was made to build web applications.

To create a new application, simply subclass RPApplication.

To start an app in the workspace, you have to instantiate it, set it''s port and then start it:

	app := RPExampleApplication new.
		app name: ''Example name''.
		app portNumber: 4567.
		app start.

To stop a running app in the workspace, call

	app stop.
	
When using RPControlPanel (start by executing ''RPControlPanel new openInWorld''), you can use:

	- Ctrl-a to add a new application (creates an instance, sets the port and starts it)
	- Ctrl-x to remove an application (deletes the instance)
	- Ctrl-r to remove all applications
	- right-click on an application to see all available actions'
]

{ #category : #pages }
RatPackUsage class >> page2 [
	
	^HelpTopic
		title: '2. Setting up a Model'
		contents: 
'RatPack''s database backends provide object relational mapping. To use this, you want to set up a model. The steps to do this are:
		
1. Create a data class whose instance variables represent the fields of the model e.g.

	Object subclass #Person
	instanceVariableNames: ''name birthday''

2. Create model class (subclass of RPModel). It needs the following class methods:
	- dataTypes - returns a dictionary with the data types of the instance variables of the data class (these are the attributes of the model)
	- defaultValues - returns the default attribute values for new objects
	- refClass - returns the data class
	- tableName - returns the name of the table where the data is stored
	
3. Register the model class (not the data class) in your application:

	application registerModel: ModelClass.
	
You may get the following warnings:
	- model with same name already registered
	- model is invalid
	(hint:  Attributes are just the pure attribute names as String)

When in RPControlPanel:
	- Ctrl-n to add a model.
	- Ctrl-d to remove a model.
' 

]

{ #category : #pages }
RatPackUsage class >> page3 [
	^HelpTopic 
		title: '3. Setting up an Object'
		contents: 'Setting up an Object

When in workspace:

	app persistObjectBy: aValidJsonString from: ModelClass.
	
When in RPControlPanel:

	- Ctrl-o to add an object
	- Ctrl-i to remove an object
		
RatPack will also set up a REST-API for all registered models when you start the server. This can also be used to create new objects in the database. You can access it at server.com/api/.'

]

{ #category : #accessing }
RatPackUsage class >> pages [
	^#(overview page1 page2 page3)
]

{ #category : #accessing }
RatPackUsage class >> priority [ 
	
	^ 10
]
