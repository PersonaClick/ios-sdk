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

    // SDK Configure Default Settings
    sdk.configuration().stories.registerFont(fileName: "Museo900", fileExtension: "otf")
    sdk.configuration().stories.setStoriesBlock(fontName: "Museo", fontSize: 13.0, textColor: "#1A900C", backgroundColor: "#D5F5E3")
    sdk.configuration().stories.setSlideDefaultButton(fontName: "Museo", fontSize: 17.0, textColor: "#A3E4D7", backgroundColor: "#900C3F")
    sdk.configuration().stories.setSlideProductsButton(fontName: "Museo", fontSize: 19.0, textColor: "#7D3C98", backgroundColor: "#7CFC00")
    sdk.configuration().stories.setProductsCard(fontName: "Museo")
    
Enjoy!
