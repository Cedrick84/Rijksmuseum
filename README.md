# Rijksmuseum assignment

## Introduction

For this assignment I chose to focus on coming up with a new flavor of the well known clean architecture also known as VIP. What always "bothered" me is that the view controller is the glue for all components. I wanted to keep the view as dumb (and therefore modular) as possible. 

This exploration is made with modularity and testability in mind. For the first screen you can see that all code including it's dependencies is ~100% tested via unit tests.

There is a lot I didn't do, the obvious one being the UI. I decided to focus my efforts on architecture and testing. As this being something "new" the code is not battle tested but should provide for an interesting discussion.

Later on in this document you'll find a write-up about shortcuts I took and other improvements.

All code that you see here is freshly written, with the exception of one extension: `JSONDecoder+KeyPath`.

## Architecture

### Protocols

As mentioned the architecture is an improvised flavor of VIP. Everything is driven by protocols, these can be found in the folder `Architecture Protocols`. Also all other dependencies are protocol driven, even the dependencies provided by Apple as you can see with the use of `NetworkContentRetriever` and `JSONDecoderProtocol` in `APIClientImp` and `ImageDownloaderImp`.

### XCTest

Because all core components are protocols we can easily mock out dependencies. Generic mock classed are provided in the folder `Mock Architecture` and can be used to mock dependencies for all features without creating feature specific mocks.

Let's take `MockViewPresenter` as an example. Because the class is generic over `<Event, State>` we can easily conform this generic class to our specific feature implementation of the `ObjectListViewPresenter` by protocol extension.

```swift
extension MockViewPresenter<ObjectListViewPresenterEvent, PaginatedViewState<[ObjectSummaryCellViewModel]>>: ObjectListViewPresenter {}
```

And later on use it as such.

```swift
let presenter = MockViewPresenter<ObjectListViewPresenterEvent, PaginatedViewState<[ObjectSummaryCellViewModel]>>(eventProcessor:
                .events([{ event in
                    guard case .loading = event else {
                        XCTFail("Expected loading event but got \(event).")
                        return
                    }
                    
                    startLoadingExpectation.fulfill()
                },...]
                , presenterCompletedExpectation))
```

All mock classes need to be initialized with either an array of events or actions, or specifically told that none of these are expected. During initialization this needs to be specified, in case of expected events a `completionExpectation` should be provided. If not all expected events are ran or an unexpected event is ran the tests will fail. This will make writing tests very explicit and secure.

## Improvements

##### Modules

We can clearly separate `view` from `domain` and `data` and put them in separate frameworks together with other dependencies.

##### UI

No effort was put into making this look good, I didn't allocate time to it as I deemed it was less important than the rest for the purpose of this assignment. 

All margins uses in the constraints etc. should clearly defined in a separate file and uniformly used.

##### Strings

Strings, like error messages and labels are hard coded in the app. They should be localized and only references should be used. Preferably compiler safe versions done with tools like `SwiftGen` or other tools. Retrieving them from an external source might also be considered.

The API key is stored in the code. We could either generate it on a by user base, send it from the server, or obfuscate it in code. This last option is not that effective in practice but it increases the threshold by a little bit.

#### Image downloading

The images downloaded in the object list are large, we should fetch these thumbnails using the `Collection Image API` and then get the `z6` object as this contains the image with the smallest size.

#### Caching

Caching of data in the presenters is non existent at the moment and the image cache for the thumbnails is far from smart and never cleared.

#### Testing

This example does not include UI tests or snapshot tests. Al tho they should be very easy to implement by the segregated nature of the views.

#### Unidirectional data flow

Currently most state lives in the interactor, only very local state lives in the views and presenters. We could consider implementing a single source for all application state and inject (a subset of) this into the interactors. The coordinator should be responsible for setting this up.

#### Code quality scans etc

The project doesn't include things like linting tools, dead code scans etc.





