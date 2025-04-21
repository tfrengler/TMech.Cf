/**
 * A utility for constructing a WebdriverContext using a fluent API
 */
component displayname="WebdriverBuilder" modifier="final" output="false" accessors="false" persistent="true"
{
    // PRIVATE
    property name="IsRemote"         type="boolean" getter="false" setter="false";
    property name="IsHeadless"       type="boolean" getter="false" setter="false";
    property name="IsFullscreen"     type="boolean" getter="false" setter="false";
    property name="WindowSize"       type="Models.Dimension" getter="false" setter="false";
    property name="DriverService"    type="any" getter="false" setter="false"; // org.openqa.selenium.remote.service.DriverService
    property name="BrowserBinary"    type="string" getter="false" setter="false";
    property name="DownloadFolder"   type="string" getter="false" setter="false";
    property name="Browser"          type="string" getter="false" setter="false";
    property name="RemoteServerUrl"  type="string" getter="false" setter="false";
    property name="BrowserArguments" type="array" getter="false" setter="false";

    private WebdriverBuilder function Init(required string browser, string remoteServerUrl = "") {
        if (arguments.browser.len() == 0) {
            throw("Argument 'browser' is required but was empty");
        }

        variables.IsRemote = arguments.remoteServerUrl.len() > 0;
        variables.IsHeadless = false;
        variables.IsFullscreen = false;
        variables.WindowSize = Models.Dimension::None();
        variables.DriverService = nullValue();
        variables.BrowserBinary = "";
        variables.DownloadFolder = "";
        variables.BrowserArguments = [];

        variables.Browser = arguments.browser;
        variables.RemoteServerUrl = arguments.remoteServerUrl;

        return this;
    }

    /**
     * Creates a webdriver to run a browser that is located on the same machine this code is executed. Note that running in local mode is always headless.
     */
    public static WebdriverBuilder function CreateLocal(required string browser) {
        return new WebdriverBuilder(arguments.browser);
    }

    /**
     * Creates a webdriver to run a browser that is usually located somewhere else than on the machine where this code is executing (typically a Selenium Grid server).
     *
     * @remoteServerUrl The url of the remote server. Note that it is also possible to start the webdriver binary on this machine and pass in the localhost:port to run it locally.
     */
    public static WebdriverBuilder function CreateRemote(required string browser, required string remoteServerUrl) {
        if (arguments.remoteServerUrl.len() == 0) {
            throw("Argument 'remoteServerUrl' is required but was empty");
        }
        return new WebdriverBuilder(arguments.browser, arguments.remoteServerUrl);
    }

    // Remote and local

    /**
     * Starts the browser in headless mode (no UI). Note that browsers started via CreateLocal() are always headless!
     * This has several advantages:
     * it saves resources
     * allows you to emulate higher resolutions than the max screensize of the target machine
     * allows it to run on shell-only servers
     */
    public WebdriverBuilder function ThatRunsHeadless() {
        variables.IsHeadless = true;
        return this;
    }

    /**
     * Makes the browser window as big as the screensize of the target machine.
     * Note that this has no effect in headless mode. In that case you have to set screensize specifically.
     */
    public WebdriverBuilder function ThatRunsFullScreen() {
        variables.IsFullscreen = true;
        return this;
    }

    /**
     * Resizes the browser window to a specific size. Useful for emulating devices of different screensizes.
     * If ThatRunsHeadless() has been called and this has not then the window size defaults to 1920x1080.
     * In all other cases it is non-deterministic what size the browser window ends up being and depends on the vendor.
     */
    public WebdriverBuilder function WithWindowSize(required numeric width, required numeric height) {

        if (arguments.width <= 0 || arguments.height <= 0) {
            throw("Argument width or height is equal to or less than 0 (x: #arguments.width# | y: #arguments.height#)");
        }

        variables.WindowSize = new Models.Dimension(arguments.width, arguments.height);
        return this;
    }

    /**
     * Passes an array of command-line arguments to the browser upon startup.
     */
    public WebdriverBuilder function WithBrowserArguments(required array arguments) {
        variables.BrowserArguments = arguments.arguments;
        return this;
    }

    // Local only

    /**
     * Uses the driver service you pass to manage the underlying webdriver binary. This is normally done internally by Selenium and is not required.
     * Expected to be a Java-object that derives from org.openqa.selenium.remote.service.DriverService.
     * Only relevant for webdrivers not running against a remote server.
     */
    public WebdriverBuilder function UsingDriverService(required any service) {
        if (!application.isJavaObject(arguments.service)) {
            throw("Expected argument 'service' to be an instance of 'org.openqa.selenium.remote.service.DriverService'");
        }

        variables.DriverService = arguments.service;
        return this;
    }

    /**
     * Redirects Selenium to use another browser binary than the standard one (gotten from the PATH).
     * Useful if you have a specific browser configured for testing installed (such as 'Chrome for Testing').
     * Only relevant for webdrivers not running against a remote server.
     */
    public WebdriverBuilder function WithBrowserBinaryLocatedAt(required string absolutePathToExecutable) {
        if (!fileExists(arguments.absolutePathToExecutable)) {
            throw("The file in argument 'absolutePathToExecutable' does not exist: #arguments.absolutePathToExecutable#");
        }

        variables.BrowserBinary = arguments.absolutePathToExecutable;
        return this;
    }

    /**
     * Redirects the download-folder of the browser to a specific location. Only works for Chromium-based browsers.
     * Only relevant for webdrivers not running against a remote server.
     */
    public WebdriverBuilder function WithDownloadFolderLocatedAt(required string absolutePathToFolder) {
        if (!directoryExists(arguments.absolutePathToFolder)) {
            throw("The folder in argument 'absolutePathToFolder' does not exist: #arguments.absolutePathToFolder#");
        }

        variables.DownloadFolder = arguments.absolutePathToFolder;
        return this;
    }

    // Final

    /**
     * Initializes the webdriver which starts the browser.
     */
    public Services.WebdriverContext function Initialize() {
        return new Services.WebdriverContext(
            isRemote = variables.IsRemote,
            isHeadless = variables.IsHeadless,
            isFullscreen = variables.IsFullscreen,
            windowSize = variables.WindowSize,
            driverService = variables.DriverService,
            browserBinary = variables.BrowserBinary,
            downloadFolder = variables.DownloadFolder,
            browser = variables.Browser,
            remoteServerUrl = variables.RemoteServerUrl,
            browserArguments = variables.BrowserArguments
        );
    }
}