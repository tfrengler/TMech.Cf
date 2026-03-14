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
    Tester = new TestRunner("NumberValue.cfc");
    expectedAssertionType = "#Assertions.Constraint::GetBaseAssertionType()#.Number";

    Tester.BeginTests("EqualTo()");

        Tester.RunTest("When Is.EqualTo against 2 when value is 3 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::Is().EqualTo(3)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.EqualTo against 2 when value is 2 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::Is().EqualTo(2)
                );
            });
        });

        Tester.RunTest("When IsNot.EqualTo against 2 when value is 3 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::IsNot().EqualTo(3)
                );
            });
        });

        Tester.RunTest("When IsNot.EqualTo against 2 when value is 2 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::IsNot().EqualTo(2)
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("LessThanOrEqualToZero()");

        Tester.RunTest("When Is.LessThanOrEqualToZero when value is 1 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    1,
                    Assertions.NumberValue::Is().LessThanOrEqualToZero()
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.LessThanOrEqualToZero when value is 0 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    0,
                    Assertions.NumberValue::Is().LessThanOrEqualToZero()
                );
            });
        });

        Tester.RunTest("When Is.LessThanOrEqualToZero when value is -1 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    -1,
                    Assertions.NumberValue::Is().LessThanOrEqualToZero()
                );
            });
        });

        Tester.RunTest("When IsNot.LessThanOrEqualToZero value is 1 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    1,
                    Assertions.NumberValue::IsNot().LessThanOrEqualToZero()
                );
            });
        });

        Tester.RunTest("When IsNot.LessThanOrEqualToZero when value is 0 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    0,
                    Assertions.NumberValue::IsNot().LessThanOrEqualToZero()
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.LessThanOrEqualToZero when value is -1 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    -1,
                    Assertions.NumberValue::IsNot().LessThanOrEqualToZero()
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("Zero()");

        Tester.RunTest("When Is.Zero when value is 1 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    1,
                    Assertions.NumberValue::Is().Zero()
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Zero when value is 0 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    0,
                    Assertions.NumberValue::Is().Zero()
                );
            });
        });

        Tester.RunTest("When Is.Zero when value is -1 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    -1,
                    Assertions.NumberValue::Is().Zero()
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.Zero when value is 1 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    1,
                    Assertions.NumberValue::IsNot().Zero()
                );
            });
        });

        Tester.RunTest("When IsNot.Zero when value is 0 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    0,
                    Assertions.NumberValue::IsNot().Zero()
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.Zero when value is -1 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    -1,
                    Assertions.NumberValue::IsNot().Zero()
                );
            });
        });

    Tester.EndTests();

    Tester.BeginTests("LessThan()");

        Tester.RunTest("When Is.LessThan against 2 when value is 3 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::Is().LessThan(3)
                );
            });
        });

        Tester.RunTest("When Is.LessThan against 2 when value is 2 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::Is().LessThan(2)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.LessThan against 2 when value is 1 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::Is().LessThan(1)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.LessThan against 2 when value is 3 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::IsNot().LessThan(3)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.LessThan against 2 when value is 2 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::IsNot().LessThan(2)
                );
            });
        });

        Tester.RunTest("When IsNot.LessThan against 2 when value is 1 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::IsNot().LessThan(1)
                );
            });
        });

    Tester.EndTests();

    Tester.BeginTests("GreaterThan()");

        Tester.RunTest("When Is.GreaterThan against 3 when value is 2 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    3,
                    Assertions.NumberValue::Is().GreaterThan(2)
                );
            });
        });

        Tester.RunTest("When Is.GreaterThan against 2 when value is 2 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::Is().GreaterThan(2)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.GreaterThan against 1 when value is 2 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    1,
                    Assertions.NumberValue::Is().GreaterThan(2)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.GreaterThan against 3 when value is 2 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    3,
                    Assertions.NumberValue::IsNot().GreaterThan(2)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.GreaterThan against 2 when value is 2 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::IsNot().GreaterThan(2)
                );
            });
        });

        Tester.RunTest("When IsNot.GreaterThan against 2 when value is 1 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    1,
                    Assertions.NumberValue::IsNot().GreaterThan(2)
                );
            });
        });

    Tester.EndTests();

    Tester.BeginTests("Between()");

        Tester.RunTest("When Is.Between against 2 when values are 1 and 3 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::Is().Between(1,3)
                );
            });
        });

        Tester.RunTest("When Is.Between against 3 when values are 1 and 3 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    3,
                    Assertions.NumberValue::Is().Between(1,3)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Between against 1 when values are 1 and 3 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    1,
                    Assertions.NumberValue::Is().Between(1,3)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.Between against 2 when values are 1 and 3 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::IsNot().Between(1,3)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.Between against 3 when values are 1 and 3 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    3,
                    Assertions.NumberValue::IsNot().Between(1,3)
                );
            });
        });

        Tester.RunTest("When IsNot.Between against 1 when values are 1 and 3 then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    1,
                    Assertions.NumberValue::IsNot().Between(1,3)
                );
            });
        });

        Tester.RunTest("When Is.Between against 2 when values are 3 and 1 then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    2,
                    Assertions.NumberValue::Is().Between(3,1)
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();
</cfscript>

</body>
</html>