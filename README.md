# KOMvvmSample

KOMvvmSample is a proposition of mvvm architecture, that can be used in your own project. Example is based on [GiantBomb](https://www.giantbomb.com/api) api.

This version of mvvm is partially inspired by clean architecture written by Uncle Bob. The key element is to separate logic from the UI. Logic is the most stable element of the app and the only necessary elements are injected into the UI in the form of protocols. UI knows nothing about the current implementation of the Logic, which makes it easier to test the app and change the UI without doing any changes in the Logic. So the logic is closed to unwanted changes and opened for future extensions. This architecture simplifies presentation layer by using event streaming by RxSwift framework. 

<p align="center">
<img src="ReadmeImages/GamesList.png" width="250">
<img src="ReadmeImages/GamesCollection.png" width="250">

</p>
<p align="center">
<img src="ReadmeImages/GamesFilters.png" width="250">
<img src="ReadmeImages/GameDetails.png" width="250">
</p>

## Goals

General goal is to make code readable and easy to understand without overwhelm architecture.

1. Keep style and conventions of Swift.
2. Use only the key frameworks.
3. Logical placement of files due to purpose.
4. Make logic and ui separately, simplify the connections between them. But don't make the hell from interfaces connections, that makes everything hard to find.
5. Make it easy to tests.

## Installation

1. Download all sources
2. Install all pods
3. Grab api key from here: https://www.giantbomb.com/api
4. Insert your apiKey in: 
    Logic -> AppComponents -> Private -> AppSettings -> Api -> key
    
## Requirements
    
* iOS 11+
* Xcode 10.0+
* Swift 4.2+
    
##  Is the Mvvm ideal? 
    
No there isn’t an ideal architecture, each of them has advantages and disadvantages, in wrong hands all of them can be a shit. Massive files or thousand files with 100 lines of code with bidirectional interface connections can be a fu***** nightmare, where you can’t find anything or it will be very hard. Searching ideal architecture is like searching the holy grail, you can’t find it 🙂 but you can try it and make your architecture better over the time. 

The main advantages of mvvm are: 

1. Logic and views are separated.
2. Views can be easily replaced. 
3. It is easy to test business logic and output variables from ViewModels.
4. Presentation behavior will be handled by RxSwift or some types of bindings. So you don’t need to create it by yourself.
    
## Architecture parts

App is separated to two different targets that makes a natural border between the two aspects: Logic and UI. 

### Logic
This component needs to be the most stable part of the app so it should be independent from the UI and the most frameworks. 

1. AppComponents - Main components used to create app scene and manage transitions between them.
    1. Private - Part not available outside Logic. All stuff connected with the application settings or navigation over the scenes.
    2. Public - Types that should be used to create app.
        1. BaseAppCoordinator - Class that creates scenes and manages transitions between them, it should be overridden by the app. App needs to register own view controllers that will be connected to the logic.
        2. ViewControllerProtocols - Basic set of funcs that need to be implemented in all ViewControllers.
        3. ViewModelProtocol - Basic set of funcs that need to be implemented in all ViewModels.
2. Extensions - Extensions of common used types like String.
3. Logger
4. Services - Services used in the app to do some specific actions. Each of them should have only one responsibility like: managing the data files, managing the api connections etc. They are managed by IoC container that is stored in AppCoordinator. UseCases, scenes can have the references to the services by dependency injection in the initialization in ViewModelRegister.
5. Scenes - Logic part of scene. Each part needs to have:
    1. ViewModelRegister - Registers the viewModel with passed use cases.
    2. ViewModel - Facade, connection layer between input / output data and use cases. View models can be used to change current scene.
    3. ViewModelProtocol - Public viewModel abstraction layer that will be passed to registered scene viewController.
    4. UseCase - Separated logic for specific case.
        
### UI
That component should be flexible to client needs :) 

1. Components - Buttons, labels and different kinds of views, used in code by different scenes. Creating the defaults types of views are key to create easily application themes mechanism. All defaults views should use theme colors and fonts from "Resources" part of architecture.
2. Extensions - Extensions of common used UI types like UIView, UIImage etc.
3. Scenes - UI part of scene. Each scene should be constructed from:
    1. ViewControllerRegister - Registers the viewController, appropriate viewModel should be resolved from the container and passed to the controller.
    2. ViewController - Controller of scene, that makes available scene logic and some actions to the views by protocol.
    2. ViewControllerProtocol - Logic and list of controller actions that can be used from views in scene.
    3. View - Views that can use logic and some actions from the controller by protocol.
4. Resources - Theme and localizations files. Files can be assigned to the app target to create specific skin per app (white label).
5. App  - Components that initialize the application.
    1. AppCoordinator - Inherited from baseAppCoordinator. It registers its own viewController types, and creates default view hierarchy.
    2. AppDelegate - Initializes AppCoordinator.

## FAQ

1. Why RxSwift? - RxSwifts handles all connections between data and controls on the screen. So you don’t need to create own presentation behavior. RxSwift has a lot of filtering methods and really simple sequence mechanisms with the possibility of changing threads between part of sequence. 
2. Why you don’t use SnapKit? - In this project the one of goals is to use only the keys frameworks. So I wrote a simple extension to manage constraints.
3. Why you don't generate views for controllers? - Building views manually is more flexible than by generator, because you can better separate views from each other. You aren't depending on the controls outlets. All constraints and properties are directly set in the views code in once place, so you have the better control over them. It's easier to resolve conflicts between code versions instead of xib files. Of course there are some disadvantages of this idea, it take more time to create views and if you want to have different layout on the different screens sizes you must manually change constraints depending on the traits collections instead of use size classes in xib files.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
