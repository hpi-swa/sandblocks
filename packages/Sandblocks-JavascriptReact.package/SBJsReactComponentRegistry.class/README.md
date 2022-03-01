An SBJsReactComponentRegistry is an object that saves SBJsReactJSXElementReplacements associated with a name and a category much like a small key-value database. 
There should only be single running instance at a time to ensure that all access the same registry. The running instance is saved via the DefaultRegistry class variable. 
On the instance side, the SBJsComponentUsageReplacements are stored in the nested componentRegistry dictionary and can be accessed via convenience functions like componentRegistryDo:.
The registered components in the DefaultRegistry are automatically added to the SBJsReactPalette and are used for suggestions in JSX context. For the suggestions look into SBJavascript>>insertSuggestionsFor:.

The convenience functions are mainly unused and exist for programmers to interact with the SBJsComponentUsageReplacements instance. Thus they extend the SBJsReactPalette and the JSX suggestions on their own.

Instance Variables
	componentRegistry:		<Dictionary>

componentRegistry
	- A Dictionary storing the SBJsReactJSXElementReplacements together with their names by category. The structure is that of a nested Dictionary.


Class Variables
	DefaultRegistry:		<SBJsReactComponentRegistry>
			
DefaultRegistry
	- The default instance of the SBJsReactComponentRegistry which should be used all the time.
	

Interesting points where to start:
- The class method resetDefaultRegistry replaces the old default registry with a new one and therefore effectively clears the registry.
- The methode addComponent:withName:inCategory: is used by the SBJsComponentReplacement to add created SBJsReactJSXElementReplacements to the registry.
- Additionally, the registry offeres convinience functions to access all entries, only specific categories and even methods to delete entries. The methods for deleting all start with remove and are in category "removing".