component displayname="Constraint" modifier="final" output="false" accessors="false" persistent="true" {

    property name="negated"         type="boolean"  getter="true" setter="false";
    property name="testFn"          type="function" getter="true" setter="false";
    property name="failMessage"     type="string"   getter="true" setter="false";
    property name="exceptionType"   type="string"   getter="true" setter="false";

    public static string function GetBaseAssertionType() {
        return "TMech.AssertionFailed"
    }

    public Constraint function Init(
        required boolean negated,
        required function testFn,
        required string failMessage,
        required string exceptionType
    ) output = false
    {
        variables.negated = arguments.negated;
        variables.testFn = arguments.testFn;
        variables.failMessage = arguments.failMessage;
        variables.exceptionType = arguments.exceptionType;

        return this;
    }

    public void function Apply(required any value) output = false {

        if (isNull(arguments.value)) {
            throw(
                message = "Value is null",
                type    = "#GetBaseAssertionType()#.#variables.exceptionType#"
            );
        }

        var passed = variables.testFn(value);

        if (variables.negated) {
            passed = !passed;
        }

        if (!passed) {
            throw(
                message = variables.failMessage,
                detail  = isSimpleValue(arguments.value) ? "Actual value: #arguments.value#" : nullValue(),
                type    = "#GetBaseAssertionType()#.#variables.exceptionType#"
            );
        }
    }
}
