## Base Chips

"Base chips" are chips that come bundled with Sealious and don't require separate installation. 

### Access Strategy Types

#### and

`and` access strategy type combines multiple access strategies into one. It resolves only if all of the access strategies provided in its `params` resolve, and it rejects otherwise. 

##### Sensitivity

It is sensitive to the `context` and/or `item`- depending on the strategies in `params`.

##### Params synopsis 

<pre>
<code>type and_params: Array&lt;<a href="#accessstrategy">AccessStrategy</a>&gt;</code>
</pre>

##### Example instance declaration

```javascript
["and", ["logged_in", "only_on_tuesdays"]]
```

#### logged_in

Resolves when the user_id in the provided context is set (not `null`), rejects otherwise.

*  Sensitivity

    It is only sensitive to the `context` argument.

*  Params synopsis

    This Access Strategy Type does not take any parameters.

*  Example instance declaration

    ```javascript
    "logged_in"
    ```

#### noone

Always rejects.

*  Sensitivity

    sensitive to nothing. Always rejects.

*  Params synopsis

    This Access Strategy Type does not take any parameters.

*  Example instance declaration

    ```javascript
    "noone"
    ```

#### not

Takes an Access Strategy as an argument. Resolves if the strategy in the `params` rejects. Rejects if the strategy in the params resolves.

*  Sensitivity

    It is sensitive to the `context` and/or `item`- depending on the strategy in `params`.

*  Params synopsis

    <pre>
    <code>type not_params: <a href="#accessstrategy">AccessStrategy</a></code>
    </pre>

*  Example instance declaration

    ```javascript
    ["not", "logged_in"]
    ```

    ```javascript
    ["not", ["and", ["logged_in", "owner"]]]
    ```

#### or

Similarly to the [and](#and) access strategy type, this strategy type takes a list of [AccessStrategies](#accessstrategy) as the only parameter. It resolves iff one of the strategies on the list resolves.

*  Sensitivity

    It is sensitive to the `context` and/or `item`- depending on the strategies in `params`.

*  Params synopsis 

    <pre>
    <code>type or_params: Array&lt;<a href="#accessstrategy">AccessStrategy</a>&gt;</code>
    </pre>

*  Example instance declaration

    ```javascript
    ["or", ["owner", "admin"]]
    ```

#### owner

Resolves only if the `user_id` in the provided context matches the `user_id` in the `created_context` attribute of the given `item`.

*  Sensitivity

    It is sensitive to the `context` *and* to the `item` arguments.

*  Params synopsis 

    This Access Strategy Type does not take any parameters.	

*  Example instance declaration

    ```javascript
    "owner"
    ```

#### public

Always resolves.

*  Sensitivity

    Sensitive to nothing. Resolves for any given arguments.

*  Params synopsis 

    This Access Strategy Type does not take any parameters.	

*  Example instance declaration

    ```javascript
    "public"
    ```
    
#### super

Resolves only if the provided Context is an instance of SuperContext.

*  Sensitivity

    It is sensitive to the `context` argument only.

*  Params synopsis 

    This Access Strategy Type does not take any parameters.	

*  Example instance declaration

    ```javascript
    "super"
    ```

#### themselves

Resolves only if the `user_id` in the `context` argument matches the `id` attribute of the `item` argument. 

Useful for creating access strategies for the `User` ResourceType. 

*  Sensitivity

    It is sensitive to the `context` *and* to the `item` arguments.

*  Params synopsis 

    This Access Strategy Type does not take any parameters.	

*  Example instance declaration

    ```javascript
    "themselves"
    ```

### Field Types

#### boolean

Stores a true/false value.

* **acceptable values**:
  
    This field type tries really hard to understand vast amount of ways one can want to represent a boolean value, including: 
	
	* a `boolean` value: `true`, `false`;
	* a string: `"1"`, `"0"`, `"true"`, `"false"`, `"True"`, `"False"`;
    * a number: `1`, `0`.

* **sensitivity**

	This field type is only sensitive to the provided `value`.

* **storage format**

	Whatever the input value, the value stored in the database is going to be a Boolean.

#### color

Stores a color value

* **acceptable values**:
  
    This field will accept any format that's acceptable in CSS, including:
	
	* rgb: `rgb(255, 255, 255)`;
	* hsl: `hsl(0, 0%, 100%)`;
    * hex: `#fffff`.

* **sensitivity**

	This field type is only sensitive to the provided `value`.

* **storage format**

	The colors are stored in the database as strings containing hex color representation.
	
#### context

Stores a context. Used internally to store the context of the last login of a particular user.

* **acceptable values**:

	This field will only accept objects that are an instance of `Context`
	
* **sensitivity**

	This field type is only sensitive to the provided `context`.	
	
* **storage format**:
  
    Values for this field type will be stored as an object.

#### date

Used for storing dates, without information on time of day. See also: [datetime](#datetime).


* **acceptable values**:

	Accepts all dates in ISO standard 8601, that is: `YYYY-MM-DD`.
	
	Examples: 
	
	* `"2016-07-04"`
	* `"1999-12-31"`

* **sensitivity**

	This field type is only sensitive to the provided `value`.

* **storage format**:

	The values are stored verbatim as strings
	
#### datetime

Stores timestamps in the form of milliseconds passed since the [Epoch](since UNIX Epoch). This time format was chosen to mitigate timezone issues.

* **acceptable values**:
  
    Any (positive or negative) Number value is accepted.
	
	Examples:
	
	* `1467645583744` represents `2016-07-04T15:19:43.744Z`
	* `0` represents `1970-01-01T00:00:00.000Z`
	* `-1467645583744` represents `1923-06-30T08:40:16.256Z`

* **sensitivity**

	This field type is only sensitive to the provided `value`.

* **storage format**

	Values for this field type are kept verbatim as numbers in the datastore.

#### email

Stores a proper email address.

* **acceptable values**:

    Accepts email addresses that match the following regular expression: 

	```regexp
	/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
	```
	
	Example: 
	
	* `john@example.com`

* **sensitivity**

	This field type is only sensitive to the provided `value`.

* **storage format**

	Values for this field type are kept verbatim as strings.

#### file

Stores a binary file. 

**Note**: the files are stored in the `uploaded_files` directory, located next to your app's `index.js` file.

* **acceptable values**
  
    This field accepts only objects that are an instance of `Sealious.File` as it's `value` parameter.
	
	Example: 
	
	```javascript
	var context = new Sealious.Context();
	var buffer = fs.readFile("photo.jpg");
	var file = new Sealious.File(context, "photo.jpg", buffer);
	```
	
* **sensitivity**

	This field-type's behavior depends only on the provided `value`s.
	
* **storage format**

	The uploaded files are stored in the `uploaded_files` directory, located next to your app's `index.js` file. The files have randomly generated names, and have no extension.

    In the datastore they are represented as entries taking the form of: 
	
	```json
	{
		"id": "the_random_id",
		"filename": "the_original_filename"
	}
	```
	
#### float

Stores any real number.

* **acceptable values**:

	Accepts any number. Interprets `.` as the decimal separator.

	Examples: 
	
	* `2`,
	* `3.141592654`,
	* `-35432432132124123`
	
* **sensitivity**

	This field type's behavior depends only on the provided `value`s.
	
* **storage format**

	The values are stored in the datastore as verbatim real numbers (floats).
	
#### hashed-text

Extends the [text](#text) field-type. Takes any text, and if it meets the criteria specified in the field's params, hashes it with the [RFC 2898](https://tools.ietf.org/html/rfc2898)-recommended PBKDF2 algorithm.

* **params synopsis**

	```
	type hashed_text_params: {
		required_digits?: Number,
		required_capitals?: Number, 
		hide_hash?: Boolean
	```
	
	* `required_digits`: **optional**. If specified, the `value` will not be accepted if it doesn't contain at least that many digits.
	* `required_capitals`: **optional**. If specified, the `value` will not be accepted if it doesn't contain at least that many capitals.
	* `hide_hash`: **optional**. If set to `true`, the hash value will be hidden (the value for the field will be `null`). Useful for password fields.
	
	Also, all of the params from the [text](#text) field-type apply.

* **acceptable values**

	Any string that matches the requirements specified in the `params`.

* **storage format**

	The values are stored as a string containing the PBKDF2 hash of the input. There's no practical way to get back the original input.
	
#### int

Accepts only integer numbers (positive or negative).

* **sensitivity**

	Sensitive only to the provided `value`.
	
* **params synopsis**

	This field type does not take any params.
	
* **acceptable values**

	Any integer number, or a string representation of an integer number.

	Examples:
	
	* `1`, `11`, `123`
	* `-2`, `0`;
	
	Will not accept non-integer numbers.
	
* **storage format**

	The values are stored verbatim as Numbers in the datastore.
	
#### single_reference

Can reference any other resource.

* **params synopsis**

	```javascript
	type single_reference_params: {
		resource_type: ResourceTypeName
	}
	```
	
	* `resource_type`: **required**. Only references to resources of that particular type will be accepted.
	
* **sensitivity**

	The behavior of this resource type depends on `context`, `params` and `value`.
	
* **acceptable values**

	Accepts only IDs of existing resources of the type specified in the `params`.
	
	Example: `qytmp7waxm`
	
* **storage format**

	The input values are stored as strings containing the referenced resource's ID.
	
#### text

Used for storing text. 

* **params synopsis**

	```
	type text_params: {
		max_length?: Number,
		min_length?: Number,
		include_in_search?: Boolean,
		strip_html?: Boolean
	}
	```
	
	Explanation: 
	
	* `max_length`: **optional**. If specified, all text with char count higher than that will be rejected with an appropriate error message.
	* `min_length`: **optional**. If specified, all text with char count lower than that will be rejected with an appropriate error message.
	* `include_in_search`: **optional**. Defaults to `false`. If set to `true`, the datastore will be instructed to create a full-text index on contents of the field.
	* `strip_html`: **optional**. Defaults to `false`. If set to `true`, all of the html tags contained in user input will be irreversibly removed.
	
* **sensitivity**

	The behavior of this field type depends on provided `value` and `params`.
	
* **acceptable values**

	Will accept all strings that meets the criteria contained in `params`.
	
* **storage format**

	The text will be stored as a string in the datastore. In certain cases the stored text might be modified before saving (e.G. when HTML sanitization is enabled)
	
#### username

Extends the [text](#text) field-type. 

* **acceptable values**

	Accepts only strings that are not already used as a username, and which are neither of: `"me"`, `"myself"`, `"current"`.

* **Sensitivity**

	Things that can influence the behavior of fields of this type: 
	
	* `value`
	* the state of the datastore (existing usernames)
	* `params`

* **params synopsis**

	See params for the [text](#text) field type.
	
* **storage format**

	See: [text](#text) field type.
	
### Resource Types

#### User

The default field in the User resource type are:

* username (type: [username](#username)), required;
* email (type: [email](#email))
* password (type: [hashed-text](#hashed-text)), required. Min-length: 6.
* last\_login_context (type: [context](#context))

By default, anyone can register (create a user), but only the user itself can edit or delete the account. 


