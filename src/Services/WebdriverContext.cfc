/**
 * @hint Component that represents the context of a Selenium webdriver (the class that represents and 'drives' the browser interaction).
 * Contains the logic for managing the lifetime of a webdriver along with its state and configuration.
 */
component displayname="WebdriverContext" output="false" accessors="false" persistent="true" {

    // PUBLIC
    property name="IsRemote"            type="boolean" getter="false" setter="false";
    property name="IsHeadless"          type="boolean" getter="false" setter="false";
    property name="IsMaximized"         type="boolean" getter="false" setter="false";
    property name="WindowSize"          type="Dimension" getter="false" setter="false";
    property name="DriverService"       type="org.openqa.selenium.remote.service.DriverService" getter="false" setter="false";
    property name="BrowserBinary"       type="string" getter="false" setter="false";
    property name="DownloadFolder"      type="string" getter="false" setter="false";
    property name="Browser"             type="string" getter="false" setter="false";
    property name="RemoteServerUrl"     type="string" getter="false" setter="false";
    property name="BrowserArguments"    type="array" getter="false" setter="false";

    // PRIVATE
    property name="Selenium"            type="Utils.Selenium" getter="false" setter="false";
    property name="Webdriver"           type="org.openqa.selenium.remote.RemoteWebDriver" getter="false" setter="false";
    /* The above is a Java-object. If IsRemote = false then it is one of these (depending on Browser):
        - org.openqa.selenium.chrome.ChromeDriver
        - org.openqa.selenium.firefox.FirefoxDriver
        - org.openqa.selenium.edge.EdgeDriver
    * If IsRemote = true then it is: org.openqa.selenium.remote.RemoteWebDriver
    * NOTE: RemoteWebdriver is the base class for the local, vendor specific vendors.
    */

    /**
     * Although the WebdriverContext can be instantiated directly it is highly recommended to do so via the WebdriverBuilder instead.
     * Many of these arguments are conditionally mandatory or optional depending on what is passed.
     */
    public WebdriverContext function Init(
        required boolean isRemote,
        required boolean isHeadless,
        required boolean isMaximized,
        required Dimension windowSize,
        required any driverService,
        required string browserBinary,
        required string downloadFolder,
        required string browser,
        required string remoteServerUrl,
        required array browserArguments) output = false
    {

        if (!IsValidBrowser(browser)) {
            throw("Error instantiating WebdriverContext. Argument 'browser' is invalid: #arguments.browser#. Valid values are #GetValidBrowsers()#");
        }

        variables.Selenium = application.Selenium;

        variables.IsRemote = arguments.isRemote;
        variables.IsHeadless = arguments.isHeadless;
        variables.IsMaximized = arguments.isMaximized;
        variables.WindowSize = arguments.windowSize;
        variables.DriverService = arguments.driverService;
        variables.BrowserBinary = arguments.browserBinary;
        variables.DownloadFolder = arguments.downloadFolder;
        variables.Browser = arguments.browser;
        variables.RemoteServerUrl = arguments.remoteServerUrl;
        variables.BrowserArguments = arguments.browserArguments;

        var options = CreateOptions();

        if (variables.IsRemote == true) {

            if (arguments.RemoteServerUrl.len() == 0) {
                throw("Expected argument 'RemoteServerUrl' to not be empty when argument 'IsRemote' is true");
            }

            variables.Webdriver = variables.Selenium.RemoteWebDriver()
                .builder()
                .addAlternative(options)
                .address(arguments.RemoteServerUrl)
                .build();
            // Required for you to be able to upload local files to the remote server via the browser
            variables.Webdriver.setFileDetector(variables.Selenium.LocalFileDetector().init());
        }
        else {
            if (variables.BrowserBinary.len() > 0) {
                options.setBinary(variables.BrowserBinary);
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

            if (isNull(variables.DriverService) == false) {
                variables.Webdriver = WebdriverHandle.init(variables.DriverService, options);
            }
            else {
                variables.Webdriver = WebdriverHandle.init(options);
            }
        }

        // Firefox and Chrome likes to throw exceptions (no execution context) if you try and interact with it too quickly after the driver has been started...
        sleep(2000);

        if (variables.isMaximized == true)
        {
            Webdriver.manage().window().maximize();
        }
        else if (variables.WindowSize.IsValid())
        {
            Webdriver.manage().window().setSize(
                variables.Selenium.Dimension(
                    variables.WindowSize.getX(),
                    variables.WindowSize.getY()
                )
            );
        }

        Webdriver.manage().timeouts().pageLoadTimeout(
            createObject("java", "java.time.Duration").ofSeconds(180)
        );

        return this;
    }

    private any function CreateOptions() output = false {
        var returnData = nullValue();
        var isChromiumBased = false;

        switch (variables.browser) {
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
                returnData.addArguments("--headless");
                var firefoxProfile = variables.Selenium.GetHandle("org.openqa.selenium.firefox.FirefoxProfile").init();
                returnData.setProfile(firefoxProfile);
                break;
            default:
                // This should only happen if the dev did a booboo
                throw("INTERNAL ERROR - Invalid browser option: #variables.Browser#");
        }

        if (isChromiumBased) {
            var preferences = {
                "safebrowsing.enabled": "false",
                "download.prompt_for_download": false
            }

            if (variables.DownloadFolder.len() > 0)
            {
                preferences["download.directory_upgrade"] = true;
                preferences["download.default_directory"] = variables.DownloadFolder;
                preferences["savefile.default_directory"] = variables.DownloadFolder;
            }

            returnData.setExperimentalOption("prefs", preferences);

            if (variables.isHeadless)
            {
                returnData.addArguments(["--headless=new"]);
            }
        }

        if (variables.browserArguments.len() > 0)
        {
            returnData.addArguments(variables.browserArguments);
        }

        var proxy = variables.Selenium.Proxy().init();
        proxy.setAutodetect(false);
        proxy.setProxyType(variables.Selenium.ProxyType().DIRECT)
        returnData.setProxy(proxy);

        return returnData;
    }

    /**
     * Returns the underlying Java webdriver instance.
     */
    public any function Driver() output = false {
        return variables.Webdriver;
    }

    /**
     * Destructor. Called when the component goes out of scope (ie. if stored in the session or application).
     */
    public void function onDestroy() output = false {
        try {
            variables.Webdriver.quit();
        }
        catch (error) {}
    }

    /* STATIC FUNCTIONS */

    public static string function GetValidBrowsers() output = false
    {
        return "CHROME,FIREFOX,EDGE";
    }

    public static boolean function IsValidBrowser(required string browser) output = false
    {
        return listFind(GetValidBrowsers(), arguments.browser) != 0;
    }
}