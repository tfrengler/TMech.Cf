<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Number assert tests</title>
    <style>
        body {
            margin-left: 20%;
            margin-right: 20%;
        }
    </style>
</head>
<body>

<cfoutput>
    <cfif !structKeyExists(FORM, "doTest") >
        <form action="" method="POST">
            <input name="doTest" type="hidden" value="true" />
            <button type="submit">EXECUTE TESTS</button>
            <cfabort/>
        </form>
    </cfif>
</cfoutput>

<cfscript>
    Tester = new TestRunner("Assert::ThatNumber, NumberConstraint.cfc and NumberValue.cfc");

    Tester.BeginTests("EqualTo()");

        Tester.RunTest("NumberValue::Is().EqualTo(2) => 4 - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatNumber(2, Assertions.NumberValue::Is().EqualTo(4));
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("NumberValue::IsNot().EqualTo(4) => 4 - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatNumber(4, Assertions.NumberValue::IsNot().EqualTo(4));
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("NumberValue::Is().EqualTo(4) => 4 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatNumber(4, Assertions.NumberValue::Is().EqualTo(4));
            });
        });

        Tester.RunTest("NumberValue::IsNot().EqualTo(2) => 4 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatNumber(2, Assertions.NumberValue::IsNot().EqualTo(4));
            });
        });

    Tester.EndTests();

    Tester.BeginTests("Zero()");

        Tester.RunTest("NumberValue::Is().Zero() => 4 - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatNumber(4, Assertions.NumberValue::Is().Zero());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("NumberValue::IsNot().Zero() => 0 - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatNumber(0, Assertions.NumberValue::IsNot().Zero());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("NumberValue::Is().Zero() => 0 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatNumber(0, Assertions.NumberValue::Is().Zero());
            });
        });

        Tester.RunTest("NumberValue::IsNot().Zero() => 4 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatNumber(4, Assertions.NumberValue::IsNot().Zero());
            });
        });

    Tester.EndTests();

    Tester.BeginTests("LessThanOrEqualToZero()");

        Tester.RunTest("NumberValue::Is().LessThanOrEqualToZero() => 1 - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatNumber(1, Assertions.NumberValue::Is().LessThanOrEqualToZero());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("NumberValue::IsNot().LessThanOrEqualToZero() => 0 and -1 - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatNumber(0, Assertions.NumberValue::IsNot().LessThanOrEqualToZero());
            }, Assertions.Assert::GetAssertionType());

            Assert::Throws(() => {
                Assertions.Assert::ThatNumber(-1, Assertions.NumberValue::IsNot().LessThanOrEqualToZero());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("NumberValue::Is().LessThanOrEqualToZero() => 0 and -1 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatNumber(0, Assertions.NumberValue::Is().LessThanOrEqualToZero());
            });

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatNumber(-1, Assertions.NumberValue::Is().LessThanOrEqualToZero());
            });
        });

        Tester.RunTest("NumberValue::IsNot().LessThanOrEqualToZero() => 1 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatNumber(1, Assertions.NumberValue::IsNot().LessThanOrEqualToZero());
            });
        });

    Tester.EndTests();

    Tester.BeginTests("LessThan()");

        Tester.RunTest("NumberValue::Is().LessThan(2) => 1 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatNumber(1, Assertions.NumberValue::Is().LessThan(2));
            });
        });

        Tester.RunTest("NumberValue::Is().LessThan(2) => 3 - should throw", () => {

            var errorMessage = Assert::Throws(() => {
                    Assertions.Assert::ThatNumber(3, Assertions.NumberValue::Is().LessThan(2));
                },
                Assertions.Assert::GetAssertionType()
            );

            if (errorMessage != "Expected value to be less than 2 but it is 3") {
                throw("Thrown exception does not have the message we expected. Actual: #errorMessage#");
            }
        });

        Tester.RunTest("NumberValue::IsNot().LessThan(2) => 3 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatNumber(3, Assertions.NumberValue::IsNot().LessThan(2));
            });
        });

        Tester.RunTest("NumberValue::IsNot().LessThan(2) => 1 - should throw", () => {

            var errorMessage = Assert::Throws(() => {
                    Assertions.Assert::ThatNumber(1, Assertions.NumberValue::IsNot().LessThan(2));
                },
                Assertions.Assert::GetAssertionType()
            );

            if (errorMessage != "Expected value to not be less than 2 but it is 1") {
                throw("Thrown exception does not have the message we expected. Actual: #errorMessage#");
            }
        });

    Tester.EndTests();

    Tester.BeginTests("GreaterThan()");

        Tester.RunTest("NumberValue::Is().GreaterThan(1) => 2 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatNumber(2, Assertions.NumberValue::Is().GreaterThan(1));
            });
        });

        Tester.RunTest("NumberValue::Is().GreaterThan(2) => 1 - should throw", () => {

            var errorMessage = Assert::Throws(() => {
                    Assertions.Assert::ThatNumber(1, Assertions.NumberValue::Is().GreaterThan(2));
                },
                Assertions.Assert::GetAssertionType()
            );

            if (errorMessage != "Expected value to be greater than 2 but it is 1") {
                throw("Thrown exception does not have the message we expected. Actual: #errorMessage#");
            }
        });

        Tester.RunTest("NumberValue::IsNot().GreaterThan(2) => 1 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatNumber(1, Assertions.NumberValue::IsNot().GreaterThan(2));
            });
        });

        Tester.RunTest("NumberValue::IsNot().GreaterThan(1) => 2 - should throw", () => {

            var errorMessage = Assert::Throws(() => {
                    Assertions.Assert::ThatNumber(2, Assertions.NumberValue::IsNot().GreaterThan(1));
                },
                Assertions.Assert::GetAssertionType()
            );

            if (errorMessage != "Expected value to not be greater than 1 but it is 2") {
                throw("Thrown exception does not have the message we expected. Actual: #errorMessage#");
            }
        });

    Tester.EndTests();
</cfscript>

</body>
</html>