component displayname="Selenium" modifier="final" output="false" accessors="false" persistent="true" hint="Component representing Selenium, that serves as a helper interface for resolving and getting references to underlying Selenium Java classes, types, enums etc." {

    property name="Jars" type="array" getter="false" setter="false" default="";

    public Selenium function Init(required string pathToSeleniumJarFolder ) {

        if(!directoryExists(arguments.pathToSeleniumJarFolder))
        {
            throw("Error instantiating Selenium-component. The folder in 'pathToSeleniumJarFolder' does not exist: " & arguments.pathToSeleniumJarFolder);
        }

        var SeleniumJars = directoryList(pathToSeleniumJarFolder, false, "path", "*.jar");
        if (SeleniumJars.len() == 0)
        {
            throw("Error instantiating Selenium-component. The folder in 'pathToSeleniumJarFolder' exist but appears to be empty (expected jar-files): " & arguments.pathToSeleniumJarFolder);
        }

        variables.Jars = SeleniumJars;

        variables.ProxyType = createObject("java", "org.openqa.selenium.Proxy$ProxyType", variables.Jars);
        variables.By = createObject("java", "org.openqa.selenium.By", variables.Jars);
        variables.ScreenshotOutputType = createObject("java", "org.openqa.selenium.OutputType", variables.Jars);

        return this;
    }

    property name="ProxyType"               type="any" getter="true" setter="false" default="";
    property name="By"                      type="any" getter="true" setter="false" default="";
    property name="ScreenshotOutputType"    type="any" getter="true" setter="false" default="";

    public any function FirefoxDriverService() {
        return createObject("java", "org.openqa.selenium.firefox.GeckoDriverService", variables.Jars);
    }

    public any function FirefoxOptions() {
        return createObject("java", "org.openqa.selenium.firefox.FirefoxOptions", variables.Jars);
    }

    public any function FirefoxDriver() {
        return createObject("java", "org.openqa.selenium.firefox.FirefoxDriver", variables.Jars);
    }

    public any function ChromeDriverService() {
        return createObject("java", "org.openqa.selenium.chrome.ChromeDriverService", variables.Jars);
    }

    public any function ChromeOptions() {
        return createObject("java", "org.openqa.selenium.chrome.ChromeOptions", variables.Jars);
    }

    public any function ChromeDriver() {
        return createObject("java", "org.openqa.selenium.chrome.ChromeDriver", variables.Jars);
    }

    public any function Proxy() {
        return createObject("java", "org.openqa.selenium.Proxy", variables.Jars);
    }

    public any function RemoteWebDriverBuilder() {
        return createObject("java", "org.openqa.selenium.remote.RemoteWebDriverBuilder", variables.Jars);
    }

    public any function RemoteWebDriver() {
        return createObject("java", "org.openqa.selenium.remote.RemoteWebDriver", variables.Jars);
    }

    public any function Dimension(required numeric width, required numeric height) {
        return createObject("java", "org.openqa.selenium.Dimension", variables.Jars).init(width, height);
    }
}