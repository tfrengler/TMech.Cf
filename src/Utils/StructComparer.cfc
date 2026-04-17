/**
 * @hint Wraps a struct and allows you to compare it to other structs.
 */
component displayname="StructComparer" modifier="final" output="false" accessors="false" persistent="true" {

    // PRIVATE
    // Array of structs. Layout: { 1: first struct, 2: second struct }
    property name="previouslyComparedStructs" type="array" setter="false" getter="false";
    property name="maxDepth" type="numeric" setter="false" getter="false";
    property name="currentDepth" type="numeric" setter="false" getter="false";
    property name="typeOf" type="function" setter="false" getter="false";
    property name="trace" type="boolean" setter="false" getter="false";
    property name="strictEqualityCheck" type="boolean" setter="false" getter="false";
    property name="caseSensitiveKeyComparison" type="boolean" setter="false" getter="false";

    // PUBLIC
    property name="traceLog" type="array" setter="false" getter="true";

    public StructComparer function Init() output = false {

        variables.previouslyComparedStructs = [];
        variables.maxDepth = 32;
        variables.currentDepth = 1;
        variables.typeOf = Utils.ObjectUtils::TypeOf;
        variables.trace = false;
        variables.traceLog = [];
        variables.strictEqualityCheck = true;
        variables.caseSensitiveKeyComparison = true;

        return this;
    }

    // PUBLIC

    /**
     * @hint Enables trace logging. The log can can be retrieved by calling getTraceLog().
     * NOTE: The log is cleared and repopulated every time IsSimilarTo() is called.
     */
    public StructComparer function WithTracing() output = false {
        variables.trace = true;
        return this;
    }

    /**
     * @hint Sets the max depth allowed when recursing into nested arrays and structs.
     *
     * @depth The maximum depth. Cannot be less than 1. If that is the case then 32 is used instead.
     */
    public StructComparer function WithMaxDepth(required numeric depth) output = false {
        if (arguments.depth < 1) {
            arguments.depth = 32;
        }

        variables.maxDepth = arguments.depth;
        return this;
    }

    /**
     * @hint Normal comparison on simple values is strict, meaning they are checked on both type and value.
     * Calling this function disables the type check and allows for CFML to do implicit coercion first.
     * Example: "42" == 42 or 1 == true becomes true, where normally it would be false.
     */
    public StructComparer function AllowCoercionWhenComparing() output = false {
        variables.strictEqualityCheck = false;
        return this;
    }

    public StructComparer function WithCaseInsensitiveKeyComparison() output = false {
        variables.caseSensitiveKeyComparison = false;
        return this;
    }

    public boolean function AreSimilar(required struct first, required struct second) output = false {
        variables.traceLog = [];
        variables.previouslyComparedStructs = [];
        variables.currentDepth = 1;

        variables.AddTrace("Config: Strict equality check? #variables.strictEqualityCheck#. Case sensitive key comparison? #variables.caseSensitiveKeyComparison#");

        var returnData = variables.CompareStructs(arguments.first, arguments.second);
        variables.AddTrace("Struct are #returnData ? "" : "NOT "#similar");

        return returnData;
    }

    // PRIVATE

    private void function AddTrace(required string message) output = false {
        if (!variables.trace) return;
        variables.traceLog.append("#arguments.message# (depth: #variables.currentDepth#)");
    }

    private boolean function CompareStructs(required struct first, required struct second) output = false {

        if (arguments.first === arguments.second) {
            variables.addTrace("Structs refer to the same instance, skip comparison");
            return true;
        }

        variables.previouslyComparedStructs.append({1: arguments.first, 2: arguments.second});

        var keysOfFirst = structKeyArray(arguments.first);
        var keysOfSecond = structKeyArray(arguments.second);

        if (keysOfFirst.len() != keysOfSecond.len()) {
            variables.addTrace("Structs have different amount of keys (first: #keysOfFirst.len()# vs second: #keysOfSecond.len()#)");
            return false;
        }

        for(var key in keysOfFirst) {

            var keyFoundInOther = variables.caseSensitiveKeyComparison
                ? arrayFind(keysOfSecond, key) > 0
                : arrayFindNoCase(keysOfSecond, key) > 0;

            if (!keyFoundInOther) {
                variables.addTrace("Second struct does not contain key from first struct: #key# (keys of second: #arrayToList(keysOfSecond)#)");
                return false;
            }
        }

        for(var item in keysOfFirst) {

            var itemFirst = arguments.first[item];
            var itemSecond = arguments.second[item];

            var typeOfFirst = typeOf(itemFirst);
            var typeOfSecond = typeOf(itemSecond);

            variables.addTrace("Comparing values in key '#item#'");
            var keysEqualInValue = variables.CompareValues(itemFirst, itemSecond, typeOfFirst, typeOfSecond);

            if (!keysEqualInValue) {
                return false;
            }
        }

        return true;
    }

    private boolean function RecurseOnStruct(required any first, required any second) output = false {

        variables.CheckRecursionDepth();

        var args = arguments;

        var itemsAlreadyCompared = arraySome(variables.previouslyComparedStructs, (required struct st) => {
            return (arguments.st.1 === args.first && arguments.st.2 === args.second) ||
                   (arguments.st.1 === args.second && arguments.st.2 === args.first)
        });

        if (itemsAlreadyCompared) {
            variables.addTrace("Structs have already been compared");
            return false;
        }

        variables.addTrace("Recursing into struct");

        variables.currentDepth++;
        var returnData = compareStructs(arguments.first, arguments.second);
        variables.currentDepth--;

        return returnData;
    }

    private boolean function SequenceCompareArrays(required array first, required array second) output = false {

        variables.CheckRecursionDepth();

        if (arguments.first.len() != arguments.second.len()) {
            variables.addTrace("Arrays do not have the same length (first: #arguments.first.len()# vs second: #arguments.second.len()#)");
            return false;
        }

        for(var index = 1; index <= arguments.first.len(); index++) {

            var itemFirst = arguments.first[index];
            var itemSecond = arguments.second[index];

            variables.AddTrace("Comparing values in index #index#");
            if (!compareValues(itemFirst, itemSecond, variables.typeof(itemFirst), variables.typeof(itemSecond)))
            {
                return false;
            }
        }

        variables.AddTrace("Arrays are equal in their values");
        return true;
    }

    private boolean function CompareValues(
        required any first,
        required any second,
        required string typeOfFirst,
        required string typeOfSecond) output = false
    {
        // Can't do value or reference comparison here
        if (arguments.typeOfFirst == "null" && typeOfSecond == "null") {
            variables.addTrace("Values are both null");
            return true;
        }

        var isValueSimple = isSimpleValue(arguments.first);
        var typesMatch = arguments.typeOfFirst == typeOfSecond;
        // If types don't match then:
        // - When we DO strict equality checks on simple values it's a fail
        // - When we DON'T do strict equality checks on simple values it's a pass
        // - Regardless of strict quality checks on complex values it's a fail
        var typeMatchFailed = !typesMatch && (
            (variables.strictEqualityCheck && isValueSimple) ||
            !isValueSimple
        );

        if (typeMatchFailed)
        {
            variables.addTrace("Values are not the same type (Expected: #arguments.typeOfFirst# vs actual: #arguments.typeOfSecond#)");
            return false;
        }

        if (isValueSimple) {

            var areValuesEqual = variables.strictEqualityCheck
                ? arguments.first !== arguments.second
                : arguments.first != arguments.second;

            if (areValuesEqual) {
                variables.addTrace("Values are NOT equal. Expected: #arguments.first# (#arguments.typeOfFirst#) vs actual: #arguments.second# (#arguments.typeOfSecond#)");
                return false;
            }

            variables.addTrace("Values are equal. Expected: #arguments.first# (#arguments.typeOfFirst#) and found: #arguments.second# (#arguments.typeOfSecond#)");
            return true;
        }

        if (arguments.typeOfFirst == "struct") {
            return recurseOnStruct(arguments.first, arguments.second);
        }

        if (arguments.typeOfFirst == "array") {
            variables.addTrace("Found array. Comparing values in sequence");

            variables.currentDepth++;
            var arraysEqual = variables.SequenceCompareArrays(arguments.first, arguments.second);
            variables.currentDepth--;

            return arraysEqual;
        }

        variables.addTrace("Values are complex, skipping equality check (type: #arguments.typeOfFirst#)");
        return true;
    }

    private void function CheckRecursionDepth() output = false {
        if (variables.currentDepth > variables.maxDepth) {
            throw("Reached max recursion depth of nested structs (#variables.maxDepth#)", "StructComparer.MaxDepthReached");
        }
    }
}
