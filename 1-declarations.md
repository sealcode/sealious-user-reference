## Declarations

Creating a Sealious application consists mainly of composing various declarations and letting Sealious take care of interactions between each one of them. Below are listed and describe all the declaration syntaxes you need to know in order to be a productive Selious developer.

**Note:** we'll be using the [jsig notation](https://github.com/jsigbiz/spec) for describing the various syntaxes.

### Generic types

```
type AcceptCallback: () => void;

type RejectCallback: (errorMessage: String) => void;

type Params: Object<String, Any>;
```


### FieldType


* Syntax

	<pre>
	<code>type FieldType: {
		name?: String,
		is_proper_value: (
			context: Context, 
			params: <a href="#generic-types">Params</a>, 
			new_value: Any,
			old_value?: Any 
		) =&gt; Promise<reject_reason?: String>,
		encode?: (
			context: Context, 
			params: <a href="#generic-types">Params</a>, 
			value_in_code: Any
		) =&gt; Promise&lt;encoded_value: Any&gt; & Any,
		decode?: (
			context: Context,
			params: <a href="#generic-types">Params</a>,
			value_in_db: Any
		) =&gt; Promise&lt;decoded_value: Any&gt; & Any,
		extends?: <a href="#fieldtype">FieldType</a>,
		has_index?: (params: Any) =&gt; false | index_type: String | Promise&lt;false | index_type: String&gt;
		format?: (
			context: Context,
			decoded_value: Any,
			format: String
		) =&gt; formatted_value: Any | Promise&lt;formatted_value: Any&gt;
	} | FieldTypeName
	</code>
	</pre>

* Explanation

	You can notice that there are two possible syntaxes (separated above with a `|` character). When creating a new FieldType, one has to describe it's behavior with the former notation. When only referencing an already described FieldType, one can use it's unique name.

	* `name`: **optional**. The name of the FieldType. Please note that this is the name of the *type* of a field, not a name of a *field*. Has to be unique amongst all other registred FieldTypes. When provided, the FieldType created by this declaration can be referenced with `FieldTypeName`.
	* `is_proper_value`: a function that takes a value (`new_value`) and decides whether that value is accepted. Can take `old_value` into consideration. `params` are parameters for the particular *field* that uses this field *type*. Should `return Promise.resolve()` to accept, and `return Promise.reject("Reason")` to reject.
	* `encode`: **optional**. Takes the value for a field from client's input and transforms it into something else. The result of calling that function for the client's input is what will be stored in the database.
	* `decode`: **optional**. A function reverse to `encode`. If declared, the value in the database will be run through that function before being returned to the client.
	* `extends`: **optional**. Must be a proper `FieldType` declaration. When specified, the field-type being declared will inherit behavior from the type it is extending. All specified methods will obscure the parent's methods. The unspecified will be inherited.
	* `has_index`: **optional**. Whether or not to instruct the Datastore to create an index on that field. In order to include the contents of the fields of this type in full-text-search, return "text" here.
	* `format`: **optional**. The user viewing a resource or a list of resources might specify a string for each of the fields in a collection that tells Sealious how the user wants the values to be displayed. That string is then passed to the `format` method of a given field type, if it exists. The method will be given the current context and the decoded value of the field. The method is supposed to format the `decoded_value` according to the specified `format`.

* Usage

	To create a new FieldType instance, call the `Sealious.FieldType` constructor.

	```javascript
	var my_field_type = new Sealious.FieldType({
		name: "text",
		//...
	});

	```

* Example

	<div class="wide">
	```javascript
	var Sealious = require("sealious");
	var Promise = require("bluebird");
	var Color = require("color");

	var field_type_color = new Sealious.FieldType({
		name: "color",
		is_proper_value: function(context, params, new_value){
			try {
				if (typeof (new_value) === "string"){
					Color(new_value.toLowerCase());
				} else {
					Color(new_value);
				}
			} catch (e){
				return Promise.reject("Value `" + new_value + "` could not be parsed as a color.");
			}
			return Promise.resolve();
		},
		encode: function(context, params, value_in_code){
			var color = Color(value_in_code);
			return color.hexString();
		}
	});
	```
	</div>

### Field

Fields are the most important part of a Collection. They describe it's behavior and structure.

* Syntax

	<pre>
	<code>type Field: {
		type: <a href="#fieldtype">FieldType</a>,
		name: String,
		required?: Boolean,
		params?: <a href="#generic-types">Params</a>
	}</code>
	</pre>

* Explanation

	* `type`: required. A FieldType declaration. It's more comfortable to use the "short" FieldType notation here (that is: just entering the name of the registered FieldType).
	* `name`: the name of the field. Has to be unique within the Collection.
	* `required`: **optional**. Defaults to `false`. If set to `true`, Sealious won't allow modifications of the resource that would result in removing a value from that field.
	* `params`: **optional**. A set of parameters that configure the behavior of the FieldType for that particular field.

* Usage

	Use it when describing a [Collection](#collection).

* Example

	```json
	{"name": "full-name", "type": "text", "required": true}
	```

### AccessStrategyType

AccessStrategyType describes a type of an access strategy that can be parametrized, instantiated, and, for example, assigned to a Collection.

* Syntax

	<pre>
	<code>type AccessStrategyType: {
		name?: String,
		checker_function: (
			context: Context,
			params: <a href="#generic-types">Params</a>,
			item?: Any
		) => Promise<error_message?: String> | Boolean,
		item_sensitive?: Boolean | (params: Any) => (Boolean | Promise)
	} | AccessStrategyName
	</code>
	</pre>

* Explanation

	* `name`: **optional**. If specified, the AccessStrategyType will be registered and will be accessible by it's name. Useful when the type is used many times.
	* `checker_function`: **required**. Takes a `context`, `params`, and decides whether or not to allow access. If access is denied, the function should return `Promise.reject("reason")`. The function can also return `true` and `false` to accept and deny access, respectively. If the access strategy is defined as `item_sensitive`, it will receive a third parameter - an object representing the item to which access is being decided.
	* `item_sensitive`: **optional**. Default to `false`. If set to `true` (or a resolving function, or a function that returns `true`), the `checker_function` will be provided with the item to which access is decided by the access strategy of this type. Loading the item data might by costly - that's why by default the `checker_function` will not receive it as argument.

* Usage

	To create a new AccessStrategyType, call the AccessStrategyType constructor:

	```javascript
	var new_access_str_type = new Sealious.AccessStrategyType({
		name: "only_on_tuesdays",
		//...
	});
	```

* Examples

	* declaring a new Access Strategy Type
	
		```javascript
		{
			name: "only_on_tuesdays",
			checker_function: function(context, params, item){
				var d = new Date(context.timestamp);
				var wd = d.getDay();
				if(wd == 2){
					return Promise.resolve();
				}else{
					return Promise.reject("Come back on a Tuesday!");
				}
			}
		}
		```

	* pointing at an already existing Strategy Type
	
		```javascript
		"only_on_tuesdays"
		```

### AccessStrategy

* Syntax

	<pre>
	<code>type AccessStrategy: <a href="#accessstrategytype-1">AccessStrategyType</a>
		| [type: <a href="#accessstrategytype-1">AccessStrategyType</a>, params:Any]
	</code>
	</pre>

* Explanation

	If the shorter notation is used (`AccessStrategyType`), you cannot specify any parameters to the AccessStrategyType assigned to that particular Access strategy. If you need to customize the behavior of the AccessStrategyType for that particular AccessStrategy, you have to use the longer syntax (`[type: AccessStrategyType, params:Any]`).

* Usage

	Currently this declaration is only being used when describing access strategies to resource actions in [Collection](#collection) declaration.

* Examples

	* `"only_on_tuesdays"`
	* `"logged_in"`
	* `["and", ["only_on_tuesdays", "logged_in"]]`

### ResourceActionName

* Syntax

	<div class="wide">
	```
	type ResourceActionName: "default" | "create" | "retrieve" | "update" | "delete"
	```
	</div>

* Usage

	It does not have it's own constructor, as it doesn't do anything by itself. It can be used when describing access strategies in [Collection](#collection) declaration.

### Collection

* Syntax

	<div class="wide">
	<pre>
	<code>type Collection: {
		name: String,
		fields: Array&lt;<a href="#field">Field</a>&gt;,
		access_strategy: <a href="#accessstrategy">AccessStrategy</a> | Object&lt;<a href="#resourceactionname">ResourceActionName</a>, <a href="#accessstrategy">AccessStrategy</a>&gt;
	}
	</code>
	</pre>
	</div>

* Explanation

	* `name`: **required**. The name of the resource-type.
	* `fields`: **required**. An array of [Fields](#field) declarations.
	* `access_strategy`: **required**. Describes what access strategies will be used for granting access to calling various resource actions. When a single [AccessStrategy](#accessstrategy) is specified, it will be used for all of the actions. If the `Object<ResourceActionName, AccessStrategy>` notation is being used, then each action can have a different access_strategy assigned. If an action does not have an AccessStrategy assigned, it will use the `default` one.

* Usage

	To create a new Collection, call the `Collection` constructor:

	```javascript
	var Person = new Sealious.Collection({
		name: "person",
		fields: //...
	});
	```

* Examples

	```javascript
	{
		name: "person",
		fields: [
			{name: "full-name", type: "text", required: true},
			{name: "age", type: "int"}
		],
		access_strategy: {
			default: "owner",
			view: "public",
			create: "logged_in"
		}   
	}
	```

