/**
 * A utility for constructing a WebdriverContext using a fluent API
 */
component displayname="WebdriverBuilder" modifier="final" output="false" accessors="false" persistent="true"
{
    // PRIVATE
    property name="IsRemote"         type="boolean" getter="false" setter="false";
    property name="IsHeadless"       type="boolean" getter="false" setter="false";
    property name="IsMaximized"     type="boolean" getter="false" setter="false";
    property name="WindowSize"       type="Models.Dimension" getter="false" setter="false";
    property name="DriverService"    type="any" getter="false" setter="false"; // org.openqa.selenium.remote.service.DriverService
    property name="BrowserBinary"    type="string" getter="false" setter="false";
    property name="DownloadFolder"   type="string" getter="false" setter="false";
    property name="Browser"          type="string" getter="false" setter="false";
    property name="RemoteServerUrl"  type="string" getter="false" setter="false";
    property name="BrowserArguments" type="array" getter="false" setter="false";

    private WebdriverBuilder function Init(required string browser, string remoteServerUrl = "") output = false {
        if (arguments.browser.len() == 0) {
            throw("Argument 'browser' is required but was empty");
        }

        variables.IsRemote = arguments.remoteServerUrl.len() > 0;
        variables.IsHeadless = false;
        variables.IsMaximized = false;
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
     * Creates a webdriver meant to drive a browser that is located on the same machine this code is executed.
     * Note that running in local mode is always headless. This is not our choice but an implementation detail of Selenium.
     * This method therefore behaves as if ThatRunsHeadless() was called without a windowSize-argument.
     */
    public static WebdriverBuilder function CreateLocal(required string browser) output = false {
        return new WebdriverBuilder(arguments.browser).ThatRunsHeadless();
    }

    /**
     * Creates a webdriver meant to drive a browser that is (usually) located somewhere else than on the machine where this code is executing (typically a Selenium Grid server).
     *
     * @remoteServerUrl The url of the remote server. Note that it is also possible to start the webdriver binary on this machine and pass in localhost:port to run it locally.
     */
    public static WebdriverBuilder function CreateRemote(required string browser, required string remoteServerUrl) output = false {
        if (arguments.remoteServerUrl.len() == 0) {
            throw("Argument 'remoteServerUrl' is required but was empty");
        }
        return new WebdriverBuilder(arguments.browser, arguments.remoteServerUrl);
    }

    // Remote and local

    /**
     * Configures the browser to explicitly start in headless mode:
     * for Chromium-based browsers the browser is started with cmd-line argument --headless=new
     * for Firefox the browser is started with cmd-line argument --headless
     * Be aware that in many instances headless mode is implicit which is outside our control:
     * Browsers started via CreateLocal() are always implicitly headless regardless of webdriver configuration.
     * Browsers started via CreateRemote() whose remoteServerUrl-argument points to a local webdriver started via a driverservice.
     *
     * @windowSize  Resizes the browser window to a specific size. Optional, defaults to 1920x1080.
     */
    public WebdriverBuilder function ThatRunsHeadless(Models.Dimension windowSize) output = false {

        if (structKeyExists(arguments, "windowSize") === false) {
            variables.WindowSize = new Models.Dimension(1920,1080);
        }
        else {
            if (arguments.windowSize.IsValid() === false) {
                throw("Argument 'windowSize' is invalid (x: #arguments.windowSize.getX()# | y: #arguments.windowSize.getY()#");
            }
            variables.WindowSize = arguments.windowSize;
        }

        variables.IsHeadless = true;
        return this;
    }

    /**
     * Makes the browser window as big as the screensize of the target machine. Achived by instructing the webdriver to maximize the window after browser has started.
     * Note that in headless mode (whether explicit or implicit) the actual window size after maximizing is implementation specific and outside our control.
     * Mutually exclusive with WithWindowSize(). This method has precedence if both are called, regardless of order.
     */
    public WebdriverBuilder function ThatRunsMaximized() output = false {
        variables.IsMaximized = true;
        return this;
    }

    /**
     * Resizes the browser window to a specific size after starting. Useful for emulating devices of different screensizes.
     * Be aware that if ThatRunsHeadless() has NOT been called with a windowSize-argument that the actual
     * browser screen size will be non-deterministic and subject to the underlying implementation.
     *
     * Mutually exclusive with ThatRunsMaximized(). This method has no effect if both are called, regardless of order.
     */
    public WebdriverBuilder function WithWindowSize(required numeric width, required numeric height) output = false {

        var windowSize = new Models.Dimension(arguments.height, arguments.width);
        if (windowSize.IsValid() === false) {
            throw("Argument 'width' and/or 'height' is invalid (x: #arguments.width# | y: #arguments.height#)");
        }

        variables.WindowSize = windowSize;
        return this;
    }

    /**
     * Configures the browser to have an array of command-line arguments passed upon startup.
     */
    public WebdriverBuilder function WithBrowserArguments(required array arguments) output = false {
        variables.BrowserArguments = arguments.arguments;
        return this;
    }

    // Local only

    /**
     * Uses the driver service you pass to manage the underlying webdriver binary. This is normally done internally by Selenium and is not required.
     * Expected to be a Java-object that derives from org.openqa.selenium.remote.service.DriverService.
     * Only relevant for webdrivers not running against a remote server.
     */
    public WebdriverBuilder function UsingDriverService(required any service) output = false {
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
    public WebdriverBuilder function WithBrowserBinaryLocatedAt(required string absolutePathToExecutable) output = false {
        if (!fileExists(arguments.absolutePathToExecutable)) {
            throw("The file in argument 'absolutePathToExecutable' does not exist: #arguments.absolutePathToExecutable#");
        }

        variables.BrowserBinary = arguments.absolutePathToExecutable;
        return this;
    }

    /**
     * Redirects the download-folder of the browser to a specific location. Only works for Chromium-based browsers.
     * Only relevant for webdrivers not running against a remote server. To retrieve files downloaded via the browser
     * on a Grid-server have a look here: https://www.selenium.dev/documentation/grid/configuration/cli_options/#specifying-path-from-where-downloaded-files-can-be-retrieved
     */
    public WebdriverBuilder function WithDownloadFolderLocatedAt(required string absolutePathToFolder) output = false {
        if (!directoryExists(arguments.absolutePathToFolder)) {
            throw("The folder in argument 'absolutePathToFolder' does not exist: #arguments.absolutePathToFolder#");
        }

        variables.DownloadFolder = arguments.absolutePathToFolder;
        return this;
    }

    // Final

    /**
     * Initializes the webdriver which starts the browser and returns a WebdriverContext-instance for you.
     */
    public Services.WebdriverContext function Initialize() output = false {
        return new Services.WebdriverContext(
            isRemote = variables.IsRemote,
            isHeadless = variables.IsHeadless,
            isMaximized = variables.IsMaximized,
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