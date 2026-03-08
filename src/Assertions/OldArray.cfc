component displayname="ArrayValue" modifier="final" output="false" accessors="false" persistent="true"
{
    property name="discriminator" type="boolean" getter="false" setter="false";

    private ArrayValue function Init(required bool discriminator) output = false {
        variables.discriminator = arguments.discriminator;
        return this;
    }

    public static ArrayValue function Is() output = false {
        return new ArrayValue(false);
    }

    public static ArrayValue function IsNot() output = false {
        return new ArrayValue(true);
    }

    public static ArrayValue function Does() output = false {
        return new ArrayValue(false);
    }

    public static ArrayValue function DoesNot() output = false {
        return new ArrayValue(true);
    }

    private void function ThrowHelper(required string message) output = false {
        throw(
            message = arguments.message,
            detail = "",
            type = Assert::GetAssertionType()
        );
    }

    /**
    * @hint Constraint that asserts whether an array is empty or not (contains any items)
    */
    public ArrayConstraint function Empty() output = false {

        var predicate = (required array value) => {

            if (IsNull(arguments.value)) {
                throw("Array is null", Assert::GetAssertionType());
            }

            if (!variables.discriminator && arguments.value.len() > 0) {
                throw("Expected array to be empty but it contains #arguments.value.len()# items", Assert::GetAssertionType());
            }

            if (variables.discriminator && arguments.value.len() == 0) {
                throw("Expected array to not be empty but it contains #arguments.value.len()# items", Assert::GetAssertionType());
            }
        }

        return new ArrayConstraint(predicate);
    }

    /**
     * @hint Constraint that asserts that at least one item in the array satisfies a condition.
     * @satisfierFunction Function that is applied to each array item. Expected to return true if the item satisfies a condition or false otherwise.
     */
    public ArrayConstraint function SatisfiedByAny(required function satisfierFunction) output = false {

        var capturedSatisfierFunction = arguments.satisfierFunction;

        if (!(isClosure(capturedSatisfierFunction) || isCustomFunction(capturedSatisfierFunction))) {
            throw(message="Expected argument 'capturedSatisfierFunction' to be a function or closure but it was not");
        }

        var predicate = (required array value) => {

            if (IsNull(arguments.value)) {
                throw("Array is null", Assert::GetAssertionType());
            }

            var foundAny = arraySome(arguments.value, capturedSatisfierFunction)

            if (!variables.discriminator && foundAny == 0) {
                throw("Expected array to contain an item satisfying the function but it does not", Assert::GetAssertionType());
            }

            if (variables.discriminator && foundAny > 0) {
                throw("Expected array to not contain an item satisfying the function but it does", Assert::GetAssertionType());
            }
        }

        return new ArrayConstraint(predicate);
    }

    /**
     * @hint Constraint that asserts that at all items in the array satisfies a condition.
     * @satisfierFunction Function that is applied to each array item. Expected to return true if the item satisfies a condition or false otherwise.
     */
    public ArrayConstraint function SatisfiedByAll(required function satisfierFunction) output = false {

        var capturedSatisfierFunction = arguments.satisfierFunction;

        if (!(isClosure(capturedSatisfierFunction) || isCustomFunction(capturedSatisfierFunction))) {
            throw(message="Expected argument 'capturedSatisfierFunction' to be a function or closure but it was not");
        }

        var predicate = (required array value) => {

            if (IsNull(arguments.value)) {
                throw("Array is null", Assert::GetAssertionType());
            }

            var anySatisfied = arrayEvery(arguments.value, capturedSatisfierFunction)

            if (!variables.discriminator && !anySatisfied) {
                throw("Expected array to contain only items satisfying the function but it does not", Assert::GetAssertionType());
            }

            if (variables.discriminator && anySatisfied) {
                throw("Expected array to not contain only items satisfying the function but it does", Assert::GetAssertionType());
            }
        }

        return new ArrayConstraint(predicate);
    }
}