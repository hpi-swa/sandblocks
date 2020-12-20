Class {
	#name : #RatPackMiddleware,
	#superclass : #RatPackHelp,
	#category : #'RatPack-Help'
}

{ #category : #accessing }
RatPackMiddleware class >> bookName [
	
	^'Middleware'
]

{ #category : #pages }
RatPackMiddleware class >> overview [
	^HelpTopic 
		title: 'Defining middleware'
		contents:
	'Middleware offers a way to reuse code that does repeating tasks in different handlers or different applications.

If you want to use middleware, you have to define your middleware in a new class. This class will have to implement the "handle: anEnvironment next: aBlock" method. This method will be called by the framework for every request that targets a handler that this middleware is registered for.

	handle: anEnvironment next: aBlock
	
	anEnvironment is the current, thread local RPEnvironment object that stores all information such as the request or the response object. Currently, this behaves like a Dictionary, so you can add, remove or edit entires as you wish. For example, an authentication middleware may add a "user" entry where information about the user sending this request can be stored. All middleware that is executed after the current middleware as well as the handler will then have this information at hand.
	
	aBlock	is a block that, if evaluated, will continue execution of the request handling. It will either call the next middleware or the handler. This leaves the power to decide whether you want to continue the handling for this request. You should either not do anything with this, or call "aBlock value" to continue. Keep in mind that you can also edit the environment after you did this.' 
]

{ #category : #pages }
RatPackMiddleware class >> page1 [
	^HelpTopic 
		title: 'Convenience class RPMiddleware'
		contents:	
	'Since this approach is a bit clumsy, we offer a "RPMiddleware" class for convenience. This class implements a "handle:next:" method and leaves it to you do add code before and after the call chain is continued. To do this, you can override three methods:

	preHook: anEnvironment
		
	where anEnvironment is the same environment as in "handle:next:" This method will be executed before the execution chain is continued. It should do all preprocessing. This method should return "true" or "false". If it returns "true", the request handling will be continued and the postHook: method will be called afterwards. If it returns false, the request handling will stop and "postHook:" will not be called. In this case, it makes sense for you to set all required fields in the response object in "anEnvironment" such as the status code and the response body.
	

	postHook: anEnvironment

	where anEnvironment is the same environment as in "handle:next:" This method will be executed after all execution that comes after this middleware was done. It should do all postprocessing. The return value of this method is ignored.


	blacklist
	
	This method returns a collection of regular expressions. If the request''s URL matches any of these, the "preHook" and "postHook" will not be called. Instead, the execution will instantly be continued at the next element in the processing chain.' 
]

{ #category : #pages }
RatPackMiddleware class >> page2 [
	^HelpTopic 
		title: 'Enabling Middleware'
		contents:	
	'Enabling Middleware
	
globalMiddleware

You can add global middleware which is user for every handler. The global middleware is a setting stored in application settings. To set these, RPApplication includes a convenience method called ''initializeSettings''. You can override this and set the global middleware as well as other settings, like this:

	initializeSettings
		self settings globalMiddleware: {#RPTestMiddleware. #RPGlobalHeaderMiddleware. #RPContentParserMiddleware} asOrderedCollection;


Pragmas

In each handler, you can specify the middleware that should be used with this handler. To do this, simply add a pragma with key "middleware" and a symbol array of class names for middleware you would like to use to the handler, e.g. 
	
	<middleware: #(#MyMiddleware1 #MyMiddleware2) > 
		
By default, the global middleware will be prepended to this list. You can change this position by adding the key that your application specifies in it''s "globalMiddlewareKey" class method. It defaults to 
	
	"#globalMiddleware".
		
So, if your pragma is 
	
	<middleware: #(#MyMiddleware1 #globalMiddleware #MyMiddleware2) >,
		
the global middleware will be applied between "MyMiddleware1" and "MyMiddleware2".' 
]

{ #category : #pages }
RatPackMiddleware class >> page3 [
	^HelpTopic 
		title: 'Examples'
		contents:	
	'See our tests for examples. We have different middleware for many handlers in "RPTestApp".' 
]

{ #category : #accessing }
RatPackMiddleware class >> pages [
	^#(overview page1 page2 page3)
]

{ #category : #accessing }
RatPackMiddleware class >> priority [ 

	^ 20
]
