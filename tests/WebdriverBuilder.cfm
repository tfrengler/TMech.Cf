<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebdriverBuilder.cfc tests</title>
    <style>
        body {
            margin-left: 25%;
            margin-right: 25%;
        }
    </style>
</head>
<body>

    <fieldset>
        <form method="POST" action="">
        <h1>Local-mode</h1>
        <ul>

            <li>
                <input type="radio" name="TestCase" value="Test1" id="Test1" />
                <label for="Test1">001: ThatRunsHeadless (no windowSize)</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test2" id="Test2" />
                <label for="Test2">002: ThatRunsHeadless (windowSize = 1600x768)</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test3" id="Test3" />
                <label for="Test3">003: WithWindowSize (1280x720)</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test4" id="Test4" />
                <label for="Test4">004: ThatRunsMaximized</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test5" id="Test5" />
                <label for="Test5">005: ThatRunsMaximized + WithWindowSize (1280x720)</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test6" id="Test6" />
                <label for="Test6">006: WithBrowserArguments (--start-maximized)</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test7" id="Test7" />
                <label for="Test7">007: UsingDriverService</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test8" id="Test8" />
                <label for="Test8">008: WithBrowserBinaryLocatedAt</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test9" id="Test9" />
                <label for="Test9">009: WithDownloadFolderLocatedAt</label>
            </li>

        </ul>
        <input type="submit" value="Execute test" />
        </form>
    </fieldset>

    <fieldset>
        <form method="POST" action="">
        <h1>Remote-mode</h1>
        <ul>

            <li>
                <input type="radio" name="TestCase" value="Test10" id="Test10" />
                <label for="Test10">010: ThatRunsHeadless (no windowSize)</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test11" id="Test11" />
                <label for="Test11">011: ThatRunsHeadless (windowSize = 1600x768)</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test12" id="Test12" />
                <label for="Test12">012: WithWindowSize (1280x720)</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test13" id="Test13" />
                <label for="Test13">013: ThatRunsMaximized</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test14" id="Test14" />
                <label for="Test14">014: ThatRunsMaximized + WindowSize (1280x720)</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test15" id="Test15" />
                <label for="Test15">015: WithBrowserArguments (--start-maximized)</label>
            </li>

        </ul>
        <input type="submit" value="Execute test" />
        </form>
    </fieldset>

    <cfscript>

    Utils.WebdriverBuilder::RegisterSelenium(application.Selenium);
    tempFolder = "C:\Dev\Temp\";

    startDriverService = function() {
        var returnData = application.Selenium.ChromeDriverServiceBuilder()
            .usingAnyFreePort()
            .usingDriverExecutable(createObject("java", "java.io.File").init("#tempFolder#Chromium\chromedriver.exe"))
            .build();
        returnData.start();
        return returnData;
    }

    doTest = function(required Utils.WebdriverBuilder builder, any driverService) {
        try {
            writeDump(var=#arguments.builder.ToString()#, label="WebdriverBuilder");

            var context = arguments.builder.Initialize();

            var webdriver = context.Driver();
            writeDump(var=webdriver.getClass().getName(), label="Webdriver class name");

            var browserScreen = webdriver.manage().window().getSize();
            writeDump(var="[ X = #browserScreen.getWidth()# | Y = #browserScreen.getHeight()# ]", label="Browser window size");

            var webdriver.get("https://www.rockpapershotgun.com/latest");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("#tempFolder#test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            if (isDefined("context")) {
                context.onDestroy();
            }
            if (structKeyExists(arguments, "driverService")) {
                arguments.driverService.stop();
            }
        }
    }

    testCases = {};
    // LOCAL
    testCases.Test1 = function() {
        writeDump("Expect: Browser size to be 1920 x 1080 which is the default when no WindowSize argument is passed");

        var builder = Utils.WebdriverBuilder::CreateLocal("CHROME")
            .ThatRunsHeadless();

        doTest(builder);
    }

    testCases.Test2 = function() {
        writeDump("Expect: Browser size to be equal to the passed window size");

        var builder = Utils.WebdriverBuilder::CreateLocal("CHROME")
            .ThatRunsHeadless(new Models.Dimension(1600,768));

        doTest(builder);
    }

    testCases.Test3 = function() {
        writeDump("Expect: Browser size to be equal to the passed window size");

        var builder = Utils.WebdriverBuilder::CreateLocal("CHROME")
            .WithWindowSize(1280,720);

        doTest(builder);
    }

    testCases.Test4 = function() {
        writeDump("Expect: Browser size in local-mode is not affected by telling Selenium to maximize the window");

        var builder = Utils.WebdriverBuilder::CreateLocal("CHROME")
            .ThatRunsMaximized();

        doTest(builder);
    }

    testCases.Test5 = function() {
        writeDump("Expect: Although ThatRunsMaximized() takes precedence the browser size in local-mode is not affected by telling Selenium to maximize the window");

        var builder = Utils.WebdriverBuilder::CreateLocal("CHROME")
            .ThatRunsMaximized()
            .WithWindowSize(1280,720);

        doTest(builder);
    }

    testCases.Test6 = function() {
        writeDump("Expect: Browser size to be equal or close to the desktop size when using argument 'start-maximized' in local-mode");

        var builder = Utils.WebdriverBuilder::CreateLocal("CHROME")
            .WithBrowserArguments(["--start-maximized"]);

        doTest(builder);
    }

    testCases.Test7 = function() {
        writeDump("Expect: Chrome for Testing to be started instead of normal Chrome (verify via task manager)");

        var driverService = application.Selenium.ChromeDriverServiceBuilder()
            .usingAnyFreePort()
            .usingDriverExecutable(createObject("java", "java.io.File").init("#tempFolder#Chromium\chromedriver.exe"))
            .build();

        var builder = Utils.WebdriverBuilder::CreateLocal("CHROME")
            .UsingDriverService(driverservice, driverService);

        doTest(builder, driverService);
    }

    testCases.Test8 = function() {
        writeDump("Expect: Chrome for Testing to be started instead of normal Chrome (verify via task manager)");

        var builder = Utils.WebdriverBuilder::CreateLocal("CHROME")
            .WithBrowserBinaryLocatedAt("#tempFolder#Chromium\chrome.exe");

        doTest(builder);
    }

    testCases.Test9 = function() {
        writeDump("Expect: test pdf to be downloaded to #tempFolder# because we redirected the download-folder of Chrome");

        try {
            var builder = Utils.WebdriverBuilder::CreateLocal("CHROME")
                .WithDownloadFolderLocatedAt(tempFolder);

            writeDump(var=#builder.ToString()#, label="WebdriverBuilder");

            var context = builder.Initialize();

            var webdriver = context.Driver();
            writeDump(var=webdriver.getClass().getName(), label="Webdriver class name");

            var browserScreen = webdriver.manage().window().getSize();
            writeDump(var="[ X = #browserScreen.getWidth()# | Y = #browserScreen.getHeight()# ]", label="Browser window size");

            var webdriver = context.Driver();
            var webdriver.get("https://www.ciz.nl/test-download");

            var downloadedFile = "#tempFolder#dummy_1.pdf";
            sleep(3000);

            Assert::FileExists(downloadedFile);
            fileDelete(downloadedFile);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            context.onDestroy();
        }
    }
    // REMOTE
    testCases.Test10 = function() {
        writeDump("Expect: Browser size is 1920 x 1080 which is the default when calling ThatRunsHeadless() without arguments");
        var driverService = startDriverService();

        var builder = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
            .ThatRunsHeadless();

        doTest(builder, driverService);

    }

    testCases.Test11 = function() {
        writeDump("Expect: Browser size to be the window size we passed or close to it.");
        var driverService = startDriverService();

        var builder = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
            .ThatRunsHeadless(new Models.Dimension(1600,768));

        doTest(builder, driverService);
    }

    testCases.Test12 = function() {
        writeDump("Expect: Browser size to be the window size we passed or close to it.");
        var driverService = startDriverService();

        var builder = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
            .WithWindowSize(1280,720);

        doTest(builder, driverService);
    }

    testCases.Test13 = function() {
        writeDump("Expect: Using Selenium to maximize the browser is a no-op becase browser size in remote-mode is determined by driver vendor implementation unless a window size is explicitly set.");
        var driverService = startDriverService();

        var builder = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
            .ThatRunsMaximized();

        doTest(builder, driverService);
    }

    testCases.Test14 = function() {
        writeDump("Expect: WithWindowSize to be a no-op for two reasons: 1 = ThatRunsMaximized() takes precedence and 2 = Browser size in remote-mode is determined by driver vendor implementation unless a window size is explicitly set.");
        var driverService = startDriverService();

        var builder = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
            .ThatRunsMaximized()
            .WithWindowSize(1280,720);

        doTest(builder, driverService);
    }

    testCases.Test15 = function() {
        writeDump("Expect: Browser argument to maximize window is a no-op because browser size in remote-mode is determined by driver vendor implementation unless a window size is explicitly set.");
        var driverService = startDriverService();

        var builder = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
            .WithBrowserArguments(["--start-maximized"]);

        doTest(builder, driverService);
    }
    </cfscript>
    <hr/>
    <cfscript>
        if (!structIsEmpty(FORM)) {
            writeDump(var=#FORM.TestCase#, label="TestCase");
            testCases[FORM.TestCase]();
        }
    </cfscript>
</body>
</html>