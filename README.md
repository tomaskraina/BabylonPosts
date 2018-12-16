# Babylon Health Test Project

## Specification

This demo project was done as part of [the BabylonHealth recruitment process](https://github.com/Babylonpartners/iOS-Interview-Demo). The complete specification for the project can be found on the GitHub repo [here](https://github.com/Babylonpartners/iOS-Interview-Demo/blob/master/demo.md#1-the-babylon-demo-project). 

## Requirements

- iOS 12.0+
- Xcode 10.0+
- Swift 4.2
- Carthage 0.31.1+

## QuickStart

### How to run the project

This project uses [Carthage](https://github.com/Carthage/Carthage) as a dependency manager of choice. The dependencies are not included in the project so you need open this folder in Terminal and run the following command:

```sh
carthage bootstrap --platform ios
```

## Architecture

This project follows MVVM-C architecture. [RxSwift](https://github.com/ReactiveX/RxSwift), a popular reactive-programing framework is used for binding views with view models. View controllers communicate its navigation events to the flow coordinators by using the delegate pattern.

When it comes to data flows, there are two main pipelines: writing and reading pipeline. As you can see in `DataProvider` and `RealmPersistantStorage`, the writing pipeline consists of an API request, parsing, mapping to Realm objects, and persistence into `Realm`. The reading pipeline consists of monitoring changes in Realm and mapping Realm objects into particular structs.

Dependency injection is used as much as possible in the app. All view models are implemented against its protocols, as well as all the services and the networking layer is abstracted by protocols. It allows easy testability and mocking. Moreover, protocol composition is used for better dependency injection inspired by [Krzysztof Zabłocki's blog post](http://merowing.info/2017/04/using-protocol-compositon-for-dependency-injection/). For more info see `Dependencies.swift` file.

## Project structure

The whole project is structured in scenes where each scene represents one screen in the app. Each scene consists of one `*ViewController`, `*ViewModel`, and a `*.storyboard` file.

All the other files are structured in their particular category, e.g. `Model`, `Networking`, `Services`, etc.

## Testing

The project has some unit and a few integration tests implemented. The tests are written using the standard `XCTest` framework and are mainly focused on JSON parsing, persistence, and networking (`ApiClientIntegrationTests`). You can run the tests by simply pressing `CMD+U` in Xcode.

Unfortunately, due to time limitations, I have not written as many tests as I would like. Some classes, like `*ViewController`, `PostDetailViewModel`, or `DataProvider` are not covered by tests at all. Another example where to improve test coverage is `PostListViewModel`, where only one basic test covers a fraction of its functionality. 

## Further development

Due to time constraints, some code is not as clean and simple as it should be. Without a doubt, there's still a room for improvement. Apart from better test coverage, one important thing to mention is the lack of pagination. At the moment the `JSONPlaceholderApiClient` requests all posts at once. It is implemented on the assumption that the number of posts returned by the backend is reasonable and therefore, pagination was not in the scope of this project.  

Moreover, TODOs were left in the code with comments what and how should be improved in the future.

# Contact

- Tom Kraina
- me@tomkraina.com
- tomkraina.com
