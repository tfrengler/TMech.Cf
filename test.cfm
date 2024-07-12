<cfscript>

    writeDump(var=application, label="application");
    // writeDump(var=session, label="session");
    // writeDump(var=application.mappings, label="application");

    Selenium = new Selenium( expandPath("./SeleniumLibs") );
    ChromeService = Selenium.ChromeDriverService().createDefaultService();
    ChromeService.start();
    ChromeOptions = Selenium.ChromeOptions().init();

    ChromeOptions.setExperimentalOption("prefs", {
        "safebrowsing.enabled": "false",
        "download.prompt_for_download": false,
        "download.directory_upgrade": true,
        "download.default_directory": "C:/Temp",
    });

    // ChromeOptions.addArguments(["--headless=new"]);

    ProxySettings = Selenium.Proxy().init();
    ProxySettings.setProxyType(Selenium.ProxyType.DIRECT);
    ProxySettings.setAutodetect(false);
    ChromeOptions.setProxy(ProxySettings);

    ChromeOptions.setBinary(createObject("java", "java.io.File").init("C:\Temp\Chromium\chrome.exe"));

    // ChromeDriver = Selenium.ChromeDriver().init(ChromeOptions);
    ChromeDriver = Selenium.RemoteWebDriver()
        .builder()
        .addAlternative(ChromeOptions)
        // .address(ChromeService.getUrl())
        .address(createObject("java", "java.net.URL").init("http://localhost:9515"))
        // .withDriverService(ChromeService)
        .build();

    // ChromeDriver.manage().window().setSize(Selenium.Dimension(1920,1080));

    writeOutput("<p>Driver created</p>");
    cfflush();

    // ChromeDriver.manage().window().fullScreen();
    ChromeDriver.manage().window().maximize();
    ChromeDriver.navigate().to("https://denhaag-cvs-tst.outsystemsenterprise.com/DenHaagBaseThemeReactive_Th/LoginOutSystems");

    ExportButtonLocator = Selenium.By.id("Btn_ExportNaarExcel");
    LoginButtonLocator = Selenium.By.xpath("//button[.='Inloggen']");
    Found = false;
    Attempts = 10;

    while(!Found)
    {
        if (Attempts == 0) {
            writeOutput("<p>BAD: Didn't land on login page :(</p>");
            writeOutput("<p>#ChromeDriver.getCurrentUrl()#</p>");
            ScreenshotBytes = ChromeDriver.getScreenshotAs(Selenium.ScreenshotOutputType.BYTES);
            fileWrite("C:/Temp/Debug.png", ScreenshotBytes);
            ChromeDriver.quit();
            abort;
        }

        Found = ChromeDriver.findElements(LoginButtonLocator).len() > 0;
        Attempts--;
        sleep(1000);
    }

    writeOutput("<p>On login-page</p>");
    cfflush();

    LoginUsername = "TestAutomation@denhaag.nl";
    LoginPassword = "gatKK[_6@eK!^B&b";

    // writeDump(ChromeDriver.findElement(Selenium.By.id("Input_UsernameVal")));
    // ChromeDriver.quit();
    // abort;

    ChromeDriver.findElement(Selenium.By.id("Input_UsernameVal")).sendKeys([LoginUsername]);
    ChromeDriver.findElement(Selenium.By.id("Input_PasswordVal")).sendKeys([LoginPassword]);
    ChromeDriver.findElement(LoginButtonLocator).click();

    ScreenshotBytes = ChromeDriver.getScreenshotAs(Selenium.ScreenshotOutputType.BYTES);
    fileWrite("C:/Temp/Debug.png", ScreenshotBytes);

    Found = false;
    Attempts = 10;

    while(!Found)
    {
        if (Attempts == 0) {
            writeOutput("<p>BAD: Didn't land on dashboard after login :(</p>");
            writeOutput("<p>#ChromeDriver.getCurrentUrl()#</p>");
            // ScreenshotBytes = ChromeDriver.getScreenshotAs(Selenium.ScreenshotOutputType.BYTES);
            // fileWrite("C:/Temp/Debug.png", ScreenshotBytes);
            ChromeDriver.quit();
            abort;
        }

        Found = ChromeDriver.findElements(ExportButtonLocator).len() > 0;
        Attempts--;
        sleep(1000);
    }

    writeOutput("<p>Logged in</p>");
    cfflush();

    sleep(5000);
    ChromeDriver.findElement(ExportButtonLocator).click();
</cfscript>