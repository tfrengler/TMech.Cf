component displayname="Constraint" modifier="final" output="false" accessors="false" persistent="true" {

    property name="negated"     type="boolean"  getter="true" setter="false";
    property name="testFn"      type="function" getter="true" setter="false";
    property name="failMessage" type="string"   getter="true" setter="false";

    public Constraint function init(
        required boolean negated,
        required function testFn,
        required string failMessage
    ) {
        variables.negated = arguments.negated;
        variables.testFn = arguments.testFn;
        variables.failMessage = arguments.failMessage;

        return this;
    }

    public void function Apply(required any value) {

        if (isNull(arguments.value)) {
            throw(
                message = "Value is null",
                type    = Assert::GetAssertionType()
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
                type    = Assert::GetAssertionType()
            );
        }
    }
}
