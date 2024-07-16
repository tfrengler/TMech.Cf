<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChromeProvider.cfc tests</title>
    <style>
        body {
            margin-left: 25%;
            margin-right: 25%;
        }
    </style>
</head>
<body>

<cfscript>
    Tester = new UnitTester("ChromeProvider.cfc");
    ChromeTestDir = "C:/Temp/Chrome_Test";

    Tester.BeginTests("Init");

    Tester.RunTest("Install dir exists", () => {
        Assert::DoesNotThrow(()=> new Services.ChromeProvider(ChromeTestDir));
    });

    Tester.RunTest("Install does not exist", () => {
        Assert::Throws(()=> new Services.ChromeProvider("C:\Gnargle"), "TMech.Cf.NoSuchDir");
    });

    Tester.EndTests();
    Tester.BeginTests("Request timeout");

    Tester.RunTest("Default timeout", () => {
        var Instance = new Services.ChromeProvider(ChromeTestDir);
        Assert::NumberEqualTo(Instance.GetRequestTimeout(), 30);
    });

    Tester.RunTest("Change timeout", () => {
        var Instance = new Services.ChromeProvider(ChromeTestDir);
        Instance.SetRequestTimeout(42);
        Assert::NumberEqualTo(Instance.GetRequestTimeout(), 42);
    });

    Tester.EndTests();
    Tester.BeginTests("Supported platforms");

    Tester.RunTest("Get supported platforms", () => {
        var Instance = new Services.ChromeProvider(ChromeTestDir);
        Assert::StringNotEmpty(Instance.GetSupportedPlatforms());
    });

    Tester.RunTest("Is supported platform positive", () => {
        var Instance = new Services.ChromeProvider(ChromeTestDir);
        Assert::IsTrue(Instance.IsSupportedPlatform("win64"));
        Assert::IsTrue(Instance.IsSupportedPlatform("linux64"));
    });

    Tester.RunTest("Is supported platform negative", () => {
        var Instance = new Services.ChromeProvider(ChromeTestDir);
        Assert::IsFalse(Instance.IsSupportedPlatform("gnargle"));
    });

    Tester.EndTests();
    Tester.BeginTests("Available version");

    Tester.RunTest("Current installed version not empty", () => {
        var VersionFile = "#ChromeTestDir#/VERSION";
        fileWrite(VersionFile, "123");
        var Instance = new Services.ChromeProvider(ChromeTestDir);
        var ActualVersion = Instance.GetCurrentInstalledVersion();
        fileDelete(VersionFile);
        Assert::StringEqual(ActualVersion, "123");
    });

    Tester.RunTest("Current installed version empty", () => {
        var Instance = new Services.ChromeProvider(ChromeTestDir);
        var ActualVersion = Instance.GetCurrentInstalledVersion();
        Assert::StringEmpty(ActualVersion);
    });

    Tester.RunTest("Latest online version (win64)", () => {
        var Instance = new Services.ChromeProvider(ChromeTestDir);
        var LatestVersion = Instance.GetLatestAvailableVersion("win64");
        Assert::StringNotEmpty(LatestVersion);
    });

    Tester.RunTest("Latest online version (linux64)", () => {
        var Instance = new Services.ChromeProvider(ChromeTestDir);
        var LatestVersion = Instance.GetLatestAvailableVersion("linux64");
        Assert::StringNotEmpty(LatestVersion);
    });

    Tester.EndTests();
</cfscript>

</body>
</html>