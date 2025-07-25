<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Any value assert tests</title>
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
    Tester = new TestRunner("Assert::That, AnyConstraint.cfc and AnyValue.cfc");

    Tester.BeginTests("String()");

        // NULL
        Tester.RunTest("AnyValue::Is().String() => null - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(null, Assertions.AnyValue::Is().String());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().String() => null - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(null, Assertions.AnyValue::IsNot().String());
            });
        });

        // SHOULD THROW
        Tester.RunTest("AnyValue::Is().String()) => true - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(true, Assertions.AnyValue::Is().String());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().String()) => 'test' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That("test", Assertions.AnyValue::IsNot().String());
            }, Assertions.Assert::GetAssertionType());
        });

        // SHOULD NOT THROW
        Tester.RunTest("AnyValue::Is().String()) => 'test' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That("test", Assertions.AnyValue::Is().String());
            });
        });

        Tester.RunTest("AnyValue::IsNot().String()) => 42 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(2, Assertions.AnyValue::IsNot().String());
            });
        });

    Tester.EndTests();

    Tester.BeginTests("Numeric()");

        // NULL
        Tester.RunTest("AnyValue::Is().Numeric() => null - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(null, Assertions.AnyValue::Is().Numeric());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().Numeric() => null - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(null, Assertions.AnyValue::IsNot().Numeric());
            });
        });

        // SHOULD THROW
        Tester.RunTest("AnyValue::Is().Numeric()) => true - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(true, Assertions.AnyValue::Is().Numeric());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().Numeric()) => 4 - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(4, Assertions.AnyValue::IsNot().Numeric());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().Numeric()) => 42 - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(42, Assertions.AnyValue::IsNot().Numeric());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().Numeric()) => 42.3 - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(42.3, Assertions.AnyValue::IsNot().Numeric());
            }, Assertions.Assert::GetAssertionType());
        });

        // SHOULD NOT THROW
        Tester.RunTest("AnyValue::Is().Numeric()) => 42 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(42, Assertions.AnyValue::Is().Numeric());
            });
        });

        Tester.RunTest("AnyValue::Is().Numeric()) => 42.3 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(42.3, Assertions.AnyValue::Is().Numeric());
            });
        });

        Tester.RunTest("AnyValue::IsNot().Numeric()) => 'test' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That("test", Assertions.AnyValue::IsNot().Numeric());
            });
        });

    Tester.EndTests();

    Tester.BeginTests("Array()");

        // NULL
        Tester.RunTest("AnyValue::Is().Array() => null - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(null, Assertions.AnyValue::Is().Array());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().Array() => null - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(null, Assertions.AnyValue::IsNot().Array());
            });
        });

        // SHOULD THROW
        Tester.RunTest("AnyValue::Is().Array()) => true - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(true, Assertions.AnyValue::Is().Array());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().Array()) => [] - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That([], Assertions.AnyValue::IsNot().Array());
            }, Assertions.Assert::GetAssertionType());
        });

        // SHOULD NOT THROW
        Tester.RunTest("AnyValue::Is().Array()) => [] - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That([], Assertions.AnyValue::Is().Array());
            });
        });

        Tester.RunTest("AnyValue::IsNot().Array()) => 42 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(42, Assertions.AnyValue::IsNot().Array());
            });
        });

    Tester.EndTests();

    Tester.BeginTests("Struct()");

        // NULL
        Tester.RunTest("AnyValue::Is().Struct() => null - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(null, Assertions.AnyValue::Is().Struct());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().Struct() => null - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(null, Assertions.AnyValue::IsNot().Struct());
            });
        });

        // SHOULD THROW
        Tester.RunTest("AnyValue::Is().Struct()) => true - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(true, Assertions.AnyValue::Is().Struct());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().Struct()) => {} - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That({}, Assertions.AnyValue::IsNot().Struct());
            }, Assertions.Assert::GetAssertionType());
        });

        // SHOULD NOT THROW
        Tester.RunTest("AnyValue::Is().Struct()) => {} - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That({}, Assertions.AnyValue::Is().Struct());
            });
        });

        Tester.RunTest("AnyValue::IsNot().Struct()) => 42 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(42, Assertions.AnyValue::IsNot().Struct());
            });
        });

    Tester.EndTests();

    Tester.BeginTests("Boolean()");

        // NULL
        Tester.RunTest("AnyValue::Is().Boolean() => null - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(null, Assertions.AnyValue::Is().Boolean());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().Boolean() => null - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(null, Assertions.AnyValue::IsNot().Boolean());
            });
        });

        // SHOULD THROW
        Tester.RunTest("AnyValue::Is().Boolean()) => 42 - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(42, Assertions.AnyValue::Is().Boolean());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("AnyValue::IsNot().Boolean()) => true - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(true, Assertions.AnyValue::IsNot().Boolean());
            }, Assertions.Assert::GetAssertionType());
        });

        // SHOULD NOT THROW
        Tester.RunTest("AnyValue::Is().Boolean()) => false - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(false, Assertions.AnyValue::Is().Boolean());
            });
        });

        Tester.RunTest("AnyValue::IsNot().Boolean()) => 42 - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(42, Assertions.AnyValue::IsNot().Boolean());
            });
        });

    Tester.EndTests();
</cfscript>

</body>
</html>