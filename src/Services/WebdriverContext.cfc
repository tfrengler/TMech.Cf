/**
 * Component that represents the context of a Selenium webdriver (the class that represents and 'drives' the browser interaction).
 * Contains the logic for managing the lifetime of a webdriver along with its state and configuration.
 */
component displayname="WebdriverContext" modifier="final" output="false" accessors="false" persistent="true" {

    // PUBLIC
    property name="IsRemote"            type="boolean" getter="false" setter="false";
    property name="IsHeadless"          type="boolean" getter="false" setter="false";
    property name="IsFullscreen"        type="boolean" getter="false" setter="false";
    property name="WindowSize"          type="Dimension" getter="false" setter="false";
    property name="DriverService"       type="any" getter="false" setter="false"; // org.openqa.selenium.remote.service.DriverService
    property name="BrowserBinary"       type="string" getter="false" setter="false";
    property name="DownloadFolder"      type="string" getter="false" setter="false";
    property name="Browser"             type="string" getter="false" setter="false";
    property name="RemoteServerUrl"     type="string" getter="false" setter="false";
    property name="BrowserArguments"    type="array" getter="false" setter="false";

    // PRIVATE
    property name="Selenium"        type="Utils.Selenium" getter="false" setter="false";
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
     * @isRemote            Whether the webdriver is to be used locally (on executing machine) or run against a remote driver (on a Selenium Grid)
     * @isHeadless          Whether to launch the webdriver with or without a GUI. Without a GUI uses less resources and allows the webdriver to be run on shell-only servers.
     * @isFullscreen        Whether the browser window should be maximized to use the entire screen. Only relevant when 'isHeadless' is false and mutually exclusive with 'windowSize'. Takes precedence if true.
     * @windowSize          What size the browser window should have. Mutually exclusive with 'isFullscreen'. Defaults to 1920x1080 if equal to Dimension::None.
     * @driverService       An instance of a driverservice to manage the lifetime of the vendor specific driver-binary. Optional. Can be passed as null.
     * @browserBinary       The absolute path to the binary of the browser. Optional. If not passed then Selenium will attempt to find the browser via the enviroment variables.
     * @downloadFolder      An absolute path to the folder where any downloaded files should be stored. Optional. Will default to the browser's default location. Note that this does not work for Firefox.
     * @browser             The browser to start. This can be any of "CHROME", "FIREFOX" or "EDGE".
     * @remoteServerUrl     The address of the remote Selenium Grid server. If 'IsRemote' is true then this is required.
     * @browserArguments    Additional command line arguments to send to the browser upon startup. Optional.
     */
    public WebdriverContext function Init(
        required boolean isRemote,
        required boolean isHeadless,
        required boolean isFullscreen,
        required Dimension windowSize,
        required any driverService,
        required string browserBinary,
        required string downloadFolder,
        required string browser,
        required string remoteServerUrl,
        required array browserArguments)
    {

        if (!IsValidBrowser(browser)) {
            throw("Error instantiating WebdriverContext. Argument 'browser' is invalid: #arguments.browser#. Valid values are #GetValidBrowsers()#");
        }

        variables.Selenium = application.Selenium;

        variables.IsRemote = arguments.isRemote;
        variables.IsHeadless = arguments.isHeadless;
        variables.IsFullscreen = arguments.isFullscreen;
        variables.WindowSize = arguments.windowSize;
        variables.DriverService = arguments.driverService;
        variables.BrowserBinary = arguments.browserBinary;
        variables.DownloadFolder = arguments.downloadFolder;
        variables.Browser = arguments.browser;
        variables.RemoteServerUrl = arguments.remoteServerUrl;
        variables.BrowserArguments = arguments.browserArguments;

        // writeDump(variables);

        var options = CreateOptions(
            arguments.browser,
            arguments.isHeadless,
            arguments.browserArguments,
            arguments.downloadFolder
        );

        if (variables.IsRemote === true) {

            if (arguments.RemoteServerUrl.len() == 0) {
                throw("Expected argument 'RemoteServerUrl' to not be empty when argument 'IsRemote' is true");
            }

            variables.Webdriver = variables.Selenium.RemoteWebDriver()
                .builder()
                .addAlternative(options)
                .address(arguments.RemoteServerUrl)
                .build();

            variables.Webdriver.setFileDetector(variables.Selenium.LocalFileDetector().init());
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

            if (!isNull(variables.DriverService)) {
                variables.Webdriver = WebdriverHandle.init(variables.DriverService, options);
            }
            else {
                variables.Webdriver = WebdriverHandle.init(options);
            }
        }

        // Firefox and Chrome likes to throw exceptions (no execution context) if you try and interact with it too quickly after the driver has been started...
        sleep(2000);

        if (arguments.isFullscreen)
        {
            Webdriver.manage().window().maximize();
        }
        else
        {
            var WindowSize = 0;

            if (arguments.WindowSize.IsValid()) {
                WindowSize = variables.Selenium.Dimension(arguments.WindowSize.getX(), arguments.WindowSize.getY());
            }
            else {
                WindowSize = variables.Selenium.Dimension(1920, 1080);
            }

            Webdriver.manage().window().setSize(WindowSize);
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
        var returnData = nullValue();
        var isChromiumBased = false;

        switch (arguments.browser) {
            case "CHROME":
                returnData = variables.Selenium.ChromeOptions().init();
                isChromiumBased = true;
                break;
            case "EDGE":
                returnData = variables.Selenium.EdgeOptions().init();
                isChromiumBased = true;
                break;
            case "FIREFOX":
                var returnData = variables.Selenium.FirefoxOptions().init();
                var firefoxProfile = variables.Selenium.GetHandle("org.openqa.selenium.firefox.FirefoxProfile").init();
                returnData.setProfile(firefoxProfile);
                break;
            default:
                // This should only happen if the dev did a booboo
                throw("INTERNAL ERROR - Invalid browser option: #arguments.browser#");
        }

        if (isChromiumBased) {
            var preferences = {
                "safebrowsing.enabled": "false",
                "download.prompt_for_download": false
            }

            if (arguments.downloadFolder.len() > 0)
            {
                preferences["download.directory_upgrade"] = true;
                preferences["download.default_directory"] = arguments.downloadFolder;
            }

            returnData.setExperimentalOption("prefs", preferences);

            if (arguments.IsHeadless)
            {
                returnData.addArguments("--headless=new");
            }
        }

        if (arguments.browserArguments.len() > 0)
        {
            returnData.addArguments(arguments.browserArguments);
        }

        var proxy = variables.Selenium.Proxy().init();
        proxy.setAutodetect(false);
        proxy.setProxyType(variables.Selenium.GetProxyType().DIRECT)
        returnData.setProxy(proxy);

        return returnData;
    }

    public any function Driver()
    {
        return variables.Webdriver;
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