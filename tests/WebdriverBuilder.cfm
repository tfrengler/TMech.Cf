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
                <label for="Test3">003: WithWindowSize (800x600)</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test4" id="Test4" />
                <label for="Test4">004: ThatRunsMaximized</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test5" id="Test5" />
                <label for="Test5">005: FullScreen + WindowSize (2560,1440)</label>
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
                <label for="Test12">012: WithWindowSize (800x600)</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test13" id="Test13" />
                <label for="Test13">013: ThatRunsMaximized</label>
            </li>
            <li>
                <input type="radio" name="TestCase" value="Test14" id="Test14" />
                <label for="Test14">014: FullScreen + WindowSize (2560,1440)</label>
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

    startDriverService = function() {
        var returnData = application.Selenium.ChromeDriverServiceBuilder()
            .usingAnyFreePort()
            .usingDriverExecutable(createObject("java", "java.io.File").init("C:\Temp\Chromium\chromedriver.exe"))
            .build();
        returnData.start();
        return returnData;
    }

    testCases = {};
    // LOCAL
    testCases.Test1 = function() {
        try {
            var context = Utils.WebdriverBuilder::CreateLocal("CHROME")
                .ThatRunsHeadless()
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test2 = function() {
        try {
            var context = Utils.WebdriverBuilder::CreateLocal("CHROME")
                .ThatRunsHeadless(new Models.Dimension(1600,768))
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test3 = function() {
        try {
            var context = Utils.WebdriverBuilder::CreateLocal("CHROME")
                .WithWindowSize(800,600)
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test4 = function() {
        try {
            var context = Utils.WebdriverBuilder::CreateLocal("CHROME")
                .ThatRunsMaximized()
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test5 = function() {
        try {
            var context = Utils.WebdriverBuilder::CreateLocal("CHROME")
                .ThatRunsMaximized()
                .WithWindowSize(2560,1440)
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test6 = function() {
        try {
            var context = Utils.WebdriverBuilder::CreateLocal("CHROME")
                .WithBrowserArguments(["--start-maximized"])
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test7 = function() {
        var driverService = application.Selenium.ChromeDriverServiceBuilder()
        .usingAnyFreePort()
        .usingDriverExecutable(createObject("java", "java.io.File").init("C:\Temp\Chromium\chromedriver.exe"))
        .build();

        try {
            var context = Utils.WebdriverBuilder::CreateLocal("CHROME")
                .UsingDriverService(driverservice)
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test8 = function() {
        try {
            var context = Utils.WebdriverBuilder::CreateLocal("CHROME")
                .WithBrowserBinaryLocatedAt("C:\Temp\Chromium\chrome.exe")
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test9 = function() {
        try {
            var context = Utils.WebdriverBuilder::CreateLocal("CHROME")
                .WithDownloadFolderLocatedAt("C:\Temp")
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.ciz.nl/test-download");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                context.onDestroy();
            }
            catch (any error) {}
        }
    }
    // REMOTE
    testCases.Test10 = function() {
        var driverService = startDriverService();

        try {
            var context = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
                .ThatRunsHeadless()
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                driverService.stop();
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test11 = function() {
        var driverService = startDriverService();

        try {
            var context = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
                .ThatRunsHeadless(new Models.Dimension(1600,768))
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                driverService.stop();
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test12 = function() {
        var driverService = startDriverService();

        try {
            var context = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
                .WithWindowSize(800,600)
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                driverService.stop();
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test13 = function() {
        var driverService = startDriverService();

        try {
            var context = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
                .ThatRunsMaximized()
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                driverService.stop();
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test14 = function() {
        var driverService = startDriverService();

        try {
            var context = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
                .ThatRunsMaximized()
                .WithWindowSize(2560,1440)
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                driverService.stop();
                context.onDestroy();
            }
            catch (any error) {}
        }
    }

    testCases.Test15 = function() {
        var driverService = startDriverService();

        try {
            var context = Utils.WebdriverBuilder::CreateRemote("CHROME", driverService.getUrl().toString())
                .WithBrowserArguments(["--start-maximized"])
                .Initialize();

            var webdriver = context.Driver();
            var webdriver.get("https://www.rockpapershotgun.com/latest");

            writeDump(var=webdriver.manage().window().getSize(), label="Screen size");
            var screenshot = webdriver.getScreenshotAs(application.Selenium.ScreenshotOutputType().BYTES);
            fileWrite("C:/Temp/test.png", screenshot);

            writeDump("Test case complete");
        }
        catch (any error) {
            rethrow;
        }
        finally {
            try {
                driverService.stop();
                context.onDestroy();
            }
            catch (any error) {}
        }
    }
    </cfscript>
    <hr/>
    <cfscript>
        if (!structIsEmpty(FORM)) {
            writeDump(FORM);
            testCases[FORM.TestCase]();
        }
    </cfscript>
</body>
</html>