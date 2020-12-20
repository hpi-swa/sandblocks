Class {
	#name : #RPTests,
	#superclass : #TestCase,
	#instVars : [
		'app'
	],
	#category : #'RatPack-Testing'
}

{ #category : #running }
RPTests >> setUp [

	app := RPTestApp new.
	app setDebugMode.
	app disableLogging.
]

{ #category : #running }
RPTests >> tearDown [

	app database dropTableFor: RPTestModel.
	RPApplication removeService: (RPApplication serviceNamed: (RPTestApp appName))
]

{ #category : #'test - objects' }
RPTests >> testAddObject [
	
	| object |
	app registerModel: RPTestModel.
	object := RPTestModel createObjectFrom: RPTestModel fullObject.
	app database persist: object from: RPTestModel.
	self assert: RPTestModel fullJson 
		 equals: (RPTestModel createJsonFor: (RPTestHelper load: 1 on: app) object).
]

{ #category : #'test - routing' }
RPTests >> testCaptureGroups [
	
	RPTestHelper get: '/captureGroups/number/123456789/word/Test' on: app.
	self assert: (app dynamicEnvironment at: #number) equals: 123456789.
	self assert: (app dynamicEnvironment at: #word) equals: 'Test'.
]

{ #category : #'test - database - postgresql' }
RPTests >> testConvertModelClassToSQLString [

	| adapter |
	adapter := RPPostgreSQLAdapter new.
	self assert: 'salary INT, name VARCHAR(30)' 
		 equals: (adapter convertModelToSQLString: RPTestModel).
]

{ #category : #'test - parsing middleware' }
RPTests >> testCorrectContentParsing [
	
	RPTestHelper put: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/contenttype'}) content: ''.
	self assert: (app parsedRequestContents) equals: (RPMockParser fixedAnswer).
	self assert: app indexHandlerCalled equals: true.
	
	app parsedRequestContents: nil.
	
	RPTestHelper post: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/contenttype'}) content: ''.
	self assert: app indexHandlerCalled equals: true.
	self assert: (app parsedRequestContents) equals: (RPMockParser fixedAnswer).
]

{ #category : #'test - database - postgresql' }
RPTests >> testCreateTableWithExternalDatabase [
	"Simple test to check if you can create a table on your database." 
	
	| tableExistsStatement response |
	app database: RPPostgreSQLAdapter new.
	app database createTableFor: RPTestModel.
	tableExistsStatement := '(SELECT 1 FROM pg_class WHERE relname = ''rptestclass'');'.

	response := (app database executeSQLStatement: tableExistsStatement).
	self assert: (response completedResponse value) equals: 'SELECT 1'
.
	
]

{ #category : #'test - routing' }
RPTests >> testDefaultApiRoutesFor: aRouteName [

	self assert: ((app routes at: #get:) anySatisfy: [ :route | route key = aRouteName]).
	self assert: ((app routes at: #get:) anySatisfy: [ :route | route key = (aRouteName, RPApplication wildcard)]).
	self assert: ((app routes at: #put:) anySatisfy: [ :route | route key = (aRouteName, RPApplication wildcard)]).
	self assert: ((app routes at: #post:) anySatisfy: [ :route | route key = aRouteName]).
	self assert: ((app routes at: #delete:) anySatisfy: [ :route | route key = (aRouteName, RPApplication wildcard)]).
]

{ #category : #'test - routing' }
RPTests >> testDefaultHtmlRoutesFor: aRouteName [

	self assert: ((app routes at: #get:) anySatisfy: [ :route | route key = aRouteName]).
	self assert: ((app routes at: #get:) anySatisfy: [ :route | route key = (aRouteName, RPApplication wildcard)]).
]

{ #category : #'test - routing' }
RPTests >> testDefaultRouteNameInModel [

	| routeName |

	app registerModel: RPTestModel.

	routeName := app settings apiRoutePrefix, '(', RPTestModel defaultRoute , ')'.
	self testDefaultApiRoutesFor: routeName.
	
	routeName := app settings htmlRoutePrefix, '(', RPTestModel defaultRoute, ')'.
	self testDefaultHtmlRoutesFor: routeName.
]

{ #category : #'test - routing' }
RPTests >> testDefaultRouteNamingStrategies [

	| routeName |

	app registerModel: RPTestModelWithoutRouteName.
	
	routeName := app settings apiRoutePrefix, '(', (RPTestRouteNamingStrategy new nameRoute: RPTestModelWithoutRouteName name), ')'.
	self testDefaultApiRoutesFor: routeName.
	
	routeName := app settings htmlRoutePrefix, '(', (RPTestRouteNamingStrategy new nameRoute: RPTestModelWithoutRouteName name), ')'.
	self testDefaultHtmlRoutesFor: routeName.
	

	
]

{ #category : #'test - objects' }
RPTests >> testDeleteObject [

	| objects testAmount |
	testAmount := 3.
	objects := RPTestHelper createTestObjects: testAmount.
	app registerModel: RPTestModel.

	objects do: [:object | app database persist: object from: RPTestModel.].  
	self assert: ((app database loadModelObjectsOf: RPTestModel) size) equals: testAmount.

	(1 to: testAmount) do: [:id | app database deleteObject: id from: RPTestModel].  
	self assert: (app database loadModelObjectsOf: RPTestModel) isEmpty.
	
]

{ #category : #'test - database - postgresql' }
RPTests >> testDeleteObjectOnExternalDatabase [

	| objects testAmount |
	app database: RPPostgreSQLAdapter new.
	testAmount := 3.
	objects := RPTestHelper createTestObjects: testAmount.
	app registerModel: RPTestModel.

	objects do: [:object | app database persist: object from: RPTestModel].  
	self assert: ((app database loadModelObjectsOf: RPTestModel) size) equals: testAmount.
	(1 to: testAmount) do: [:id | app database deleteObject: id from: RPTestModel].  
	self assert: (app database loadModelObjectsOf: RPTestModel) isEmpty.
	
]

{ #category : #'test - REST operations' }
RPTests >> testDeleteSingleObjectViaRestInterface [
	
	| url idUrl result|
	app database: RPPostgreSQLAdapter new.
	app registerModel: RPTestModel.
	url :=  '/api/routeName'.
	RPTestHelper post: url on: app json: RPTestModel fullJson.
	self assert: (app database loadModelObject: 1 from: RPTestModel) notNil.
  
	idUrl := url, '/1'.
	RPTestHelper delete: idUrl on: app.
	result := RPTestHelper get: url on: app.
	self assert: ([app database loadModelObject: 1 from: RPTestModel. false] 
								on: Warning do: [true]).
]

{ #category : #'test - database - postgresql' }
RPTests >> testDropTableOnExternalDatabase [
	"Simple test to check if u can delete a table on your database." 
	
	| response tableExistentStatement |
	app database: RPPostgreSQLAdapter new.
	app database createTableFor: RPTestModel.
	tableExistentStatement := '(SELECT 1 FROM pg_class WHERE relname = ''rptestclass'');'.

	response := app database executeSQLStatement: tableExistentStatement.
	self assert: (response completedResponse value) equals: 'SELECT 1'.

	app database dropTableFor: RPTestModel .
	response := app database executeSQLStatement: tableExistentStatement.
	self assert: (response completedResponse value) equals: 'SELECT 0'.
]

{ #category : #'test - routing' }
RPTests >> testError [

	| result |
	app setDeploymentMode.
	result := RPTestHelper get: '/raiseError' on: app.
	self assert: (result contents contents includesSubString: 'My test error').
	self assert: result status =  #serverError.
	self assert: result contentType = 'text/html'

]

{ #category : #'test - REST operations' }
RPTests >> testGetAllModelInstances [

	| url result testJson testJson2 |
	app registerModel: RPTestModel.
	url := '/api/routeName'.
	testJson := RPTestModel fullJson.
	testJson2 := RPTestModel otherFullJson.
	RPTestHelper post: url on: app json: testJson.
	RPTestHelper post: url on: app json: testJson2.
	result := RPTestHelper get: url on: app.
	self assert: ((result contents contents) includesSubString: (testJson)).
	self assert: ((result contents contents) includesSubString: (testJson2))
]

{ #category : #'test - REST operations' }
RPTests >> testGetModelInstance [
 
	| url idUrl result testJson |
      app registerModel: RPTestModel.
      url :=  '/api/routeName'. 
	testJson := RPTestModel fullJson.
 	RPTestHelper post: url on: app json: testJson.

      idUrl := url, '/1'.
      result := RPTestHelper get: idUrl on: app.
      self assert:  ((result contents contents) includesSubString: testJson).
	self assert: result status equals: #ok.
	self assert: result contentType equals: 'application/json'.

      idUrl := url, '/2'.
      result := RPTestHelper get: idUrl on: app.
      self assert: app settings objectNotFoundJson equals: (result contents contents).
	self assert: result status equals: #notFound.
	self assert: result contentType equals: 'application/json'. 

]

{ #category : #'test - routing' }
RPTests >> testGlobalHeaders [
	
	| result |
	result := RPTestHelper get: '/index' on: app.

	self assert: result status =  #ok.
	self assert: result contentType = 'text/html'.
	self assert: (result fieldAt: 'global-headers-work' ifAbsent:['global headers field is missing']) equals: 'true'.
	self assert: (result fieldAt: 'date' ifAbsent:['date field is missing']) equals: TimeStamp now asString.
]

{ #category : #'test - routing' }
RPTests >> testIndex [
	| result |
	result := RPTestHelper get: '/index' on: app.
	self assert: (result contents contents includesSubString: 'Hello World').
	self assert: result status =  #ok.
	self assert: result contentType = 'text/html'
]

{ #category : #'test - database - postgresql' }
RPTests >> testInsertObjectOnExternalDatabase [

	app database: RPPostgreSQLAdapter new.
	app registerModel: RPTestModel.
	RPTestHelper persistNew: 1 on: app. 
	self assert: (app database loadModelObjectsOf: RPTestModel) size equals: 1.
	self assert: (RPTestModel createJsonFor: (RPTestHelper load: 1 on: app) object) equals: RPTestModel fullJson. . 
]

{ #category : #'test - parsing middleware' }
RPTests >> testInvalidContentParsing [
	
	RPTestHelper put: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/contenttype'}) content: 'invalid'.
	self assert: (app parsedRequestContents) equals: nil.
	self assert: app indexHandlerCalled equals: true.
	
	RPTestHelper post: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/contenttype'}) content: 'invalid'.
	self assert: (app parsedRequestContents) equals: nil.
	self assert: app indexHandlerCalled equals: true.
]

{ #category : #'test - parsing middleware' }
RPTests >> testJsonParser [
	| object expected |
	
	object := Dictionary newFrom: (RPJsonContentParser parse: '{"a":5,"b":7}').
	expected := Dictionary newFrom: {'a' -> 5. 'b' -> 7}.
	
	self assert: object equals: expected.
	
	object := Array newFrom: (RPJsonContentParser parse: '[5, 7, 8]').
	expected := Array newFrom: {5. 7. 8}.
	
	self assert: object equals: expected.
]

{ #category : #'test - database - postgresql' }
RPTests >> testLoadObjectsOnExternalDatabase [

	| newObjects |
	app database: RPPostgreSQLAdapter new.
	app registerModel: RPTestModel. 
	newObjects := RPTestHelper createTestObjects: 3.
	RPTestHelper insertObjects: newObjects of: RPTestModel into: app database.
  
	app database: RPPostgreSQLAdapter new.
	self assert: ((app database loadModelObjectsOf: RPTestModel) size) equals: 3.
	
]

{ #category : #'test - routing' }
RPTests >> testLowercaser [

	| name |
	name := RPTestModel name asLowercase.
	self assert: ((RPLowercaser new nameRoute: (RPTestModel name)) = name).
]

{ #category : #'test - routing' }
RPTests >> testManySlashes [
	
	RPTestHelper get: '/thisDoesNotExist/even/with/many/Slashes' on: app.
	self assert: app response status = #notFound.
	
	RPTestHelper get: '/thisDoesExist/butDoesntTakeArguments/even/with/many/Slashes' on: app.
	self assert: app response status = #ok.
]

{ #category : #'test - middleware' }
RPTests >> testMiddlewareAutoglobalMiddleware [

	| env |
	RPTestHelper get: '/autoGlobalMiddleware' on: app.
	env := app dynamicEnvironment.
	self assert: (app dynamicEnvironment at: #RPTestMiddlewarePreHookTime) equals: 1.
	self assert: (app dynamicEnvironment at: #RPWordCountMiddlewarePreHookTime) equals: 2.
	self assert: (app dynamicEnvironment at: #RPUppercaseMiddlewarePreHookTime) equals: 3.
	self assert: (app dynamicEnvironment at: #RPUppercaseMiddlewarePostHookTime) equals: 4.
	self assert: (app dynamicEnvironment at: #RPWordCountMiddlewarePostHookTime) equals: 5.
	self assert: (app dynamicEnvironment at: #RPTestMiddlewarePostHookTime) equals: 6.
]

{ #category : #'test - middleware' }
RPTests >> testMiddlewareBlacklist [

	RPTestHelper get: '/blacklistedHandler' on: app.
	app dynamicEnvironment at: #preHookCounter ifPresent: [ self assert: false ].
	app dynamicEnvironment at: #postHookCounter ifPresent: [ self assert: false ].
	
]

{ #category : #'test - middleware' }
RPTests >> testMiddlewareCallChainInterrupt [

	RPTestHelper get: '/stopped' on: app.
	self assert: app indexHandlerCalled equals: false.
]

{ #category : #'test - middleware' }
RPTests >> testMiddlewareCallChainOrder [

	RPTestHelper get: '/chainOrder' on: app.
	self assert: (app dynamicEnvironment at: #RPWordCountMiddlewarePreHookTime) equals: 1.
	self assert: (app dynamicEnvironment at: #RPTestMiddlewarePreHookTime) equals: 2.
	self assert: (app dynamicEnvironment at: #RPUppercaseMiddlewarePreHookTime) equals: 3.
	self assert: (app dynamicEnvironment at: #RPUppercaseMiddlewarePostHookTime) equals: 4.
	self assert: (app dynamicEnvironment at: #RPTestMiddlewarePostHookTime) equals: 5.
	self assert: (app dynamicEnvironment at: #RPWordCountMiddlewarePostHookTime) equals: 6.
]

{ #category : #'test - middleware' }
RPTests >> testMiddlewareInstanciation [
]

{ #category : #'test - database - postgresql' }
RPTests >> testMiddlewarePreHookConvention [

	| middleware |
	middleware := RPAntiPreHookConventionMiddleware new.
	self assert: (middleware assertedPreHookResult: true) equals: true.
	self assert: (middleware assertedPreHookResult: false) equals: false.
	self assert: ([middleware assertedPreHookResult: (middleware preHook: nil). false] on: Error do: [true])
]

{ #category : #'test - middleware' }
RPTests >> testMiddlewarePreHookFalse [
	
	| env |
	env := RPTestHelper getExampleEnvironment.
	RPStoppingMiddleware new handle: env next: [self assert: false].
	self assert: (env at: #preHookCounter) equals: 1.
	self assert: (env at: #postHookCounter) equals: 0.
]

{ #category : #'test - middleware' }
RPTests >> testMiddlewarePreHookTrue [
	
	| env blockCalled |
	blockCalled := false.
	env := RPTestHelper getExampleEnvironment.
	RPTestMiddleware new handle: env next: [blockCalled := true].
	self assert: (env at: #preHookCounter) equals: 1.
	self assert: (env at: #postHookCounter) equals: 1.
	self assert: blockCalled.
]

{ #category : #'test - routing' }
RPTests >> testModelNameToSnakeCase [

	| name route |
	name := 'rp_test_models'.
	route := (RPLowercaser new nameRoute: ((RPSeparator newWithSeparator: '_') nameRoute: (RPPluralizer new nameRoute: (RPTestModel name)))).
	
	self assert: (name = route).
]

{ #category : #'test - routing' }
RPTests >> testNotFound [
	| result |
	result := RPTestHelper get: '/thisDoesNotExist' on: app.
	self assert: (result contents contents includesSubString: 'Try this').
	self assert: result status = #notFound.
	self assert: result contentType = 'text/html'.
	
	RPTestHelper get: '/thisDoesNotExist/(.*)/andCaptureGroupsInUrl/AreNoProblem' on: app.
	self assert: app response status = #notFound.
]

{ #category : #'test - objects' }
RPTests >> testObjectIndexing [

	| object |
	object := RPTestHelper createTestObject.
	app registerModel: RPTestModel.
	app database persist: object from: RPTestModel.
	self assert: 2 equals: (app database idDictionary at: (RPTestModel name)) .
	app database persist: object from: RPTestModel.
	self assert: 3 equals:(app database idDictionary at: (RPTestModel name)).
]

{ #category : #'test - routing' }
RPTests >> testPluralizer [

	| pluralizedName |
	
	pluralizedName := RPTestModel name, 's'.
	self assert: ((RPPluralizer new nameRoute: RPTestModel name) = pluralizedName).
]

{ #category : #'test - REST operations' }
RPTests >> testPost [
	
	| url testJson |
	app registerModel: RPTestModel.
	url :=  '/api/routeName'.
	testJson := RPTestModel fullJson.
	RPTestHelper post: url on: app json: testJson.
	self assert: (RPTestModel createJsonFor: 
					(app database loadModelObject: 1 from: RPTestModel) object) 
					equals: testJson.
	
	
]

{ #category : #'test - REST operations' }
RPTests >> testPostReturningNewObject [
	
	| url urlId testJson postResult getResult |
	app registerModel: RPTestModel.
	url := app settings apiRoutePrefix, (RPTestModel defaultRoute).
	testJson := RPTestModel fullJson.
	urlId := url, '/1'.
	postResult := RPTestHelper post: url on: app json: testJson.
	getResult := (RPTestHelper get: (urlId) on: app).
	self assert: ((getResult contents contents) = (postResult contents contents)).
	
 	getResult contents contents
]

{ #category : #'test - REST operations' }
RPTests >> testPut [
	
	| url urlId putResult postResult testJson otherTestJson|
	app registerModel: RPTestModel.
	url := app settings apiRoutePrefix, (RPTestModel defaultRoute).
	testJson := RPTestModel fullJson.
	otherTestJson := RPTestModel otherFullJson.
	urlId := url, '/1'.
	postResult := RPTestHelper post: url on: app json: testJson.
	putResult := RPTestHelper put: urlId on: app json: otherTestJson.
		
	self assert: ((postResult contents contents) ~= (putResult contents contents)).
	self assert: ((putResult contents contents) includesSubString: otherTestJson).
]

{ #category : #'test - REST operations' }
RPTests >> testPutReturningUpdatedObject [
	
	| url urlId putResult getResult |
	app registerModel: RPTestModel.
	url := app settings apiRoutePrefix, (RPTestModel defaultRoute).
	
	urlId := url, '/1'.
	RPTestHelper post: url on: app json: RPTestModel fullJson.
	putResult := RPTestHelper put: urlId on: app json: RPTestModel otherFullJson.
	getResult := (RPTestHelper get: (urlId) on: app).
	self assert: ((getResult contents contents) = (putResult contents contents)).
]

{ #category : #'test - REST operations' }
RPTests >> testPutWithPartialJson [
	
	| url putResult postResult |
	app registerModel: RPTestModel.
	url := app settings apiRoutePrefix, (RPTestModel defaultRoute).
	postResult := RPTestHelper post: url on: app json: RPTestModel fullJson.
	putResult := RPTestHelper put: url, '/1' on: app json: RPTestModel partialJson.
		
	self assert: ((postResult contents contents) ~= (putResult contents contents)).
	self assert: ((putResult contents contents) includesSubString: '{"salary":42,"name":"Tim Tester"}').
	
]

{ #category : #'test - routing' }
RPTests >> testRedirect [

	| result |
	result := RPTestHelper get: '/redirect' on: app.
	self assert: (result contents contents includesSubString: 'moved to').
	self assert: result status = #found.
	self assert: result contentType = 'text/html'
]

{ #category : #'test - app accessing' }
RPTests >> testRegisterModelClass [

	app registerModel: RPTestModel.
	app database: RPPostgreSQLAdapter new.
	self assert: (app getRegisteredModel: 'RPTestModel') equals: RPTestModel
]

{ #category : #'test - app accessing' }
RPTests >> testRemoveModelClass [

	app registerModel: RPTestModel.
	self assert: (app getRegisteredModel: 'RPTestModel') equals: RPTestModel.
	app removeModel: RPTestModel.
	self assert: ([app getRegisteredModel: 'RPTestModel'. false]on: Error do:[true])
]

{ #category : #'test - routing' }
RPTests >> testSeparator [

	| name sep |
	name := 'RP_Test_Model'.
	sep := RPSeparator newWithSeparator: '_'.
	
	self assert: ((sep nameRoute: (RPTestModel name))= name).

]

{ #category : #'test - routing' }
RPTests >> testSettingHeadersCaseInsensitive [
	
	| environment |
	environment := RPTestHelper getExampleEnvironment.
	environment headersAt: 'date' put: TimeStamp today asString.
	self assert: (environment headersAt: 'date' ifAbsent:['date field is missing']) equals: TimeStamp today asString.
	self assert: (environment headersAt: 'dAtE' ifAbsent:['date field is missing']) equals: TimeStamp today asString.
	
	environment headersAt: 'DaTe' put: TimeStamp tomorrow asString.
	self assert: (environment headersAt: 'date' ifAbsent:['date field is missing']) equals: TimeStamp tomorrow asString.
	self assert: (environment headersAt: 'dAtE' ifAbsent:['date field is missing']) equals: TimeStamp tomorrow asString.
	
	environment headersPut: RPTestHelper getExampleGlobalHeaders.
	self assert: (environment  headersAt: 'Global-heAderS-wOrk' ifAbsent:['global headers field is missing']) equals: 'true'.
	self assert: (environment  headersAt: 'dAte' ifAbsent:['date field is missing']) equals: TimeStamp now asString.
]

{ #category : #'test - routing' }
RPTests >> testSettingHeadersInHandler [
	
	| result |
	result := RPTestHelper get: '/setHeaders' on: app.

	self assert: result status =  #ok.
	self assert: result contentType = 'application/json'.
	self assert: (result fieldAt: 'handler-headers-work' ifAbsent:['global headers field is missing']) equals: 'true'.
	self assert: (result cookies anySatisfy: [ :each | each includesSubString: 'TestCookie' ]) equals: true.
]

{ #category : #'test - routing' }
RPTests >> testSimpleJSON [
	| result |
	result := RPTestHelper get: '/simpleJSON' on: app.
	self assert: (result contents contents  = '{"Name":"Test","Port":"1111","Users":["me","you"],"Text":{"Header":"testheader", "Content":"blabla"},"value":30,"finished":true}').
	self assert: result status = #ok.
	self assert: result contentType = 'application/json'
]

{ #category : #'test - parsing middleware' }
RPTests >> testStrictCorrectContentParsing [
	
	app settings forceCorrectContentDecoding: true.
	
	RPTestHelper put: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/contenttype'}) content: ''.
	self assert: (app parsedRequestContents) equals: (RPMockParser fixedAnswer).
	self assert: app indexHandlerCalled equals: true.
	
	app parsedRequestContents: nil.

	RPTestHelper post: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/contenttype'}) content: ''.
	self assert: app indexHandlerCalled equals: true.
	self assert: (app parsedRequestContents) equals: (RPMockParser fixedAnswer).
]

{ #category : #'test - parsing middleware' }
RPTests >> testStrictInvalidContentParsing [
	
	| response |
	
	app settings forceCorrectContentDecoding: true.
	
	response := RPTestHelper put: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/contenttype'}) content: 'invalid'.
	self assert: (app parsedRequestContents) equals: nil.
	self assert: response body equals: app settings badRequestPage.
	self assert: app indexHandlerCalled equals: false.
	
	response := RPTestHelper post: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/contenttype'}) content: 'invalid'.
	self assert: (app parsedRequestContents) equals: nil.
	self assert: response body equals: app settings badRequestPage.
	self assert: app indexHandlerCalled equals: false.
]

{ #category : #'test - parsing middleware' }
RPTests >> testStrictUnknownContentTypeParsing [
	
	| response |
	
	app settings forceCorrectContentDecoding: true.
	
	response := RPTestHelper put: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/unknown'}) content: ''.
	self assert: (app parsedRequestContents) equals: nil.
	self assert: response body equals: app settings badRequestPage.
	self assert: app indexHandlerCalled equals: false.
	
	response := RPTestHelper post: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/unknown'}) content: ''.
	self assert: (app parsedRequestContents) equals: nil.
	self assert: response body equals: app settings badRequestPage.
	self assert: app indexHandlerCalled equals: false.
]

{ #category : #'test - models' }
RPTests >> testTestModelCreateDefaultObject [
	
	|  object |
	object := RPTestModel createObjectFrom: Dictionary new.
	self assert: 1 equals:  (object instVarNamed: 'salary').
	self assert:  'Max Mustermann' equals: (object instVarNamed: 'name') .
]

{ #category : #'test - models' }
RPTests >> testTestModelCreateJsonFor [

	| dictionary object jsonObject jsonString otherDictionary | 
	dictionary := Dictionary newFrom: { 'name'->'Hans' . 'salary'->99 }.
	otherDictionary := Dictionary newFrom: { 'nombre'->'Hans' . 'salary'->50 }.
	object :=  RPTestModel reconstructObject: dictionary. 
	jsonString := RPTestModel createJsonFor: object.
	jsonObject := Json readFrom: (ReadStream on: jsonString from: 1 to: (jsonString size)).
	
	self assert:(dictionary difference: jsonObject) isEmpty.
	self assert: (otherDictionary difference: jsonObject) notEmpty. 
	self assert: (dictionary keys) equals: (jsonObject keys).
]

{ #category : #'test - models' }
RPTests >> testTestModelCreateJsonForInvalidObject [

	| object | 
	object := 1.
	self assert: [ ( [RPTestModel createJsonFor: object] on: Warning do: [true])]
	
]

{ #category : #'test - models' }
RPTests >> testTestModelCreateSpecifiedObject [

	|  object |
	object := RPTestModel createObjectFrom: (Dictionary newFrom: {'name' -> 'Andreas Anders'}).
	self assert: 1 equals:  (object instVarNamed: 'salary').
	self assert:  'Andreas Anders' equals: (object instVarNamed: 'name') .
]

{ #category : #'test - models' }
RPTests >> testTestModelReconstructObject [

	| dictionary object| 
	dictionary := Dictionary newFrom: { 'name'->'Hans' . 'salary'->99 }.
	object :=  RPTestModel reconstructObject: dictionary. 
	self assert: 'Hans' equals:  (object instVarNamed: 'name').
	self assert:  99 equals: (object instVarNamed: 'salary') .
	
]

{ #category : #'test - models' }
RPTests >> testTestModelValidateCorrect [
	
	"correct Json"
	 self assert: ([ RPTestModel createObjectFrom: (Dictionary newFrom: {'salary' ->1. 'name' -> 'green'}). true]
		on: Warning do: [false]).
	

]

{ #category : #'test - models' }
RPTests >> testTestModelValidateIncorrect [
	
	"incorrect Json"
	self assert: ([ RPTestModel createObjectFrom: (Dictionary newFrom: {'var' -> 1. 'var2' -> 'green'}). false]
		on: Warning do: [true]).
	
]

{ #category : #'test - models' }
RPTests >> testTestModelValidateRefClass [

	self assert: RPTestModel validateRefClass 
]

{ #category : #'test - session middleware' }
RPTests >> testTokenGeneration [

	| session env generated expected|
	session := RPSessionMiddleware new.
	env := RPDynamicEnv new response: HttpResponse new.
		env settings: app settings.
	env session: {'name' -> 'John Doe'} asDictionary.
	session postHook: env.
	
	expected := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UifQ.gUpLaW7ugoRrKP34s49y4t-bEwnB8JJ-z5I-8unJh5c'.
	
	generated := ( ( (env cookies) at: 1 ) subStrings: '=') second.
	
	self assert: expected equals: generated.
]

{ #category : #'test - session middleware' }
RPTests >> testTokenParsing [

	| sessionMiddleware env generated expected request|
	sessionMiddleware := RPSessionMiddleware new.
	
	request := HttpRequest new.
	request propertyAt: #cookies put: (request parseCookies: 
	'authorization=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UifQ.gUpLaW7ugoRrKP34s49y4t-bEwnB8JJ-z5I-8unJh5c').
	
	env := RPDynamicEnv new request: request.
	env settings: app settings.
	sessionMiddleware preHook: env.
	
	expected := JsonObject newFrom: {'name' -> 'John Doe'}.
	generated := env session.
	
	self assert: expected equals: generated.

]

{ #category : #'test - parsing middleware' }
RPTests >> testUnknownContentTypeParsing [
	
	RPTestHelper put: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/unknown'}) content: ''.
	self assert: (app parsedRequestContents) equals: nil.
	
	RPTestHelper post: '/index' on: app headers: (Dictionary newFrom: {'Content-Type' -> 'test/unknown'}) content: ''.
	self assert: (app parsedRequestContents) equals: nil.
]

{ #category : #'test - database - postgresql' }
RPTests >> testUpdateObjectOnExternalDatabase [

	| objects updatedObject |
	app database: RPPostgreSQLAdapter new.
	app registerModel: RPTestModel.
	objects := RPTestHelper createTestObjects: 3.
	RPTestHelper insertObjects: objects of: RPTestModel into: app database.
 
	updatedObject := objects first.
	updatedObject name: 'Updated Ulf'.
	app database update: updatedObject with: 1 from: RPTestModel.
	self assert: ((app database loadModelObject: 1 from: RPTestModel) object) name equals: 'Updated Ulf'.  
]

{ #category : #'test - REST operations' }
RPTests >> testUpdateSingleObject [
	
	| idUrl objectToUpdate updatedObject |
     	app registerModel: RPTestModel.
	idUrl :=  '/api/routeName', '/1'.
	RPTestHelper persist: (RPTestHelper createTestObjects: 1) on: app.

	objectToUpdate := RPTestHelper load: 1 on: app.
	objectToUpdate object name: 'Updated Ulf'.
	self assert: objectToUpdate notNil.

	RPTestHelper put: idUrl on: app json: (RPTestModel createJsonFor: objectToUpdate object).
	updatedObject := RPTestHelper load: 1 on: app.
	self assert: updatedObject notNil.
	self assert: (RPTestModel createJsonFor: updatedObject object) equals: (RPTestModel createJsonFor: objectToUpdate object).
]
