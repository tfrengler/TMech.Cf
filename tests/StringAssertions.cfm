<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>String assert tests</title>
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
    Tester = new TestRunner("Assert::ThatString, StringConstraints.cfc and StringValue.cfc");

    Tester.BeginTests("Nothing()");

        Tester.RunTest("StringValue::IsNot().Nothing() => null - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString(nullValue(), Assertions.StringValue::IsNot().Nothing());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("StringValue::Is().Nothing() => null - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString(nullValue(), Assertions.StringValue::Is().Nothing());
            });
        });

        Tester.RunTest("StringValue::IsNot().Nothing() => ' x  ' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString(" x  ", Assertions.StringValue::IsNot().Nothing());
            });
        });

        Tester.RunTest("StringValue::Is().Nothing() => '  ' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString("   ", Assertions.StringValue::Is().Nothing());
            });
        });

        Tester.RunTest("StringValue::IsNot().Nothing() => '  ' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString("   ", Assertions.StringValue::IsNot().Nothing());
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("StringValue::Is().Nothing() => ' x  ' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString(" x  ", Assertions.StringValue::Is().Nothing());
            }, Assertions.Assert::GetAssertionType());
        });

    Tester.EndTests();

    Tester.BeginTests("EqualTo()");

        Tester.RunTest("StringValue::IsNot().EqualTo('nottest') => 'test' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().EqualTo("nottest"));
            });
        });

        Tester.RunTest("StringValue::Is().EqualTo('test') => 'test' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::Is().EqualTo("test"));
            });
        });

        Tester.RunTest("StringValue::IsNot().EqualTo('test') => 'test' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().EqualTo("test"));
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("StringValue::Is().EqualTo('nottest') => 'test' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::Is().EqualTo("nottest"));
            }, Assertions.Assert::GetAssertionType());
        });

    Tester.EndTests();

    Tester.BeginTests("Containing()");

        Tester.RunTest("StringValue::Is().Containing('es') => 'test' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::Is().Containing("es"));
            });
        });

        Tester.RunTest("StringValue::IsNot().Containing('x') => 'test' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().Containing("x"));
            });
        });

        Tester.RunTest("StringValue::Is().Containing('x') => 'test' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::Is().Containing("x"));
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("StringValue::IsNot().Containing('es') => 'test' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().Containing("es"));
            }, Assertions.Assert::GetAssertionType());
        });

    Tester.EndTests();

    Tester.BeginTests("StartingWith()");

        Tester.RunTest("StringValue::Is().StartingWith('te') => 'test' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::Is().StartingWith("te"));
            });
        });

        Tester.RunTest("StringValue::IsNot().StartingWith('tx') => 'test' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().StartingWith("tx"));
            });
        });

        Tester.RunTest("StringValue::Is().StartingWith('tx') => 'test' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::Is().StartingWith("tx"));
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("StringValue::IsNot().StartingWith('te') => 'test' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().StartingWith("te"));
            }, Assertions.Assert::GetAssertionType());
        });

    Tester.EndTests();

    Tester.BeginTests("EndingWith()");

        Tester.RunTest("StringValue::Is().EndingWith('st') => 'test' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::Is().EndingWith("st"));
            });
        });

        Tester.RunTest("StringValue::IsNot().EndingWith('xt') => 'test' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().EndingWith("xt"));
            });
        });

        Tester.RunTest("StringValue::Is().EndingWith('sx') => 'test' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::Is().EndingWith("sx"));
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("StringValue::IsNot().EndingWith('st') => 'test' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString("test", Assertions.StringValue::IsNot().EndingWith("st"));
            }, Assertions.Assert::GetAssertionType());
        });

    Tester.EndTests();

    Tester.BeginTests("Matching()");

        Tester.RunTest("StringValue::Is().Matching('There's 1 number') => '\d num' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString("There's 1 number", Assertions.StringValue::Is().Matching("\d num"));
            });
        });

        Tester.RunTest("StringValue::IsNot().Matching('There's 1 number') => '\d{2} num' - should not throw", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::ThatString("There's 1 number", Assertions.StringValue::IsNot().Matching("\d{2} num"));
            });
        });

        Tester.RunTest("StringValue::Is().Matching('There's 1 number') => '\d{2} num' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString("There's 1 number", Assertions.StringValue::Is().Matching("\d{2} num"));
            }, Assertions.Assert::GetAssertionType());
        });

        Tester.RunTest("StringValue::IsNot().Matching('There's 1 number') => '\d num' - should throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::ThatString("There's 1 number", Assertions.StringValue::IsNot().Matching("\d num"));
            }, Assertions.Assert::GetAssertionType());
        });

    Tester.EndTests();
</cfscript>

</body>
</html>