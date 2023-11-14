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
                                                    textColorDarkMode: "#5ec169",
                                                    backgroundColor: "#ffffff",
                                                    backgroundColorDarkMode: "#000000",
                                                    iconSize: 76,
                                                    iconBorderWidth: 2.3,
                                                    iconMarginX: 18,
                                                    iconMarginBottom: 8,
                                                    iconNotViewedBorderColor: "#fd7c50",
                                                    iconNotViewedBorderColorDarkMode: "#fd7c50",
                                                    iconViewedBorderColor: "#fdc2a1",
                                                    iconViewedBorderColorDarkMode: "#fdc2a1",
                                                    iconViewedTransparency: 1.0,
                                                    iconAnimatedLoaderColor: "#5ec169",
                                                    iconPlaceholderColor: "#d6d6d6",
                                                    iconPlaceholderColorDarkMode: "#d6d6d6",
                                                    iconDisplayFormatSquare: false,
                                                    labelWidth: 76,
                                                    pinColor: "#fd7c50",
                                                    pinColorDarkMode: "#fd7c50",
                                                    closeIconColor: "#5ec169")

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
                                                           cornerRadius: 5)

        sdk.configuration().stories.setProductsCard(fontName: "Museo")

        sdk.configuration().stories.setPromocodeCard(productBannerFontName: "Museo",
                                                     productTitleFontSize: 16.0,
                                                     productTitleTextColor: "#5ec169",
                                                     productTitleTextColorDarkMode: "#5ec169",
                                                     productBannerOldPriceSectionFontColor: "#5ec169",
                                                     productBannerPriceSectionFontColor: "#5ec169",
                                                     productBannerPriceSectionBackgroundColor: "#ffffff",
                                                     productBannerPromocodeSectionFontColor: "#ff0000",
                                                     productBannerPromocodeSectionBackgroundColor: "#5ec169",
                                                     productBannerDiscountSectionBackgroundColor: "#5ec169",
                                                     productBannerPromocodeCopyToClipboardMessage: "Copied")

        //SDK Recommendations Widget settings
        sdk.configuration().recommendations.setWidgetBlock(widgetFontName: "Museo",
                                                           widgetBackgroundColor: "#ffffff",
                                                           widgetBackgroundColorDarkMode: "#000000",
                                                           widgetCellBackgroundColor: "#ffffff",
                                                           widgetCellBackgroundColorDarkMode: "#000000",
                                                           widgetBorderWidth: 1,
                                                           widgetBorderColor: "#c3c3c3",
                                                           widgetBorderColorDarkMode: "#c3c3c3",
                                                           widgetBorderTransparent: 0.4,
                                                           widgetCornerRadius: 9,
                                                           widgetStarsColor: "#ff9500",
                                                           widgetAddToCartButtonText: "Add to cart",
                                                           widgetRemoveFromCartButtonText: "Remove from cart",
                                                           widgetAddToCartButtonFontSize: 17,
                                                           widgetRemoveFromCartButtonFontSize: 14,
                                                           widgetCartButtonTextColor: "#ffffff",
                                                           widgetCartButtonTextColorDarkMode: "#ffffff",
                                                           widgetCartButtonBackgroundColor: "#000000",
                                                           widgetCartButtonBackgroundColorDarkMode: "#ffffff",
                                                           widgetCartButtonNeedOpenWebUrl: false,
                                                           widgetFavoritesIconColor: "#000000",
                                                           widgetFavoritesIconColorDarkMode: "#ffffff",
                                                           widgetPreloadIndicatorColor: "#ffffff")
        
        
        //SDK Stories block autoreload settings
        sdk.configuration().stories.useSdkOldInitialization = false //default false - will be deprecated November 14
        sdk.configuration().stories.storiesSlideReloadManually = false //default false - autoreload enabled
        sdk.configuration().stories.storiesSlideReloadTimeoutInterval = 10 //default infinity
        sdk.configuration().stories.storiesSlideReloadIndicatorDisabled = false //default false - indicator enabled
        sdk.configuration().stories.storiesSlideReloadIndicatorBackgroundColor = "#ffffff"
        sdk.configuration().stories.storiesSlideReloadIndicatorSize = 76.0
        sdk.configuration().stories.storiesSlideReloadIndicatorBorderLineWidth = 3
        sdk.configuration().stories.storiesSlideReloadIndicatorSegmentCount = 9
        sdk.configuration().stories.storiesSlideReloadIndicatorAnimationDuration = 1
        sdk.configuration().stories.storiesSlideReloadIndicatorRotationDuration = 17

        //SDK Alert popup connection settings
        sdk.configuration().stories.storiesSlideReloadPopupMessageError = "Failed to retrieve data. Please check your connection and try again."
        sdk.configuration().stories.storiesSlideReloadPopupMessageFontSize = 17.0
        sdk.configuration().stories.storiesSlideReloadPopupMessageFontWeight = .medium
        sdk.configuration().stories.storiesSlideReloadPopupMessageDisplayTime = 4
        sdk.configuration().stories.storiesSlideReloadPopupPositionY = 120 //default constant
        
        //SDK Stories block text label characters wrapping settings
        sdk.configuration().stories.storiesBlockNumberOfLines = 2
        sdk.configuration().stories.storiesBlockCharWrapping = false
        sdk.configuration().stories.storiesBlockCharCountWrap = 15
    
Enjoy!
