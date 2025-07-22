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
</cfscript>

</body>
</html>