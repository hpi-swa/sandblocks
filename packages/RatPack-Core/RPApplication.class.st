Class {
	#name : #RPApplication,
	#superclass : #HttpService,
	#instVars : [
		'modelClasses',
		'database',
		'dynamicEnv',
		'routes',
		'middleware',
		'logWindow',
		'settings',
		'defaultRoutesModelLookupTable'
	],
	#category : #'RatPack-Core'
}

{ #category : #constants }
RPApplication class >> apiRoutePrefix [

	^ '/api/'
]

{ #category : #constants }
RPApplication class >> badRequestPage [

	 ^ '<!DOCTYPE html>
<html>
<body>

400 - bad request


</body>
</html>'

]

{ #category : #constants }
RPApplication class >> contentDecoders [

	^ Dictionary newFrom: {
		'application/json' -> RPJsonContentDecoder }
]

{ #category : #constants }
RPApplication class >> defaultMode [

	^ #debug
]

{ #category : #constants }
RPApplication class >> defaultName [

	^ 'RatPack'
]

{ #category : #constants }
RPApplication class >> defaultPort [

	^ 4567
]

{ #category : #constants }
RPApplication class >> errorPage [

	^ '<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title><%= anException class %> at <%= self request url %></title>

<script type="text/javascript">
//<!--
function toggle(id) {
var pre = document.getElementById("pre-" + id);
var post = document.getElementById("post-" + id);
var context = document.getElementById("context-" + id);

if (pre.style.display == ''block'') {
pre.style.display = ''none'';
context.style.background = "none";
} else {
pre.style.display = ''block'';
context.style.background = "#fffed9";
}
}

function toggleBacktrace(){
var bt = document.getElementById("backtrace");
var toggler = document.getElementById("expando");

if (bt.className == ''condensed'') {
bt.className = ''expanded'';
toggler.innerHTML = "(condense)";
} else {
bt.className = ''condensed'';
toggler.innerHTML = "(expand)";
}
}
//-->
</script>

<style type="text/css" media="screen">
* {margin: 0; padding: 0; border: 0; outline: 0;}
div.clear {clear: both;}
body {background: #EEEEEE; margin: 0; padding: 0;
font-family: ''Lucida Grande'', ''Lucida Sans Unicode'',
''Garuda'';}
code {font-family: ''Lucida Console'', monospace;
font-size: 12px;}
li {height: 18px;}
ul {list-style: none; margin: 0; padding: 0;}
ol:hover {cursor: pointer;}
ol li {white-space: pre;}
#explanation {font-size: 12px; color: #666666;
margin: 20px 0 0 100px;}
/* WRAP */
#wrap {width: 1000px; background: #FFFFFF; margin: 0 auto;
padding: 30px 50px 20px 50px;
border-left: 1px solid #DDDDDD;
border-right: 1px solid #DDDDDD;}
/* HEADER */
#header {margin: 0 auto 25px auto;}
#header img {float: left;}
#header #summary {float: left; margin: 12px 0 0 20px; width:660px;
font-family: ''Lucida Grande'', ''Lucida Sans Unicode'';}
h1 {margin: 0; font-size: 36px; color: #981919;}
h2 {margin: 0; font-size: 22px; color: #333333;}
#header ul {margin: 0; font-size: 12px; color: #666666;}
#header ul li strong{color: #444444;}
#header ul li {display: inline; padding: 0 10px;}
#header ul li.first {padding-left: 0;}
#header ul li.last {border: 0; padding-right: 0;}
/* BODY */
#backtrace,
#get,
#post,
#cookies,
#rack {width: 980px; margin: 0 auto 10px auto;}
p#nav {float: right; font-size: 14px;}
/* BACKTRACE */
a#expando {float: left; padding-left: 5px; color: #666666;
font-size: 14px; text-decoration: none; cursor: pointer;}
a#expando:hover {text-decoration: underline;}
h3 {float: left; width: 100px; margin-bottom: 10px;
color: #981919; font-size: 14px; font-weight: bold;}
#nav a {color: #666666; text-decoration: none; padding: 0 5px;}
#backtrace li.frame-info {background: #f7f7f7; padding-left: 10px;
font-size: 12px; color: #333333;}
#backtrace ul {list-style-position: outside; border: 1px solid #E9E9E9;
border-bottom: 0;}
#backtrace ol {width: 920px; margin-left: 50px;
font: 10px ''Lucida Console'', monospace; color: #666666;}
#backtrace ol li {border: 0; border-left: 1px solid #E9E9E9;
padding: 2px 0;}
#backtrace ol code {font-size: 10px; color: #555555; padding-left: 5px;}
#backtrace-ul li {border-bottom: 1px solid #E9E9E9; height: auto;
padding: 3px 0;}
#backtrace-ul .code {padding: 6px 0 4px 0;}
#backtrace.condensed .system,
#backtrace.condensed .framework {display:none;}
/* REQUEST DATA */
p.no-data {padding-top: 2px; font-size: 12px; color: #666666;}
table.req {width: 980px; text-align: left; font-size: 12px;
color: #666666; padding: 0; border-spacing: 0;
border: 1px solid #EEEEEE; border-bottom: 0;
border-left: 0;
clear:both}
table.req tr th {padding: 2px 10px; font-weight: bold;
background: #F7F7F7; border-bottom: 1px solid #EEEEEE;
border-left: 1px solid #EEEEEE;}
table.req tr td {padding: 2px 20px 2px 10px;
border-bottom: 1px solid #EEEEEE;
border-left: 1px solid #EEEEEE;}
/* HIDE PRE/POST CODE AT START */
.pre-context,
.post-context {display: none;}

table td.code {width:750px}
table td.code div {width:750px;overflow:hidden}
</style>
</head>
<body>

<% startContext := anException signalerContext 
   		   	       ifNotNilDo: [:ctxt | ctxt]
				ifNil: [thisContext]. %>

<div id="wrap">
<div id="header">
<img src="<%= self request url %>/__sinatra__/500.png" alt="application error" height="161" width="313" />
<div id="summary">
<h1><strong><%= anException class %></strong> at <strong><%= self request url %>
</strong></h1>
<h2><%= anException messageText  %></h2>
<ul>
<li class="first"><strong>file:</strong> <code>
<%= startContext methodClass  %></code></li>
<li><strong>location:</strong> <code><%= startContext selector  %>
</code></li>
<li class="last"><strong>line:
</strong> <%= startContext pc %></li>
</ul>
</div>
<div class="clear"></div>
</div>

<div id="backtrace" class=''condensed''>
<h3>BACKTRACE</h3>
<p><a href="#" id="expando"
onclick="toggleBacktrace(); return false">(expand)</a></p>
<p id="nav"><strong>JUMP TO:</strong>
<a href="#get-info">GET</a>
<a href="#post-info">POST</a>
<a href="#cookie-info">COOKIES</a>
<a href="#env-info">ENV</a>
</p>
<div class="clear"></div>

<ul id="backtrace-ul">

<% id := 1. %>
<% (startContext stackOfSize: 100) do: [:frame| %>

<li class="frame-info <%= frame methodClass %>">
<code><%= frame methodClass %></code> in
<code><strong><%= frame selector %></strong></code>
</li>

<li class="code <%= frame methodClass %>">
<ol start="<%= 1 %>"
class="pre-context" id="pre-<%= id %>"
onclick="toggle(<%= id %>);">
<% frame tempNames doWithIndex: [:title :index | %>
<li class="pre-context-line"><code><%= (title asString, 
    $: asString, Character space asString,
    (([frame tempAt: index] on: Error do: [nil]) printStringLimitedTo: (160 - 3 - title size max: 1))) asHtml %></code></li>
<% ]. %>
</ol>

<ol start="<%= frame pc %>" class="context" id="<%= id %>"
onclick="toggle(<%= id %>);">
<li class="context-line" id="context-<%= id %>"><code><%= frame sourceCode asString asHtml %></code></li>
</ol>

<div class="clear"></div>
</li>

<% id := id + 1. %>
<% ]. %>

</ul>
</div> <!-- /BACKTRACE -->

<div id="get">
<h3 id="get-info">GET</h3>
<% self request method = ''GET'' ifTrue: [ %>
<table class="req">
<tr>
<th>Variable</th>
<th>Value</th>
</tr>
<% self request getFields associationsDo: [:assoc| %>
<tr>
<td><%= assoc key asString asHtml %></td>
<td class="code"><div><%= assoc value printString asHtml %></div></td>
</tr>
<% ]. %>
</table>
<% ] ifFalse: [ %>
<p class="no-data">No GET data.</p>
<% ]. %>
<div class="clear"></div>
</div> <!-- /GET -->

<div id="post">
<h3 id="post-info">POST</h3>
<% self request method = ''POST'' ifTrue: [ %>
<table class="req">
<tr>
<th>Variable</th>
<th>Value</th>
</tr>
<% self request postFields associationsDo: [:assoc| %>
<tr>
<td><%= assoc key asString asHtml %></td>
<td class="code"><div><%= assoc value printString asHtml %></div></td>
</tr>
<% ]. %>
</table>
<% ] ifFalse: [ %>
<p class="no-data">No POST data.</p>
<% ]. %>
<div class="clear"></div>
</div> <!-- /POST -->

<div id="cookies">
<h3 id="cookie-info">COOKIES</h3>
<% self request cookies isEmpty ifFalse: [ %>
<table class="req">
<tr>
<th>Variable</th>
<th>Value</th>
</tr>
<% self request cookies associationsDo: [:assoc| %>
<tr>
<td><%= assoc key asString asHtml %></td>
<td class="code"><div><%= assoc value printString asHtml %></div></td>
</tr>
<% ]. %>
</table>
<% ] ifTrue: [ %>
<p class="no-data">No cookie data.</p>
<% ]. %>
<div class="clear"></div>
</div> <!-- /COOKIES -->

<p id="explanation">You''re seeing this error because you have
enabled the <code>deployment</code> mode.</p>
</div> <!-- /WRAP -->
</body>
</html>'
]

{ #category : #constants }
RPApplication class >> forceCorrectContentDecoding [

	^ false
]

{ #category : #constants }
RPApplication class >> htmlRoutePrefix [

	^ '/html' 
]

{ #category : #constants }
RPApplication class >> notFoundPage [

	 ^ '<!DOCTYPE html>
<html>
<head>
<style type="text/css">
body {
	text-align: center;
	font-family: helvetica,arial;
	font-size: 22px;
	color: #888;
	margin:20px
}
#c {
	margin: 0 auto;
	width: 500px;
	text-align: left
}
.methodName { color: black; }
.pragmaKey { color: green; }
.string { color: purple; }
.return { color: darkRed; }
</style>
</head>
<body>
<h2>The Rat Pack doesn&rsquo;t appear in this flick.</h2>
<div id="c">
Try this:
<pre>
<span class="methodName">handleRequestFor<%=

	(self request pathParts ifNil: [#('''')]) inject: '''' into: [:acc :next | acc, next capitalized]
	
%>
</span>
  &lt;<span class="pragmaKey"><%=

self request method asLowercase 

%></span>: <span class="string">''<%=

self request url

%>''</span>&gt;
  <span class="return">^</span> <span class="string">''Hello World''</span>
</pre>
</div>
<div id="c">
Or that:
<pre>
<span class="methodName">handleRequestFor<%=

	(self request pathParts ifNil: [#('''')]) inject: '''' into: [:acc :next | acc, next capitalized]

%>: argument</span>
  &lt;<span class="pragmaKey"><%=

self request method asLowercase

%></span>: <span class="string">''<%=

	self request pathParts isEmpty
		ifTrue: [''(.*)'']
		ifFalse: [(self request pathParts allButLast inject: '''' into: [:acc :next | acc, ''/'', next]), ''/%'']

%>''</span>&gt;
  <span class="return">^</span> <span class="string">''Hello ''</span>, argument
</pre>
</div>
<% self request pathParts ifNotEmpty: [ %>
<div id="c">
Or even this:
<pre>
<span class="methodName">handleRequestFor<%=

	(self request pathParts ifNil: [#('''')]) inject: '''' into: [:acc :next | acc, next capitalized]

%>: argument</span>
  &lt;<span class="pragmaKey"><%=

self request method asLowercase

%></span>: <span class="string">''<%=

	(self request pathParts allButLast inject: '''' into: [:acc :next | acc, ''/'', next]), ''/(.+)''

%>''</span>&gt;
  <span class="return">^</span> <span class="string">''Hello ''</span>, argument
</pre>
</div>
<% ]. %>
</body>
</html>'

]

{ #category : #constants }
RPApplication class >> objectNotFoundJson [

	^ '{"error": "404 - object not found!"}'
]

{ #category : #constants }
RPApplication class >> parsedRequestContentsKey [ 

	^ #rpParsedRequestContentsKey
]

{ #category : #constants }
RPApplication class >> requestKey [

	^ #rpRequest
]

{ #category : #constants }
RPApplication class >> requestMethods [

	^ #(get: #put: #post: #delete: #patch: #head: #options: #trace: #connect:)
]

{ #category : #constants }
RPApplication class >> responseKey [

	^ #rpResponse
]

{ #category : #accessing }
RPApplication class >> routes [

	^ Array streamContents: [:stream |
		#(get: #put: #post: #delete: #patch: #head: #options: #trace: #connect:) do: [:verb |
			stream nextPutAll: (Pragma allNamed: verb from: self to: RPApplication)]]
]

{ #category : #'instance creation' }
RPApplication class >> run [

	^ self runIn: self defaultMode on: self defaultPort named: self defaultName
]

{ #category : #'instance creation' }
RPApplication class >> runIn: mode on: aPort named: aString [
	
	| service |
	service := self on: aPort named: aString.
	^ service
		mode: mode;
		start;
		yourself

]

{ #category : #accessing }
RPApplication class >> services [

	^ super services select: [:service | service isKindOf: self]
]

{ #category : #constants }
RPApplication class >> wildcard [
 
	^ '/([^/]+)'
]

{ #category : #accessing }
RPApplication >> addCookies: aCollection [
	
	^ self dynamicEnvironment addCookies: aCollection
]

{ #category : #'model handling' }
RPApplication >> addDefaultApiGetRoutesFor: anRPModelClass [

	| apiUrl |

	apiUrl := self createDefaultRouteFor: anRPModelClass withPrefix: (self settings apiRoutePrefix).
	(self routesFor: #get:) add: ((apiUrl, self class wildcard) -> #'writeObjectForGet:id:').
	(self routesFor: #get:) add: (apiUrl -> #'writeObjectsForGet:')

]

{ #category : #'model handling' }
RPApplication >> addDefaultDeleteRoutesFor: anRPModelClass [

	| apiUrl |
	apiUrl := self createDefaultRouteFor: anRPModelClass withPrefix: (self settings apiRoutePrefix).
	(self routesFor: #delete:) add: ((apiUrl , self class wildcard) -> #writeRemovedObjectForDelete:id:).
]

{ #category : #'model handling' }
RPApplication >> addDefaultGetRoutesFor: anRPModelClass [

	self addDefaultApiGetRoutesFor: anRPModelClass.
	self addDefaultHtmlGetRoutesFor: anRPModelClass. 
]

{ #category : #'model handling' }
RPApplication >> addDefaultHtmlGetRoutesFor: anRPModelClass [

	| htmlUrl |

	htmlUrl := self createDefaultRouteFor: anRPModelClass withPrefix: self settings htmlRoutePrefix. 
	(self routesFor: #get:) add: ((htmlUrl, self class wildcard) -> #writeObjectAsHtmlForGet:id:).
	(self routesFor: #get:) add: (htmlUrl -> #writeObjectsAsHtmlForGet:)
	
]

{ #category : #'model handling' }
RPApplication >> addDefaultPostRoutesFor: anRPModelClass [
	
	| apiUrl |

	apiUrl := self createDefaultRouteFor: anRPModelClass withPrefix: (self settings apiRoutePrefix).
	(self routesFor: #post:) add: (apiUrl -> #writeNewObjectForPost:).
	
]

{ #category : #'model handling' }
RPApplication >> addDefaultPutRoutesFor: anRPModelClass [	

	| apiUrl |
	apiUrl := self createDefaultRouteFor: anRPModelClass withPrefix: (self settings apiRoutePrefix).
	(self routesFor: #put:) add: ((apiUrl, self class wildcard) -> #writeObjectForPut:id:).
	
]

{ #category : #'model handling' }
RPApplication >> addModelClass: aRPModelClass [

	self database createTableFor: aRPModelClass.
	self addModelRouteFor: aRPModelClass.
	self modelClasses at: (aRPModelClass name) put: aRPModelClass.

]

{ #category : #'model handling' }
RPApplication >> addModelRouteFor: anRPModelClass [

	self addDefaultGetRoutesFor: anRPModelClass.
	self addDefaultDeleteRoutesFor: anRPModelClass.
	self addDefaultPostRoutesFor: anRPModelClass.	
	self addDefaultPutRoutesFor: anRPModelClass
	

]

{ #category : #accessing }
RPApplication >> attachment: aFilename [
	| attachmentHeader |
	attachmentHeader := 'attachment; filename="', (FileDirectory localNameFor: aFilename), '"'.
	self response headersAt: #'Content-Disposition' put: attachmentHeader.
	(FileDirectory default mimeTypesFor: aFilename) ifNotNilDo: [:mimeTypes |
		self response headersAt: #ContentType put: mimeTypes first ].

]

{ #category : #actions }
RPApplication >> badRequest [

	self contentType: 'text/html'.
	self status: 400.
	self body: (self est: self settings badRequestPage)
]

{ #category : #accessing }
RPApplication >> body [
	
	^ self dynamicEnvironment body

]

{ #category : #private }
RPApplication >> body: aStringOrStream [
	
	self dynamicEnvironment body: aStringOrStream.
]

{ #category : #private }
RPApplication >> cacheAt: aSymbol ifAbsentPut: aBlock [

	^ (self threadLocal: #cache ifAbsentPut: [Dictionary new])
		at: aSymbol ifAbsentPut: aBlock value
]

{ #category : #accessing }
RPApplication >> contentLength [

	^ self dynamicEnvironment contentLength
]

{ #category : #accessing }
RPApplication >> contentType [

	^ self dynamicEnvironment contentType
]

{ #category : #accessing }
RPApplication >> contentType: aString [

	^ self dynamicEnvironment contentType: aString
]

{ #category : #accessing }
RPApplication >> cookies [
	
	^ self dynamicEnvironment cookies
]

{ #category : #routing }
RPApplication >> createCallChain [
	
	| callChain |
	self setRouteHandlerAndArguments.
	callChain := self middleware instancesForHandler: self routeHandler.
	callChain add: (RPHandlerMiddleware new application: self).
	^ callChain
]

{ #category : #routing }
RPApplication >> createDefaultRouteFor: anRPModelClass withPrefix: aPrefix [
	| url routeSuffix |
	
	anRPModelClass overridesDefaultRoute
		ifTrue: [ routeSuffix := anRPModelClass defaultRoute. ]
		ifFalse: [ routeSuffix := self createRouteSuffixFor: anRPModelClass ].
	self defaultRoutesModelLookupTable at: routeSuffix put: anRPModelClass.
	
	url := aPrefix, '(', routeSuffix ,')'.
	^ url
	
	
	

]

{ #category : #routing }
RPApplication >> createRouteSuffixFor: anRPModelClass [
	| routeSuffix |
	routeSuffix := anRPModelClass name.
	self settings routeNamingStrategies do: [ :strategy | 
		routeSuffix := strategy nameRoute: routeSuffix. ].
	^ routeSuffix
]

{ #category : #accessing }
RPApplication >> database [

	^ database ifNil: [database := RPImageDatabase new.]
]

{ #category : #accessing }
RPApplication >> database: aDatabase [

	database := aDatabase
]

{ #category : #routing }
RPApplication >> decodeContent: aContent type: aType [

	| decoder |
	decoder := (self class contentDecoders) at: (aType asLowercase) ifAbsent: [^ self error: 'Decoder missing'].

	self parsedRequestContents: (decoder decode: aContent).
]

{ #category : #accessing }
RPApplication >> defaultRoutesModelLookupTable [
	^ defaultRoutesModelLookupTable
]

{ #category : #accessing }
RPApplication >> defaultRoutesModelLookupTable: anObject [
	defaultRoutesModelLookupTable := anObject
]

{ #category : #'object handling' }
RPApplication >> deleteFromRequest: aRPModelname with: anId [
	
	| anRPModelClass |
	anRPModelClass := self getRegisteredModel: aRPModelname.
	self database deleteObject: anId from: anRPModelClass
	
]

{ #category : #logging }
RPApplication >> disableLogging [ 

	self logWindow disableLogging
]

{ #category : #private }
RPApplication >> dynamicEnvironment [

	^ dynamicEnv at: Processor activeProcess ifAbsentPut: [
			(RPDynamicEnv new)
			settings: settings;
			yourself. ]
]

{ #category : #logging }
RPApplication >> enableLogging [ 

	self logWindow enableLogging 
]

{ #category : #templating }
RPApplication >> est: aString [
	"Slow, because it reifies the stack, but allows access to arguments and temps"
	self flag: #ignoreForCoverage. "this causes the testError to fail"
	^ RPEmbeddedSmalltalk render: aString in: thisContext sender
]

{ #category : #routing }
RPApplication >> findHandlerFor: aHttpRequest in: routes [

	^ routes detect: [:route | (RxMatcher forString: route key) matches: (aHttpRequest url)]
						ifNone: [#'notFound']. 
 
]

{ #category : #'object handling' }
RPApplication >> getAllModels [

	| aJsonString |
	aJsonString := '{"models":[',
		((self modelClasses asOrderedCollection collect: [:each |
      		each structureAsJson]) joinSeparatedBy: ','), ']}'.
      ^ self sendJson: aJsonString
]

{ #category : #endpoint }
RPApplication >> getAllModelsFromRequestAsHtml [
	
	 ^ self sendHtml: ('<!DOCTYPE html><html><head></head><body><h3>Models:</h3>', 
			((self modelClasses asOrderedCollection collect: [:each |
				'<a href="/html/', (each name), '">', (each name), '</a><br>']) join),
			'</body></html>') asString
]

{ #category : #'model handling' }
RPApplication >> getModelForRouteSuffix: aRouteSuffix [

	^ self defaultRoutesModelLookupTable at: aRouteSuffix
]

{ #category : #'object handling' }
RPApplication >> getObjectFromRequest: aRPModelname with: anID [

      | modelObject aRPModelClass|
	aRPModelClass := self getRegisteredModel: aRPModelname.
	[modelObject := self database loadModelObject: anID from: aRPModelClass] 
		on: Warning do: [^ self objectNotFound].
 
       ^ self sendJson: (modelObject asJson)
]

{ #category : #endpoint }
RPApplication >> getObjectFromRequestAsHtml: aRPModelname with: anID [

      | modelObject aHtmlString aRPModelClass |
	aHtmlString := '<html><head></head><body><h3>Object-ID: ', anID, '</h3>'.
	aRPModelClass := self getRegisteredModel: aRPModelname.
	[modelObject := self database loadModelObject: anID from: aRPModelClass] on: Warning do: [
		^ 'Object not found!'].
       ^ self sendHtml: (aHtmlString, (aRPModelClass createHtmlTemplateFor: (modelObject object)), '</body></html>')
]

{ #category : #endpoint }
RPApplication >> getObjectsAsHtml: aRPModelname [
 
      | objectString objects |
	objectString := ''.
      objects := self database loadModelObjectsOf: (self getRegisteredModel: aRPModelname).
      ^ (objects collect: [:each |
               '<br>ID: <a href="/html/', (aRPModelname), '/', (each metadata at: #id), '">',  (each metadata at: #id), '</a>']) join

]

{ #category : #routing }
RPApplication >> getRegexHandlerFromUrl [

	| method methodRoutes regexHandlerAssociation |
	method := self request method asLowercase asSymbol asSimpleSetter.
	methodRoutes := self routesFor: method.

	^ regexHandlerAssociation := methodRoutes
				detect: [:route | (RxMatcher forString: route key) matches: self request url]
				ifNone: ['' -> #notFound]
]

{ #category : #'model handling' }
RPApplication >> getRegisteredModel: aString [

	^ (self modelClasses at: (aString asSymbol))
]

{ #category : #endpoint }
RPApplication >> getRegisteredModelsFromRequestAsHtml: aRPModelname [
 
      | aRPModelClass aHtmlString subStrings |
	aRPModelClass := self getRegisteredModel: aRPModelname.
	subStrings := OrderedCollection new.
	aHtmlString :=  '<b>Model:</b> ',
					aRPModelname,
					'<br><b>Metadata:</b> {"dataTypes":{',
					((aRPModelClass dataTypes associations collect: [:each |
						each asJsonString]) joinSeparatedBy: ','),
					'}}<br><br><b>Objects:</b>',
					(self getRegisteredObjectsFromRequestAsHtml: aRPModelname).
	^ self sendHtml: aHtmlString
]

{ #category : #endpoint }
RPApplication >> getRegisteredObjectsFromRequest: aRPModelname [
 
      | modelObjects string aRPModelClass |
	aRPModelClass := self getRegisteredModel: aRPModelname.
      modelObjects := self database loadModelObjectsOf: aRPModelClass.  
	string := '{"data":[', ((modelObjects collect: [:each |
		each asJson]) joinSeparatedBy: ','), ']}'.
  	^ self sendJson: string
]

{ #category : #endpoint }
RPApplication >> getRegisteredObjectsFromRequestAsHtml: aRPModelname [
 
      | objectString objects |
	objectString := ''.
      objects := self database loadModelObjectsOf: (self getRegisteredModel: aRPModelname).
      ^ (objects collect: [:each |
               '<br>ID: <a href="/html/', (aRPModelname), '/', (each metadata at: #id), '">',  (each metadata at: #id), '</a>']) join

]

{ #category : #accessing }
RPApplication >> headers [

	^ self dynamicEnvironment headers
]

{ #category : #accessing }
RPApplication >> headers: aDictionary [

	self response fields addAll: aDictionary.
]

{ #category : #accessing }
RPApplication >> headersAt: aKey [

	^ self dynamicEnvironment headersAt: aKey
]

{ #category : #accessing }
RPApplication >> headersAt: aKey ifAbsent: aBlock [

	^ self dynamicEnvironment headersAt: aKey ifAbsent: aBlock
]

{ #category : #accessing }
RPApplication >> headersAt: aKey put:	aValue [
	
	(self dynamicEnvironment) headersAt: aKey put: aValue.
]

{ #category : #accessing }
RPApplication >> headersPut: aDictionary [
 			
	(self dynamicEnvironment) headersPut: aDictionary.
]

{ #category : #'initialize-release' }
RPApplication >> initialize [

	super initialize.
	
	settings := RPSettings new.
	
	self
		initializeSettings;
		initializeDynamicVariables;
		initializeRoutes;
		initializePragmaMiddleware;
		initializeLogging;
		onRequestDo: [:httpRequest | self processRequest: httpRequest].
]

{ #category : #private }
RPApplication >> initializeDynamicVariables [

	dynamicEnv := WeakIdentityKeyDictionary new
]

{ #category : #'initialize-release' }
RPApplication >> initializeEndpointRoutes [
	"View all objects/models at /api or /html"

	| apiUrl htmlUrl |
	apiUrl := '/api'.
	htmlUrl := '/html'.
	(self routesFor: #get:) add: (apiUrl -> #writeModelsForGet).
	(self routesFor: #get:) add: (htmlUrl -> #writeModelsAsHtmlForGet).
]

{ #category : #logging }
RPApplication >> initializeLogging [

	logWindow := RPLogWindow new.
	self disableLogging
]

{ #category : #'initialize-release' }
RPApplication >> initializePragmaMiddleware [

	| pragmas |
	pragmas := (Pragma allNamed: #middleware: from: self class to: RPApplication).
	pragmas do: [:pragma | self middleware registerMiddleware: (pragma argumentAt: 1) asOrderedCollection forHandler: pragma selector. ].
]

{ #category : #'initialize-release' }
RPApplication >> initializePragmaRoutes [

	RPApplication requestMethods do: [:method | | pragmas | 
		routes at: method put: (OrderedCollection new).
		pragmas := (Pragma allNamed: method from: self class to: RPApplication).
		pragmas do: [:pragma | 
						(routes at: method) add: ((pragma argumentAt: 1) -> pragma selector)]]
]

{ #category : #'initialize-release' }
RPApplication >> initializeRoutes [

	routes := IdentityDictionary new.
	self initializePragmaRoutes.
	self initializeEndpointRoutes. 	
		
	self defaultRoutesModelLookupTable: Dictionary new.
	
	
]

{ #category : #'initialize-release' }
RPApplication >> initializeSettings [
	
	"For subclasses to override. You can manipulate self settings here as you wish before the server is started"
]

{ #category : #logging }
RPApplication >> logWindow [ 

	^ logWindow
]

{ #category : #accessing }
RPApplication >> middleware [

	^ middleware ifNil: [ middleware := RPMiddlewareContainer new settings: self settings. ]
]

{ #category : #accessing }
RPApplication >> modelClasses [
	
	^ modelClasses ifNil: [ modelClasses := IdentityDictionary new]
]

{ #category : #actions }
RPApplication >> notFound [

	self contentType: 'text/html'.
	self status: 404.
	self body: (self est: self settings notFoundPage)
]

{ #category : #actions }
RPApplication >> objectNotFound [

	self contentType: 'application/json'.
	self status: 404.
	self body: self settings objectNotFoundJson.
]

{ #category : #accessing }
RPApplication >> params [
	"Replaces param keys that have only one value with the value,
	so we don't have to deal with arrays all over the place"
	self request ifNil: [^ Dictionary new].
	^ self cacheAt: #params ifAbsentPut: [
		Dictionary newFrom: (Array streamContents: [:stream |
			self request fields keysAndValuesDo: [:key :value || param |
				param := value size = 1 ifTrue: [value first] ifFalse: [value].
				stream nextPut: key -> param]])]
]

{ #category : #routing }
RPApplication >> parseContent: aContent type: aType [

	| parser |
	parser := (self settings contentParsers) at: (aType asLowercase) ifAbsent: [^ self error: 'Parser missing!'].

	self parsedRequestContents: (parser parse: aContent).
]

{ #category : #private }
RPApplication >> parseRequestContent: aHttpRequest [

	| method |
	method := aHttpRequest method asLowercase asSymbol.
	
	[
		(method = #put) ifTrue: [ self parseContent: aHttpRequest rawPutContents type: aHttpRequest contentType. ].
		(method = #post) ifTrue: [ self parseContent: aHttpRequest rawPostContents type: aHttpRequest contentType. ].
	] on: Error do: [ :sig |
		self parsedRequestContents: nil.
		self settings forceCorrectContentDecoding ifTrue: [ ^ sig pass ] ifFalse: [ ^ sig return ] ].
]

{ #category : #accessing }
RPApplication >> parsedRequestArguments [

	^ self dynamicEnvironment parsedRequestArguments
]

{ #category : #private }
RPApplication >> parsedRequestArguments: anArgument [

	self dynamicEnvironment parsedRequestArguments: anArgument.
]

{ #category : #accessing }
RPApplication >> parsedRequestContents [

	^ self dynamicEnvironment parsedRequestContents
]

{ #category : #private }
RPApplication >> parsedRequestContents: aContent [

	self dynamicEnvironment parsedRequestContents: aContent.
]

{ #category : #'object handling' }
RPApplication >> persistObjectBy: aDictionary from: aRPModelClass [

	^ self database persist: (aRPModelClass createObjectFrom: aDictionary) from: aRPModelClass
]

{ #category : #'object handling' }
RPApplication >> postFromRequest: aRPModelname [
	
	| jsonString aRPModelClass responseId |
	aRPModelClass := self getRegisteredModel: aRPModelname.
	jsonString := self request rawPostContents.
	responseId := self persistObjectBy: jsonString from: aRPModelClass.
	^ self getObjectFromRequest: aRPModelname with: responseId.

]

{ #category : #routing }
RPApplication >> processRequest: aHttpRequest [

	self 
		request: aHttpRequest;
		response: (HttpResponse fromString: '').

	" start request tracking "
	[ self parseRequestContent: aHttpRequest ] on: Error do: [:e | ^ self badRequest ].
	
	[self route: aHttpRequest] on: Error do: [:e | self serverError: e].

	self logWindow logRequest: aHttpRequest andResponse: self response.
	^ self response

]

{ #category : #actions }
RPApplication >> redirectBack [

	self redirectTo: self request referer
]

{ #category : #actions }
RPApplication >> redirectTo: aString [

	self
		status: 302;
		contentType: MIMEDocument contentTypeHtml;
		body: 'Temporarily moved to: <A HREF="', aString, '">', aString, '</A>';
		headersPut: {'Location' -> aString asString copy. 'URI' -> aString asString copy} asDictionary.

]

{ #category : #'model handling' }
RPApplication >> registerModel: aRPModelClass [
	
	(aRPModelClass validateRefClass) 
		ifFalse: [self notify: 'Invalid ModelClass. Could not register modelclass: ' , aRPModelClass name , '  to App!'. ^self].	
	
	self addModelClass: aRPModelClass


	
]

{ #category : #'model handling' }
RPApplication >> removeModel: aRPModelClass [
	
	self modelClasses removeKey: (aRPModelClass name asSymbol).
	self database dropTableFor: aRPModelClass.
	self removeModelRouteFor: aRPModelClass
	
]

{ #category : #'model handling' }
RPApplication >> removeModelRouteFor: aRPModelClass [

	self class requestMethods do: [:method | | routes |
				routes := self routesFor: method.
				routes removeAllSuchThat: [:route | (route key includesSubString: aRPModelClass name)]]
]

{ #category : #accessing }
RPApplication >> request [
	
	^ self dynamicEnvironment request

]

{ #category : #private }
RPApplication >> request: aValue [
	
	self dynamicEnvironment request: aValue

]

{ #category : #accessing }
RPApplication >> response [
	
	^ self dynamicEnvironment response

]

{ #category : #private }
RPApplication >> response: aValue [
	
	^ self dynamicEnvironment response: aValue

]

{ #category : #routing }
RPApplication >> route: aHttpRequest [ 
	
	"The debugDynamicEnv is only a local variable to simplify the debugging of dynamicEnvironment which depends on ThreadID and is not inspectable in debugger, because of a bug in the Debugger itself"
	
	| callChain next index debugDynamicEnv |
	debugDynamicEnv := self dynamicEnvironment.
	callChain := self createCallChain.
	
	index := 0.
	next := [index := index +1.
		(callChain at: index) handle: self dynamicEnvironment next: next.].
	
	next value.
	debugDynamicEnv := self dynamicEnvironment.
]

{ #category : #routing }
RPApplication >> routeHandler [

		^ self dynamicEnvironment handler
]

{ #category : #routing }
RPApplication >> routeHandler: aHandler [

		self dynamicEnvironment handler: aHandler.
]

{ #category : #accessing }
RPApplication >> routes [

	^ routes
]

{ #category : #accessing }
RPApplication >> routesFor: aMethod [ 

	^ routes at: aMethod
]

{ #category : #actions }
RPApplication >> sendHtml: aHtmlString [
	
	self
		status: 200;
		contentType: 'text/html';
		body:  aHtmlString contents;
		headersAt: 'server' put: self name.

]

{ #category : #actions }
RPApplication >> sendJson: aJsonString [ 
	
	self
		status: 200;
		contentType: 'application/json';
		body:  aJsonString contents;
		headersAt: 'server' put: self name.

]

{ #category : #actions }
RPApplication >> serverError: anException [
	
	self contentType: 'text/html'.
	self status: 500.
	self isDebugMode ifTrue: [anException signal].
	self body: (self est: self settings errorPage)
]

{ #category : #routing }
RPApplication >> setArgumentsToEnv: aRegex [

	| matcher |
	matcher := (RxMatcher forString: aRegex).
	matcher matches: self request url.
	"perform:withArguments: requires all arguments to be passed as array."
	self parsedRequestArguments: matcher subexpressions allButFirst.
]

{ #category : #routing }
RPApplication >> setRouteHandlerAndArguments [
	
	| regexHandlerAssociation |
	regexHandlerAssociation := self getRegexHandlerFromUrl.
	self routeHandler: regexHandlerAssociation value.
	self setArgumentsToEnv: regexHandlerAssociation key.
]

{ #category : #accessing }
RPApplication >> settings [

	^ settings
]

{ #category : #'starting and stopping' }
RPApplication >> start [

	self settings serverStart.
	
	super start.
]

{ #category : #accessing }
RPApplication >> status [
	
	^ self dynamicEnvironment status

]

{ #category : #accessing }
RPApplication >> status: aSymbolOrInteger [

	self dynamicEnvironment status: aSymbolOrInteger.
]

{ #category : #'starting and stopping' }
RPApplication >> stop [

	self settings serverStop.
	
	super stop.
]

{ #category : #private }
RPApplication >> threadLocal: aSymbol [
	
	^ self dynamicEnvironment at: aSymbol ifAbsent: []

]

{ #category : #private }
RPApplication >> threadLocal: aSymbol ifAbsentPut: aBlock [
	
	^ (self threadLocal: aSymbol) ifNil: [self threadLocal: aSymbol put: aBlock value]

]

{ #category : #private }
RPApplication >> threadLocal: aSymbol put: aValue [
	
	^ self dynamicEnvironment at: aSymbol put: aValue

]

{ #category : #'object handling' }
RPApplication >> updateFromRequest: aRPModelname with: anId [
 
      | updatedObject jsonString aRPModelClass |
	aRPModelClass := self getRegisteredModel: aRPModelname.
	jsonString := self request rawPutContents.
	updatedObject := aRPModelClass createObject: jsonString.
	self database update: updatedObject with: anId from: aRPModelClass.
	^ self getObjectFromRequest: aRPModelname with: anId

]

{ #category : #private }
RPApplication >> updatePragmas [

	 #(#get: #put: #post: #delete: #patch: #head: #options: #trace: #connect:) do: [:method | 
		routes at: method put: (Pragma allNamed: method from: self class to: RPApplication)]
]

{ #category : #accessing }
RPApplication >> url [

	^ String streamContents: [:stream |
		stream nextPutAll: 'http://'.
		stream nextPutAll: (self request host ifNil: ['localhost'])]

]

{ #category : #endpoint }
RPApplication >> writeModelsAsHtmlForGet [

	 self sendHtml: ('<!DOCTYPE html><html><head></head><body><h3>Models:</h3>', 
			((self modelClasses asOrderedCollection collect: [:each |
				'<a href="/html/', (each name), '">', (each name), '</a><br>']) join),
			      '</body></html>') asString
]

{ #category : #'object handling' }
RPApplication >> writeModelsForGet [

	| aJsonString |
	aJsonString := '{"models":[',
		((self modelClasses asOrderedCollection collect: [:each |
      		each structureAsJson]) joinSeparatedBy: ','), ']}'.
      self sendJson: aJsonString
]

{ #category : #'object handling' }
RPApplication >> writeNewObjectForPost: aRouteSuffix [

	| aRPModelClass responseId |
	
	self parsedRequestContents ifNil: [^ self badRequest].
	
	aRPModelClass := self getModelForRouteSuffix: aRouteSuffix.
	responseId := self persistObjectBy: self parsedRequestContents from: aRPModelClass.
	self writeObjectForGet: aRouteSuffix id: responseId.

]

{ #category : #endpoint }
RPApplication >> writeObjectAsHtmlForGet: aRPModelname id: anID [

      | modelObject aHtmlString aRPModelClass |
	aHtmlString := '<html><head></head><body><h3>Object-ID: ', anID, '</h3>'.
	aRPModelClass := self getRegisteredModel: aRPModelname.
	[ modelObject := self database loadModelObject: anID from: aRPModelClass ] on: Warning do: [
		^ 'Object not found!'].
      self sendHtml: (aHtmlString, (aRPModelClass createHtmlTemplateFor: (modelObject object)), '</body></html>')
]

{ #category : #'object handling' }
RPApplication >> writeObjectForGet: aRouteSuffix id: anID [

	| modelObject aRPModelClass |
	
	aRPModelClass := self getModelForRouteSuffix: aRouteSuffix.
	[ modelObject := self database loadModelObject: (anID asNumber) from: aRPModelClass ] 
		on: Warning do: [^ self objectNotFound].
	self sendJson: (modelObject asJson)


]

{ #category : #'object handling' }
RPApplication >> writeObjectForPut: aRouteSuffix id: anID [
 
    | aRPModelClass object |
	
	aRPModelClass := self getModelForRouteSuffix: aRouteSuffix.
	object := self database loadModelObject: (anID asNumber) from: aRPModelClass.
	self parsedRequestContents ifNil: [^ self badRequest].
	object := aRPModelClass updateObject: object object with: self parsedRequestContents.
	self database update: object with: anID from: aRPModelClass.
	self writeObjectForGet: aRouteSuffix id: anID.
]

{ #category : #endpoint }
RPApplication >> writeObjectsAsHtmlForGet: aRPModelname [
 
      | aRPModelClass aHtmlString subStrings |
	aRPModelClass := self getRegisteredModel: aRPModelname.
	subStrings := OrderedCollection new.
	aHtmlString :=  '<b>Model:</b> ',
					aRPModelname,
					'<br><b>Metadata:</b> {"dataTypes":{',
					((aRPModelClass dataTypes associations collect: [:each |
						each asJsonString]) joinSeparatedBy: ','),
					'}}<br><br><b>Objects:</b>',
					(self getObjectsAsHtml: aRPModelname).
	self sendHtml: aHtmlString
]

{ #category : #endpoint }
RPApplication >> writeObjectsForGet: aRouteSuffix [
 
    | modelObjects string aRPModelClass |
	
	aRPModelClass := self getModelForRouteSuffix: aRouteSuffix.
    modelObjects := self database loadModelObjectsOf: aRPModelClass.  
	string := '{"data":[', ((modelObjects collect: [:each |
		each asJson]) joinSeparatedBy: ','), ']}'.
  	self sendJson: string


]

{ #category : #'object handling' }
RPApplication >> writeRemovedObjectForDelete: aRouteSuffix id: anID [
	
	| anRPModelClass |
	anRPModelClass := self getModelForRouteSuffix: aRouteSuffix.
	self database deleteObject: anID from: anRPModelClass
	
]
