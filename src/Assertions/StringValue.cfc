component displayname="StringValue" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="discriminator" type="boolean" getter="false" setter="false";

    private StringValue function Init(required bool discriminator) output = false {
        variables.discriminator = arguments.discriminator;
        return this;
    }

    public static StringValue function Is() output = false {
        return new StringValue(false);
    }

    public static StringValue function IsNot() output = false {
        return new StringValue(true);
    }

    public StringConstraint function Nothing() output = false {

        var predicate = (required string value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                return;
            }

            if (variables.discriminator == true && isNull(arguments.value)) {
                throw("Expected string to not be nothing but it is null", Assert::GetAssertionType());
            }

            var stringIsEmpty = trim(arguments.value).len() == 0;

            if (stringIsEmpty && variables.discriminator == true) {
                throw("Expected string to not be nothing but it is empty or consists entirely of whitespace", Assert::GetAssertionType());
            }

            if (!stringIsEmpty && variables.discriminator == false) {
                throw(
                    "Expected string to be nothing but it has a value with length #arguments.value.len()#: #arguments.value#",
                    Assert::GetAssertionType()
                );
            }
        }

        return new StringConstraint(predicate);
    }

    public StringConstraint function EqualTo(required string expectedValue) output = false {

        var outerArgs = arguments;
        var predicate = (required string value) => {

            if (variables.discriminator == true && isNull(arguments.value)) {
                throw(
                    "Expected string to equal another string but it is null:#newLine()#Expected: #arguments.value#",
                    Assert::GetAssertionType()
                );
            }

            var valuesAreEqual = outerArgs.expectedValue == arguments.value;

            if (!valuesAreEqual && variables.discriminator == false) {
                throw(
                    "Expected string to equal another string but they differ:
                    #newLine()#Expected (length: #len(outerArgs.expectedValue)#): #outerArgs.expectedValue#
                    #newLine()#Actual (length: #len(arguments.value)#): #arguments.value#"
                    ,
                    Assert::GetAssertionType()
                );
            }

            if (valuesAreEqual && variables.discriminator == true) {
                throw(
                    "Expected string to not equal another string:
                    #newLine()#Expected (length: #len(outerArgs.expectedValue)#): #outerArgs.expectedValue#
                    #newLine()#Actual (length: #len(arguments.value)#): #arguments.value#"
                    ,
                    Assert::GetAssertionType()
                );
            }
        };

        return new StringConstraint(predicate);
    }

    public StringConstraint function Containing(required string expectedValue) output = false {

        var outerArgs = arguments;
        var predicate = (required string value) => {

            if (variables.discriminator == true && isNull(arguments.value)) {
                throw(
                    "Expected string to contain another string but it is null:#newLine()#Expected: #arguments.value#",
                    Assert::GetAssertionType()
                );
            }

            var valueContainsExpected = find(outerArgs.expectedValue, arguments.value, 0) > 0;

            if (!valueContainsExpected && variables.discriminator == false) {
                throw(
                    "Expected string to contain another string but it does not:
                    #newLine()#Expected (length: #len(outerArgs.expectedValue)#): #outerArgs.expectedValue#
                    #newLine()#Actual (length: #len(arguments.value)#): #arguments.value#"
                    ,
                    Assert::GetAssertionType()
                );
            }

            if (valueContainsExpected && variables.discriminator == true) {
                throw(
                    "Expected string to not contain another string:
                    #newLine()#Expected (length: #len(outerArgs.expectedValue)#): #outerArgs.expectedValue#
                    #newLine()#Actual (length: #len(arguments.value)#): #arguments.value#"
                    ,
                    Assert::GetAssertionType()
                );
            }
        };

        return new StringConstraint(predicate);
    }

    public StringConstraint function StartingWith(required string expectedValue) output = false {

        var outerArgs = arguments;
        var predicate = (required string value) => {

            if (variables.discriminator == true && isNull(arguments.value)) {
                throw(
                    "Expected string to start with another string but it is null:#newLine()#Expected: #arguments.value#",
                    Assert::GetAssertionType()
                );
            }

            var valueStartsWithExpected = find(outerArgs.expectedValue, arguments.value, 0) == 1;

            if (!valueStartsWithExpected && variables.discriminator == false) {
                throw(
                    "Expected string to start with another string but it does not:
                    #newLine()#Expected (length: #len(outerArgs.expectedValue)#): #outerArgs.expectedValue#
                    #newLine()#Actual (length: #len(arguments.value)#): #arguments.value#"
                    ,
                    Assert::GetAssertionType()
                );
            }

            if (valueStartsWithExpected && variables.discriminator == true) {
                throw(
                    "Expected string to not start with another string:
                    #newLine()#Expected (length: #len(outerArgs.expectedValue)#): #outerArgs.expectedValue#
                    #newLine()#Actual (length: #len(arguments.value)#): #arguments.value#"
                    ,
                    Assert::GetAssertionType()
                );
            }
        };

        return new StringConstraint(predicate);
    }

    public StringConstraint function EndingWith(required string expectedValue) output = false {

        var outerArgs = arguments;
        var predicate = (required string value) => {

            if (variables.discriminator == true && isNull(arguments.value)) {
                throw(
                    "Expected string to end with another string but it is null:#newLine()#Expected: #arguments.value#",
                    Assert::GetAssertionType()
                );
            }

            var valueEndsWithExpected = right(arguments.value, len(outerArgs.expectedValue)) == outerArgs.expectedValue;

            if (!valueEndsWithExpected && variables.discriminator == false) {
                throw(
                    "Expected string to end with another string but it does not:
                    #newLine()#Expected (length: #len(outerArgs.expectedValue)#): #outerArgs.expectedValue#
                    #newLine()#Actual (length: #len(arguments.value)#): #arguments.value#"
                    ,
                    Assert::GetAssertionType()
                );
            }

            if (valueEndsWithExpected && variables.discriminator == true) {
                throw(
                    "Expected string to not end with another string:
                    #newLine()#Expected (length: #len(outerArgs.expectedValue)#): #outerArgs.expectedValue#
                    #newLine()#Actual (length: #len(arguments.value)#): #arguments.value#"
                    ,
                    Assert::GetAssertionType()
                );
            }
        };

        return new StringConstraint(predicate);
    }
}