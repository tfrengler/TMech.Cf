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
    <a href='index.cfm' >BACK</a>
</cfoutput>

<cfscript>
    Tester = new TestRunner("StringValue.cfc");
    expectedAssertionType = "#Assertions.Constraint::GetBaseAssertionType()#.String";

    Tester.BeginTests("Nothing()");

        Tester.RunTest("When Is.Nothing against a null-value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    nullValue(),
                    Assertions.StringValue::Is().Nothing()
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Nothing against empty string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That("", Assertions.StringValue::Is().Nothing());
            });
        });

        Tester.RunTest("When Is.Nothing against string with chars then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That("x", Assertions.StringValue::Is().Nothing());
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Nothing against string with only whitespace then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That("   ", Assertions.StringValue::Is().Nothing());
            });
        });

        Tester.RunTest("When IsNot.Nothing against empty string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That("", Assertions.StringValue::IsNot().Nothing());
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.Nothing against string with chars then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That("test", Assertions.StringValue::IsNot().Nothing());
            });
        });

        Tester.RunTest("When IsNot.Nothing against string with only whitespace then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That("   ", Assertions.StringValue::IsNot().Nothing());
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("EqualTo()");

        Tester.RunTest("When Is.EqualTo against an empty string with a non-empty string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::Is().EqualTo("test")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.EqualTo against an empty string with an empty string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::Is().EqualTo("")
                );
            });
        });

        Tester.RunTest("When Is.EqualTo against a non-empty string with a matching string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::Is().EqualTo("test")
                );
            });
        });

        Tester.RunTest("When Is.EqualTo against a non-empty uppercase string with a matching but lowercase string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::Is().EqualTo("TEST")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.EqualTo.IgnoringCase against a non-empty uppercase string with a matching but lowercase string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::Is().IgnoringCase().EqualTo("TEST")
                );
            });
        });

        Tester.RunTest("When IsNot.EqualTo against an empty string with a non-empty string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::IsNot().EqualTo("test")
                );
            });
        });

        Tester.RunTest("When IsNot.EqualTo against an empty string with an empty string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::IsNot().EqualTo("")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.EqualTo against a non-empty string with a matching string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::IsNot().EqualTo("test")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.EqualTo against a non-empty uppercase string with a matching but lowercase string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::IsNot().EqualTo("TEST")
                );
            });
        });

        Tester.RunTest("When IsNot.EqualTo.IgnoringCase against a non-empty uppercase string with a matching but lowercase string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::IsNot().IgnoringCase().EqualTo("TEST")
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("Containing()");

        Tester.RunTest("When Is.Containing against an empty string with a non-empty string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::Is().Containing("test")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Containing against an empty string with an empty string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::Is().Containing("")
                );
            });
        });

        Tester.RunTest("When Is.Containing against a non-empty string with a matching sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::Is().Containing("es")
                );
            });
        });

        Tester.RunTest("When Is.Containing against a non-empty uppercase string with a matching but lowercase sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::Is().Containing("es")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Containing.IgnoringCase against a non-empty uppercase string with a matching but lowercase sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::Is().IgnoringCase().Containing("es")
                );
            });
        });

        Tester.RunTest("When IsNot.Containing against an empty string with a non-empty string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::IsNot().Containing("test")
                );
            });
        });

        Tester.RunTest("When IsNot.Containing against an empty string with an empty string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::IsNot().Containing("")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.Containing against a non-empty string with a matching sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::IsNot().Containing("es")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.Containing against a non-empty uppercase string with a matching but lowercase sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::IsNot().Containing("es")
                );
            });
        });

        Tester.RunTest("When IsNot.Containing.IgnoringCase against a non-empty uppercase string with a matching but lowercase sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::IsNot().IgnoringCase().Containing("es")
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("StartingWith()");

        Tester.RunTest("When Is.StartingWith against an empty string with an empty string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::Is().StartingWith("")
                );
            });
        });

        Tester.RunTest("When Is.StartingWith against a non-empty string with a matching sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::Is().StartingWith("te")
                );
            });
        });

        Tester.RunTest("When Is.StartingWith against a non-empty string with a non-matching sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::Is().StartingWith("xy")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.StartingWith against a non-empty uppercase string with a matching but lowercase sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::Is().StartingWith("te")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.StartingWith.IgnoringCase against a non-empty uppercase string with a matching but lowercase sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::Is().IgnoringCase().StartingWith("te")
                );
            });
        });

        Tester.RunTest("When IsNot.StartingWith against a non-empty string with a matching sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::IsNot().StartingWith("te")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.StartingWith against a non-empty string with a non-matching sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::IsNot().StartingWith("xy")
                );
            });
        });

        Tester.RunTest("When IsNot.StartingWith against a non-empty uppercase string with a matching but lowercase sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::IsNot().StartingWith("te")
                );
            });
        });

        Tester.RunTest("When IsNot.StartingWith.IgnoringCase against a non-empty uppercase string with a matching but lowercase sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::IsNot().IgnoringCase().StartingWith("te")
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("EndingWith()");

        Tester.RunTest("When Is.EndingWith against an empty string with an empty string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::Is().EndingWith("")
                );
            });
        });

        Tester.RunTest("When Is.EndingWith against a non-empty string with a matching sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::Is().EndingWith("st")
                );
            });
        });

        Tester.RunTest("When Is.EndingWith against a non-empty string with a non-matching sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::Is().EndingWith("xy")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.EndingWith against a non-empty uppercase string with a matching but lowercase sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::Is().EndingWith("st")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.EndingWith.IgnoringCase against a non-empty uppercase string with a matching but lowercase sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::Is().IgnoringCase().EndingWith("st")
                );
            });
        });

        Tester.RunTest("When IsNot.EndingWith against a non-empty string with a matching sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::IsNot().EndingWith("st")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.EndingWith against a non-empty string with a non-matching sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "test",
                    Assertions.StringValue::IsNot().EndingWith("xy")
                );
            });
        });

        Tester.RunTest("When IsNot.EndingWith against a non-empty uppercase string with a matching but lowercase sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::IsNot().EndingWith("st")
                );
            });
        });

        Tester.RunTest("When IsNot.EndingWith.IgnoringCase against a non-empty uppercase string with a matching but lowercase sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "TEST",
                    Assertions.StringValue::IsNot().IgnoringCase().EndingWith("st")
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("Matching()");

        Tester.RunTest("When Is.Matching against an empty string with an empty string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::Is().Matching("")
                );
            });
        });

        Tester.RunTest("When Is.Matching against a non-empty string with a matching sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "te st",
                    Assertions.StringValue::Is().Matching("\ss")
                );
            });
        });

        Tester.RunTest("When Is.Matching against a non-empty string with a non-matching sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "te st",
                    Assertions.StringValue::Is().Matching("\s{2}s")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Matching against a non-empty uppercase string with a matching but lowercase sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "TE ST",
                    Assertions.StringValue::Is().Matching("\ss")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Matching.IgnoringCase against a non-empty uppercase string with a matching but lowercase sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "TE ST",
                    Assertions.StringValue::Is().IgnoringCase().Matching("\ss")
                );
            });
        });

        Tester.RunTest("When IsNot.Matching against a non-empty string with a matching sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "te st",
                    Assertions.StringValue::IsNot().Matching("\ss")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.Matching against a non-empty string with a non-matching sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "te st",
                    Assertions.StringValue::IsNot().Matching("\sx")
                );
            });
        });

        Tester.RunTest("When IsNot.Matching against a non-empty uppercase string with a matching but lowercase sub-string then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "TE ST",
                    Assertions.StringValue::IsNot().Matching("\ss")
                );
            });
        });

        Tester.RunTest("When IsNot.Matching.IgnoringCase against a non-empty uppercase string with a matching but lowercase sub-string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "TE ST",
                    Assertions.StringValue::IsNot().IgnoringCase().Matching("\ss")
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("ValidJSON()");

        Tester.RunTest("When Is.ValidJSON against an empty string then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "",
                    Assertions.StringValue::Is().ValidJSON()
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.ValidJSON against {} then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "{}",
                    Assertions.StringValue::Is().ValidJSON()
                );
            });
        });

        Tester.RunTest("When Is.ValidJSON against {'test': 1} then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "{'test': 1}",
                    Assertions.StringValue::Is().ValidJSON()
                );
            });
        });

        Tester.RunTest("When Is.ValidJSON against {'test': 1,} then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    "{'test': 1,}",
                    Assertions.StringValue::Is().ValidJSON()
                );
            });
        });

        Tester.RunTest("When Is.ValidJSON against {'test1': 1, 'test2'} then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    "{'test1': 1, 'test2'}",
                    Assertions.StringValue::Is().ValidJSON()
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();
</cfscript>

</body>
</html>