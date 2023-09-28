# Stories
## Setup story view
### Step 1 - Add story view to your screen.
#### Xib integration
1 - Create view in xib editor. Change class to 'StoriesView'. 
2 - Connect to your viewController.swift. 

    @IBOutlet private weak var storiesBackView: StoriesView!
    
3 - Initialize with SDK and VC StoryView module
    
    storiesBackView.configure(sdk: SDK, mainVC: self)
    
#### Code integration
0 - Import Library
    
    import PersonaClick

1 - Create view in .swift.

    var storiesView = StoriesView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    view.addSubview(storiesView)

2 - Initialize with SDK and VC StoryView module
    
    storiesView.configure(sdk: SDK, mainVC: self)
    
3 - Sdk Configuration Settings

    //SDK Configuration init Font first
    sdk.configuration().stories.registerFont(fileName: "Museo900", fileExtension: FontExtension.otf.rawValue) //or ttf!

    //SDK Configuration settings
    sdk.configuration().stories.setStoriesBlock(fontName: "Museo",
                                                fontSize: 15.0,
                                                textColor: "#5ec169",
                                                textColorDarkMode: "#ffffff",
                                                backgroundColor: "#ffffff",
                                                backgroundColorDarkMode: "#000000",
                                                iconSize: 76,
                                                iconBorderWidth: 5.3,
                                                iconMarginX: 18,
                                                iconMarginBottom: 8,
                                                iconNotViewedBorderColor: "#fd7c50",
                                                iconNotViewedBorderColorDarkMode: "#fd7c50",
                                                iconViewedBorderColor: "#fdc2a1",
                                                iconViewedBorderColorDarkMode: "#fdc2a1",
                                                iconViewedTransparency: 1.0,
                                                iconPreloaderColor: "#5ec169",
                                                iconPlaceholderColor: "#d6d6d6",
                                                iconPlaceholderColorDarkMode: "#d6d6d6",
                                                labelWidth: 76, //default equal iconSize
                                                pinColor: "#fd7c50",
                                                pinColorDarkMode: "#fd7c50",
                                                closeIconColor: "#ffffff")

    sdk.configuration().stories.setSlideDefaultButton(fontName: "Museo",
                                                      fontSize: 17.0,
                                                      textColor: "#ffffff",
                                                      backgroundColor: "#5ec169",
                                                      textColorDarkMode: "#000000",
                                                      backgroundColorDarkMode: "#ffffff",
                                                      cornerRadius: 5)

    sdk.configuration().stories.setSlideProductsButton(fontName: "Museo",
                                                       fontSize: 17.0,
                                                       textColor: "#ffffff",
                                                       backgroundColor: "#5ec169",
                                                       textColorDarkMode: "#000000",
                                                       backgroundColorDarkMode: "#ffffff",
                                                 s      cornerRadius: 5)

    sdk.configuration().stories.setProductsCard(fontName: "Museo")
    
    sdk.configuration().stories.setPromocodeCard(productTitleFontName: "Museo",
                                                     productTitleFontSize: 19.0,
                                                     productTitleTextColor: "#5ec169",
                                                     productTitleTextColorDarkMode: "#5ec169",
                                                     productBannerPriceSectionFontColor: "#d6d6d6",
                                                     productBannerPromocodeSectionFontColor: "#5ec169",
                                                     productBannerPriceSectionBackgroundColor: "#fd7c50",
                                                     productBannerPromocodeSectionBackgroundColor: "#17aadf",
                                                     discountSectionBackgroundColor: "#ea1717",
                                                     productBannerDefaultMessage: "Copied")
        
    //SDK Stories block text label characters wrapping settings
    sdk.configuration().stories.storiesBlockNumberOfLines = 2
    sdk.configuration().stories.storiesBlockCharWrapping = false
    sdk.configuration().stories.storiesBlockCharCountWrap = 10
    
Enjoy!
