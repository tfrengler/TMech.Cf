/**
 * Component that represents the context of a Selenium webdriver (the class that represents and 'drives' the browser interaction).
 * Contains the logic for managing the lifetime of a webdriver along with its state and configuration.
 */
component displayname="WebdriverContext" modifier="final" output="false" accessors="false" persistent="true" {

    // PUBLIC
    property name="IsRemote"            type="boolean" getter="false" setter="false";
    property name="IsHeadless"          type="boolean" getter="false" setter="false";
    property name="IsFullscreen"        type="boolean" getter="false" setter="false";
    property name="WindowSize"          type="struct" getter="false" setter="false"; // x | y
    property name="DriverService"       type="any" getter="false" setter="false"; // org.openqa.selenium.remote.service.DriverService
    property name="BrowserBinary"       type="string" getter="false" setter="false";
    property name="DownloadFolder"      type="string" getter="false" setter="false";
    property name="Browser"             type="string" getter="false" setter="false";
    property name="RemoteServerUrl"     type="string" getter="false" setter="false";
    property name="BrowserArguments"    type="array" getter="false" setter="false";

    // PRIVATE
    property name="Selenium"        type="string" getter="false" setter="false";
    property name="Webdriver"       type="any" getter="false" setter="false";
    /* The above is a Java-object. If IsRemote = false then it is one of these (depending on Browser):
        - org.openqa.selenium.chrome.ChromeDriver
        - org.openqa.selenium.firefox.FirefoxDriver
        - org.openqa.selenium.edge.EdgeDriver
    * If IsRemote = true then it is: org.openqa.selenium.remote.RemoteWebDriver
    */

    /**
     * Although the WebdriverContext can be instantiated directly it is highly recommended to do so via the WebdriverBuilder instead.
     * Many of these arguments are conditionally mandatory or optional depending on what is passed.
     *
     * @IsRemote
     * @IsHeadless
     * @IsFullscreen
     * @WindowSize
     * @DriverService
     * @BrowserBinary
     * @DownloadFolder
     * @Browser
     * @RemoteServerUrl
     */
    public WebdriverContext function Init(
        required boolean IsRemote,
        required boolean IsHeadless,
        required boolean IsFullscreen,
        required struct WindowSize,
        required any DriverService,
        required string BrowserBinary,
        required string DownloadFolder,
        required string Browser,
        required string RemoteServerUrl,
        required array BrowserArguments)
    {

        if (!IsValidBrowser(browser)) {
            throw("Error instantiating WebdriverContext. Argument 'browser' is invalid: #arguments.browser#. Valid values are #GetValidBrowsers()#");
        }

        variables.Selenium = application.Selenium;

        variables.IsRemote = arguments.IsRemote;
        variables.IsHeadless = arguments.IsHeadless;
        variables.IsFullscreen = arguments.IsFullscreen;
        variables.WindowSize = arguments.WindowSize;
        variables.DriverService = arguments.DriverService;
        variables.BrowserBinary = arguments.BrowserBinary;
        variables.DownloadFolder = arguments.DownloadFolder;
        variables.Browser = arguments.Browser;
        variables.RemoteServerUrl = arguments.RemoteServerUrl;
        variables.BrowserArguments = arguments.BrowserArguments;

        // Create options
        var options = variables.Selenium.ChromeOptions().init();

        if (arguments.IsRemote is true) {

            if (arguments.RemoteServerUrl.len() == 0) {
                throw("Expected argument 'RemoteServerUrl' to not be empty when argument 'IsRemote' is true");
            }

            variables.Webdriver = variables.Selenium.RemoteWebDriver()
                .builder()
                .addAlternative(options)
                .address(arguments.RemoteServerUrl)
                .build();
        }
        else {
            if (arguments.BrowserBinary.len() > 0) {
                options.setBinary(arguments.BrowserBinary);
            }

            var WebdriverHandle = null;

            switch (arguments.browser) {
                case "CHROME":
                    WebdriverHandle = variables.Selenium.ChromeDriver();
                    break;
                case "FIREFOX":
                    WebdriverHandle = variables.Selenium.FirefoxDriver();
                    break;
                case "EDGE":
                    WebdriverHandle = variables.Selenium.EdgeDriver();
                    break;
                default:
                    throw("Invalid browser string: #arguments.Browser#");
            }

            if (arguments.DriverService is not null) {
                variables.Webdriver = WebdriverHandle.init(arguments.DriverService, options);
            }
            else {
                variables.Webdriver = WebdriverHandle.init(options);
            }
        }

        // Firefox and Chrome likes to throw exceptions (no execution context) if you try and interact with it too quickly after the driver has been started...
        sleep(2000);

        if (arguments.IsHeadless)
        {
            var WindowSize = 0;

            if (arguments.WindowSize.X > 0 && arguments.WindowSize.Y > 0) {
                WindowSize = variables.Selenium.Dimension(arguments.WindowSize.X, arguments.WindowSize.Y);
            }
            else {
                variables.Selenium.Dimension(1920, 1080);
            }

            Webdriver.manage().window().setSize(WindowSize);
        }
        else
        {
            Webdriver.manage().window().maximize();
        }

        Webdriver.manage().timeouts().pageLoadTimeout(
            createObject("java", "java.time.Duration").ofSeconds(180)
        );

        return this;
    }

    private static any function CreateOptions(
        required string browser,
        required boolean isHeadless,
        required array browserArguments,
        required string downloadFolder
    ) {
        var returnData = 0;

        switch (arguments.browser) {
            case "BROWSER":
                var chromeOptions = variables.Selenium.ChromeOptions().init();
                chromeOptions.setExperimentalOption("safebrowsing.enabled", "false");
                chromeOptions.setExperimentalOption("download.prompt_for_download", false);

                if (arguments.downloadFolder.len() > 0)
                {
                    chromeOptions.setExperimentalOption("download.directory_upgrade", true);
                    chromeOptions.setExperimentalOption("download.default_directory", arguments.downloadFolder);
                }

                if (arguments.IsHeadless)
                {
                    chromeOptions.addArguments("--headless=new");
                }

                returnData = chromeOptions();
                break;
            case "FIREFOX":
                var firefoxOptions = variables.Selenium.FirefoxOptions().init();
                var firefoxProfile = variables.Selenium.GetHandle("org.openqa.selenium.firefox.FirefoxProfile");

                // if (arguments.downloadFolder.len() > 0) {
                //     firefoxProfile.setPreference("browser.download.dir", "/path/to/download");
                //     firefoxProfile.setPreference("browser.download.folderList", 2);
                //     firefoxProfile.setPreference("browser.helperApps.neverAsk.saveToDisk", "application/pdf");
                // }

                firefoxOptions.setProfile(firefoxProfile());

                returnData = firefoxOptions;
                break;
            case "EDGE":
                var edgeOptions = variables.Selenium.EdgeOptions().init();
                edgeOptions.setExperimentalOption("safebrowsing.enabled", "false");
                edgeOptions.setExperimentalOption("download.prompt_for_download", false);

                if (arguments.downloadFolder.len() > 0)
                {
                    edgeOptions.setExperimentalOption("download.directory_upgrade", true);
                    edgeOptions.setExperimentalOption("download.default_directory", arguments.downloadFolder);
                }

                if (arguments.IsHeadless)
                {
                    edgeOptions.addArguments("--headless=new");
                }

                returnData = edgeOptions();
                break;
            default:
                throw("Invalid browser option: #arguments.browser#");
        }

        if (arguments.browserArguments.len() > 0)
        {
            chromeOptions.addArguments(arguments.browserArguments);
        }

        var proxy = variables.Selenium.Proxy().init();
        proxy.setAutodetect(false);
        proxy.setProxyType(variables.Selenium.GetProxyType().DIRECT)
        returnData.setProxy();

        return returnData;
    }

    /**
     * Destructor. Called when the component goes out of scope or is garbage collected
     */
    public void function onDestroy() {
        try {
            variables.Webdriver.quit();
        }
        catch (error) {}
    }

    /* STATIC FUNCTIONS */

    public static string function GetValidBrowsers() { return "CHROME,FIREFOX,EDGE"; }

    public static boolean function IsValidBrowser(required string browser) {
        return listFind(GetValidBrowsers(), arguments.browser) != 0;
    }
}