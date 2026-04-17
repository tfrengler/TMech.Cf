<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Struct assert tests</title>
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
    Tester = new TestRunner("StructValue.cfc");
    expectedAssertionType = "#Assertions.Constraint::GetBaseAssertionType()#.Struct";

    Tester.BeginTests("ContainingKey()");

        Tester.RunTest("When Is.ContainingKey against value with matching key then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    { "test": 1 },
                    Assertions.StructValue::Is().ContainingKey("test")
                );
            });
        });

        Tester.RunTest("When Is.ContainingKey against value without matching key then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    { "test": 1 },
                    Assertions.StructValue::Is().ContainingKey("gnargle")
                );
            }, expectedAssertionType);
        });
    Tester.EndTests();

    Tester.BeginTests("ContainingValue()");

        Tester.RunTest("When Is.ContainingValue against struct with matching, simple value then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().ContainingValue(2)
                );
            });
        });

        Tester.RunTest("When Is.ContainingValue against struct without matching, simple value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().ContainingValue(4)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.ContainingValue against nested struct with matching, simple value then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                        "nested": {
                            "test4": 4,
                            "test5": 5,
                            "test6": 6,
                        }
                    },
                    Assertions.StructValue::Is().ContainingValue(5)
                );
            });
        });

        Tester.RunTest("When Is.ContainingValue against struct with matching, complex value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                        "test4": [4]
                    },
                    Assertions.StructValue::Is().ContainingValue([4])
                );
            }, expectedAssertionType);
        });
    Tester.EndTests();

    Tester.BeginTests("ContainingValue()");

        Tester.RunTest("When Is.ContainingValue against struct with matching, simple value then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().ContainingValue(2)
                );
            });
        });

        Tester.RunTest("When Is.ContainingValue against struct without matching, simple value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().ContainingValue(4)
                );
            }, expectedAssertionType);
        });
    Tester.EndTests();

    Tester.BeginTests("ContainingValueAtKey()");

        Tester.RunTest("When Is.ContainingValueAtKey against struct with matching key and matching, simple value then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().ContainingValueAtKey("test2", 2)
                );
            });
        });

        Tester.RunTest("When Is.ContainingValueAtKey against struct with matching key but without matching, simple value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().ContainingValueAtKey("test2", "test")
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.ContainingValueAtKey against struct without matching key then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().ContainingValueAtKey("gnargle", 1)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.ContainingValueAtKey against struct with matching key but null-value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": nullValue(),
                    },
                    Assertions.StructValue::Is().ContainingValueAtKey("test3", 1)
                );
            }, expectedAssertionType);
        });
    Tester.EndTests();

    Tester.BeginTests("ValueAtKeySatisfiedBy()");

        Tester.RunTest("When Is.ValueAtKeySatisfiedBy against struct with matching value then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().ValueAtKeySatisfiedBy("test2", (x) => x == 2)
                );
            });
        });

        Tester.RunTest("When Is.ValueAtKeySatisfiedBy against struct without matching value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().ValueAtKeySatisfiedBy("test2", (x) => x == 3)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.ValueAtKeySatisfiedBy against struct without matching key then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().ValueAtKeySatisfiedBy("test4", (x) => x == 2)
                );
            }, expectedAssertionType);
        });
    Tester.EndTests();

    Tester.BeginTests("SatisfiedByAny()");

        Tester.RunTest("When Is.SatisfiedByAny against struct with matching value then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().SatisfiedByAny((key,value) => value == 2)
                );
            });
        });

        Tester.RunTest("When Is.SatisfiedByAny against struct without matching value then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().SatisfiedByAny((key,value) => value == 4)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.SatisfiedByAny against struct with matching key then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().SatisfiedByAny((key,value) => key == "test2")
                );
            });
        });

        Tester.RunTest("When Is.SatisfiedByAny against struct without matching key then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().SatisfiedByAny((key,value) => key == "gnargle")
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("SatisifedByAll()");

        Tester.RunTest("When Is.SatisfiedByAll against struct with matching values then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().SatisfiedByAll((key,value) => value < 4)
                );
            });
        });

        Tester.RunTest("When Is.SatisfiedByAll against struct without matching values then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().SatisfiedByAll((key,value) => value > 3)
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.SatisfiedByAll against struct with matching key then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().SatisfiedByAll((key,value) => key[1] == 't')
                );
            });
        });

        Tester.RunTest("When Is.SatisfiedByAll against struct without matching key then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    {
                        "test1": 1,
                        "test2": 2,
                        "test3": 3,
                    },
                    Assertions.StructValue::Is().SatisfiedByAll((key,value) => key == "gnargle")
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

    Tester.BeginTests("Empty()");

        Tester.RunTest("When Is.Empty against struct with key/value-pairs then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    { "test": 1 },
                    Assertions.StructValue::Is().Empty()
                );
            }, expectedAssertionType);
        });

        Tester.RunTest("When Is.Empty against struct with key/value-pairs then pass", () => {

            Assert::DoesNotThrow(() => {
                Assertions.Assert::That(
                    { },
                    Assertions.StructValue::Is().Empty()
                );
            });
        });

        Tester.RunTest("When Is.Empty against struct with keys with null-values then throw", () => {

            Assert::Throws(() => {
                Assertions.Assert::That(
                    { "test": nullValue() },
                    Assertions.StructValue::Is().Empty()
                );
            }, expectedAssertionType);
        });

    Tester.EndTests();

</cfscript>
</body>
</html>