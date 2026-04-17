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
    <a href='index.cfm' >BACK</a>
</cfoutput>

<cfscript>
    expectedAssertionType = "#Assertions.Constraint::GetBaseAssertionType()#.Any";
    Tester = new TestRunner("AnyValue.cfc");

    Tester.BeginTests("Shared");

        Tester.RunTest("When Is.String against a CFC then throw", () => {

            Assert::Throws(() => {
                var component = Assertions.AnyValue::Is();
                Assertions.Assert::That(component, Assertions.AnyValue::Is().String());
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.String against a null-value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(nullValue(), Assertions.AnyValue::Is().String());
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("String()");

        Tester.RunTest("When Is.String against a string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That("test", Assertions.AnyValue::Is().String());
            });
        });

        Tester.RunTest("When IsNot.String against a string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That("test", Assertions.AnyValue::IsNot().String());
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.String against another type then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(1, Assertions.AnyValue::Is().String());
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("Numeric()");

        Tester.RunTest("When Is.Numeric against a string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(1, Assertions.AnyValue::Is().Numeric());
            });
        });

        Tester.RunTest("When IsNot.Numeric against a string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(1, Assertions.AnyValue::IsNot().Numeric());
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Numeric against another type then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(true, Assertions.AnyValue::Is().Numeric());
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("Boolean()");

        Tester.RunTest("When Is.Boolean against a bool then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(true, Assertions.AnyValue::Is().Boolean());
            });
        });

        Tester.RunTest("When IsNot.Boolean against a bool then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(true, Assertions.AnyValue::IsNot().Boolean());
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Boolean against another type then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(1, Assertions.AnyValue::Is().Boolean());
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("Array()");

        Tester.RunTest("When Is.Array against an array then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That([], Assertions.AnyValue::Is().Array());
            });
        });

        Tester.RunTest("When IsNot.Array against an array then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That([], Assertions.AnyValue::IsNot().Array());
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Array against another type then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(1, Assertions.AnyValue::Is().Array());
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("Struct()");

        Tester.RunTest("When Is.Struct against a struct then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That({}, Assertions.AnyValue::Is().Struct());
            });
        });

        Tester.RunTest("When IsNot.Struct against a struct then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That({}, Assertions.AnyValue::IsNot().Struct());
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Struct against another type then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(1, Assertions.AnyValue::Is().Struct());
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("Throwing()");

        Tester.RunTest("When Is.Throwing against a function that throws then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    () => { throw("I throw!") },
                    Assertions.AnyValue::Is().Throwing()
                );
            });
        });

        Tester.RunTest("When Is.Throwing against a function that does not throw then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    () => 42,
                    Assertions.AnyValue::Is().Throwing()
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.Throwing against a function that throws then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    () => { throw("I throw!") },
                    Assertions.AnyValue::IsNot().Throwing()
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Throwing against another type then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.AnyValue::Is().Throwing()
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();
</cfscript>

</body>
</html>