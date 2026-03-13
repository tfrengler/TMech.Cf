<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Array assert tests</title>
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
    expectedAssertionType = "#Assertions.Constraint::GetBaseAssertionType()#.Array";
    Tester = new TestRunner("ArrayValue.cfc");

    Tester.BeginTests("Empty()");

        Tester.RunTest("When Is/IsNot.Empty against a null-value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(nullValue(), Assertions.ArrayValue::IsNot().Empty());
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.Empty against non-empty array then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(["test"], Assertions.ArrayValue::IsNot().Empty());
            });
        });

        Tester.RunTest("When IsNot.Empty against empty array then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That([], Assertions.ArrayValue::IsNot().Empty());
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Empty against empty array then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That([], Assertions.ArrayValue::Is().Empty());
            });
        });

        Tester.RunTest("When Is.Empty against non-empty array then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(["test"], Assertions.ArrayValue::Is().Empty());
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("SatisfiedByAny()");

        Tester.RunTest("When Is.SatisfiedByAny against null-value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    nullValue(),
                    Assertions.ArrayValue::Is().SatisfiedByAny((x) => arguments.x == "test2")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.SatisfiedByAny against non-empty array where 1 item matches then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    ["test1","test2"],
                    Assertions.ArrayValue::Is().SatisfiedByAny((x) => arguments.x == "test2")
                );
            })
        })

        Tester.RunTest("When IsNot.SatisfiedByAny against non-empty array where no item matches then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    ["test1","test2"],
                    Assertions.ArrayValue::IsNot().SatisfiedByAny((x) => arguments.x == "test3")
                );
            })
        });

        Tester.RunTest("When Is.SatisfiedByAny against non-empty array where no item matches then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    ["test1","test2"],
                    Assertions.ArrayValue::Is().SatisfiedByAny((x) => arguments.x == "test3")
                );
            }, expectedAssertionType)
        });

        Tester.RunTest("When IsNot.SatisfiedByAny against non-empty array where 1 item matches then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    ["test1","test2"],
                    Assertions.ArrayValue::IsNot().SatisfiedByAny((x) => arguments.x == "test2")
                );
            }, expectedAssertionType)
        });

    Tester.EndTests();

    Tester.BeginTests("SatisfiedByAll()");

        Tester.RunTest("When Is.SatisfiedByAll against null-value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    nullValue(),
                    Assertions.ArrayValue::Is().SatisfiedByAll((x) => arguments.x == "test2")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.SatisfiedByAll against empty array then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    [],
                    Assertions.ArrayValue::Is().SatisfiedByAll((x) => arguments.x == "test2")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.SatisfiedByAll against 2-item array where only 1 item matches then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    [1,2],
                    Assertions.ArrayValue::Is().SatisfiedByAll((x) => arguments.x == 1)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.SatisfiedByAll against 2-item array where only 1 item matches then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    [1,2],
                    Assertions.ArrayValue::IsNot().SatisfiedByAll((x) => arguments.x == 1)
                );
            });
        });

        Tester.RunTest("When Is.SatisfiedByAll against 2-item array where 2 items matches then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    [1,2],
                    Assertions.ArrayValue::Is().SatisfiedByAll((x) => arguments.x < 3)
                );
            });
        });
    Tester.EndTests();

    Tester.BeginTests("Containing()");

        Tester.RunTest("When Is.Containing against null-value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    nullValue(),
                    Assertions.ArrayValue::Is().Containing(2)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Containing against empty array then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    [],
                    Assertions.ArrayValue::Is().Containing(2)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When IsNot.Containing against empty array then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    [],
                    Assertions.ArrayValue::IsNot().Containing(2)
                );
            });
        });

        Tester.RunTest("When Is.Containing against non-empty array with no matches then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    [1,3],
                    Assertions.ArrayValue::Is().Containing(2)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Containing against non-empty array with a match then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    [1,2,3],
                    Assertions.ArrayValue::Is().Containing(2)
                );
            });
        });

        Tester.RunTest("When IsNot.Containing against non-empty array with a match then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    [1,2,3],
                    Assertions.ArrayValue::IsNot().Containing(2)
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("SimilarTo()");

        Tester.RunTest("When Is.SimilarTo against null-value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    nullValue(),
                    Assertions.ArrayValue::Is().SimilarTo([1,3,5])
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.SimilarTo against empty array then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    [],
                    Assertions.ArrayValue::Is().SimilarTo([1,3,5])
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.SimilarTo against non-empty array that does not match then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    [3,1,6],
                    Assertions.ArrayValue::Is().SimilarTo([1,3,5])
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.SimilarTo against non-empty array that does match then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    [5,1,3],
                    Assertions.ArrayValue::Is().SimilarTo([1,3,5])
                );
            });
        });

        Tester.RunTest("When IsNot.SimilarTo against non-empty array that does not match then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    [3,1,6],
                    Assertions.ArrayValue::IsNot().SimilarTo([1,3,5])
                );
            });
        });

        Tester.RunTest("When IsNot.SimilarTo against non-empty array that does match then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    [5,1,3],
                    Assertions.ArrayValue::IsNot().SimilarTo([1,3,5])
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("SequenceEqualTo()");

        Tester.RunTest("When Is.SequenceEqualTo against null-value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    nullValue(),
                    Assertions.ArrayValue::Is().SequenceEqualTo([1,2,3])
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.SequenceEqualTo against empty array then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    [],
                    Assertions.ArrayValue::Is().SequenceEqualTo([1,2,3])
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.SequenceEqualTo against non-empty array that does not match then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    [1,2,3],
                    Assertions.ArrayValue::Is().SequenceEqualTo([1,3,2])
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.SequenceEqualTo against non-empty array that does match then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    [1,2,3],
                    Assertions.ArrayValue::Is().SequenceEqualTo([1,2,3])
                );
            });
        });

        Tester.RunTest("When IsNot.SequenceEqualTo against non-empty array that does not match then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    [1,2,3],
                    Assertions.ArrayValue::IsNot().SequenceEqualTo([1,3,2])
                );
            });
        });

        Tester.RunTest("When IsNot.SequenceEqualTo against non-empty array that does match then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    [1,2,3],
                    Assertions.ArrayValue::IsNot().SequenceEqualTo([1,2,3])
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();
</cfscript>
</body>
</html>