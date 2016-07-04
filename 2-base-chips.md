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
