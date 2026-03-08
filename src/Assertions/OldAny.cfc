component displayname="AnyValue" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="discriminator" type="boolean" getter="false" setter="false";

    private AnyValue function Init(required bool discriminator) output = false {
        variables.discriminator = arguments.discriminator;
        return this;
    }

    public static AnyValue function Is() output = false {
        return new AnyValue(false);
    }

    public static AnyValue function IsNot() output = false {
        return new AnyValue(true);
    }

    private void function ThrowHelper(required string message, required string expected, required string actual) output = false {
        throw(
            message = arguments.message,
            detail = "
                EXPECTED TYPE: #arguments.expected#
                ACTUAL TYPE  :  #arguments.actual#
            ",
            type = Assert::GetAssertionType()
        );
    }

    public AnyConstraint function String() output = false {

        var predicate = (required any value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                throw(message="Expected value to be a string but it is null", type=Assert::GetAssertionType());
            }

            if (variables.discriminator == true && isNull(arguments.value)) {
                return;
            }

            var actualType = arguments.value.getClass().getName();
            var valueIsType = actualType == "java.lang.String";

            if (!valueIsType && variables.discriminator == false) {
                ThrowHelper(
                    message="Expected value to be a string but it is not",
                    expected="java.lang.String",
                    actual=actualType
                );
            }

            if (valueIsType && variables.discriminator == true) {
                ThrowHelper(
                    message="Expected value to not be a string but it is",
                    expected="java.lang.String",
                    actual=actualType
                );
            }
        };

        return new AnyConstraint(predicate);
    }

    public AnyConstraint function Numeric() output = false {

        var predicate = (required any value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                throw(message="Expected value to be a number but it is null", type=Assert::GetAssertionType());
            }

            if (variables.discriminator == true && isNull(arguments.value)) {
                return;
            }

            var expectedValueOutputString = "java.lang.Long, java.lang.Double or java.math.BigDecimal"
            var actualType = arguments.value.getClass().getName();
            var valueIsType = (
                actualType == "java.lang.Long" ||
                actualType == "java.lang.Double" ||
                actualType == "java.math.BigDecimal");

            if (!valueIsType && variables.discriminator == false) {
                ThrowHelper(
                    "Expected value to be a number but it is not",
                    expectedValueOutputString,
                    actualType
                );
            }

            if (valueIsType && variables.discriminator == true) {
                ThrowHelper(
                    "Expected value to not be a number but it is",
                    expectedValueOutputString,
                    actualType
                );
            }
        };

        return new AnyConstraint(predicate);
    }

    public AnyConstraint function Array() output = false {

        var predicate = (required any value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                throw(message="Expected value to be an array but it is null", type=Assert::GetAssertionType());
            }

            if (variables.discriminator == true && isNull(arguments.value)) {
                return;
            }

            var actualType = arguments.value.getClass().getName();
            var valueIsType = actualType == "lucee.runtime.type.ArrayImpl";

            if (!valueIsType && variables.discriminator == false) {
                ThrowHelper(
                    "Expected value to be an array but it is not",
                    "lucee.runtime.type.ArrayImpl",
                    actualType
                );
            }

            if (valueIsType && variables.discriminator == true) {
                ThrowHelper(
                    "Expected value to not be an array but it is",
                    "lucee.runtime.type.ArrayImpl",
                    actualType
                );
            }
        };

        return new AnyConstraint(predicate);
    }

    public AnyConstraint function Struct() output = false {

        var predicate = (required any value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                throw(message="Expected value to be an struct but it is null", type=Assert::GetAssertionType());
            }

            if (variables.discriminator == true && isNull(arguments.value)) {
                return;
            }

            var actualType = arguments.value.getClass().getName();
            var valueIsType = actualType == "lucee.runtime.type.StructImpl";

            if (!valueIsType && variables.discriminator == false) {
                ThrowHelper(
                    "Expected value to be an struct but it is not",
                    "lucee.runtime.type.StructImpl",
                    actualType
                );
            }

            if (valueIsType && variables.discriminator == true) {
                ThrowHelper(
                    "Expected value to not be an struct but it is",
                    "lucee.runtime.type.StructImpl",
                    actualType
                );
            }
        };

        return new AnyConstraint(predicate);
    }

    public AnyConstraint function Boolean() output = false {

        var predicate = (required any value) => {

            if (variables.discriminator == false && isNull(arguments.value)) {
                throw(message="Expected value to be a boolean but it is null", type=Assert::GetAssertionType());
            }

            if (variables.discriminator == true && isNull(arguments.value)) {
                return;
            }

            var actualType = arguments.value.getClass().getName();
            var valueIsType = actualType == "java.lang.Boolean";

            if (!valueIsType && variables.discriminator == false) {
                ThrowHelper(
                    "Expected value to be a boolean but it is not",
                    "java.lang.Boolean",
                    actualType
                );
            }

            if (valueIsType && variables.discriminator == true) {
                ThrowHelper(
                    "Expected value to not be a boolean but it is",
                    "java.lang.Boolean",
                    actualType
                );
            }
        };

        return new AnyConstraint(predicate);
    }

    public AnyConstraint function Throwing(string expectedType = "") output = false {
        // Need to get a reference here otherwise the predicate can't capture it
        var localExpectedType = arguments.expectedType;
        var predicate = (required any value) => {

            if (isNull(arguments.value) || !(isClosure(arguments.value) || isCustomFunction(arguments.value))) {
                throw(message="Error asserting whether value throws or not because it is not a function or a closure", type=Assert::GetAssertionType());
            }

            var threw = false;
            var exception = 0;

            try {
                arguments.value();
            }
            catch (any error) {
                threw = true;
                exception = error;
            }

            if (discriminator == false) {
                if (!threw) {
                    throw(message="Expected value to throw but it did not", type=Assert::GetAssertionType());
                }

                if (localExpectedType.len() > 0 && exception.type != localExpectedType) {
                    throw(
                        message="Expected value to throw an exception of type #localExpectedType# but it was #exception.type#",
                        detail=exception.message,
                        type=Assert::GetAssertionType()
                    );
                }
            }

            if (discriminator == true && threw) {
                throw(
                    message="Expected value to not throw but it did",
                    detail = "
                        EXCEPTION MESSAGE: #exception.message#
                        EXCEPTION DETAIL : #exception.detail#
                    ",
                    type=Assert::GetAssertionType()
                );
            }
        };

        return new AnyConstraint(predicate);
    }
}