# ChessScout

A convenient chess study app for the iOS platform, utilising gamified revision quizzes to help memorise opening theory.

It is designed predominantly for users who have existing chess knowledge but wish to enhance their expertise,
concentrating on displaying specialised opening information for revision and learning.

All version control and commit history for **ChessScout** can be found at this [GitHub repository link](https://github.com/TianLangHin/ChessScout).

This application is mainly built for the iPhone 16, but is also usable on the iPad Air as well.

## Core Features

* Exploration and visualisation of various chess openings
* Access to the latest chess opening statistics from the Lichess database
* Opening revision games using up-to-date chess theory
* Saving favourite openings locally

## Dependencies

* Swift/SwiftUI 5.9 and iOS 17+ language features
* `ChessKit` Swift package
* Lichess Opening Explorer API (the reference documentation can be found [here](https://lichess.org/api))
* Opening Name Data pulled from the `chess-openings` GitHub repository belonging to `lichess-org`
  (the repository can be found [here](https://github.com/lichess-org/chess-openings))

## Minimum Deployment

The minimum deployment is iOS 18.1.

## Object-Oriented Concepts

Object-oriented concepts are used to encapsulate and abstract complex pieces of logic.
Specifically, a class is made to represent each different type of model in the app (stored in the `Model` folder),
as well as each ViewModel to manage the context of a particular View UI (all of which are stored in the `ViewModel` folder).

The management of complex tasks within the app is achieved mainly through composition of classes and structs. Specifically, 
* All `ViewModel` instances contain an instance of the appropriate `Model` as a property, along with other context-specific information.
  An example of this is the `ChessboardViewModel` which contains the mutable property `model` which is a `Chessboard` instance.
  Through composition, the state can be managed to maintain its validity at all times through any UI interaction.
* The generic `IdWrapper<Inner>` structure wraps the `Inner` data via composition so that each instance conforms to the `Identifiable` protocol,
  enabling the efficient display of multiple instances of these items in a `List` UI element.

## Protocol-Oriented Design

To ensure consistent behaviour across the **ChessScout** application, several custom protocols were developed such that various classes can conform to it.
Some protocols are implemented by more than one class or struct within the codebase,
since they perform similar conceptual operations despite being in distinct concrete scenarios.
They are all named with the suffix "-able", ensuring consistency with existing protocols in Swift and alluding to an external behaviour conformance.

These protocols are defined in the `Protocol` folder within the `Model` folder, and are listed as follows.

* `APIFetchable`: Classes conforming to this protocol requires the ability to `fetch` information from external sources (files or API),
  making a query based off of some parameter (associated type `Parameter`) and potentially returning some data (associated type `FetchedData`).
  The data returned is `nil` if the external call failed.
* `Navigable`: Structs conforming to this protocol must also be a SwiftUI View, since this protocol requires that other Views can manipulate
  its state and UI updates when it is used as a child view.
  It is specifically designed to define external behaviour of a complicated but frequently reused View
  which can display animations when updated by some transition (associated type `GameState`)
  and can have its internal state directly set to some value (associated type `Transition`).
* `Routable`: Classes conforming to this protocol define programmatic navigation within the app,
  by mapping an instance of the associated type `Indicator` to a certain kind of View (associated type `PossibleState`)
  that should be navigated to and displayed.
* `Saveable`: Classes or structs conforming to this protocol implement functionality that directly stores the data (or some representation of it)
  into some persistent storage, as well as a way to load information directly from the global persistent storage via a static method.

## User Interface Design

The user interfaces present in the app are designed mainly for deployment on the iPhone, and to be used in portrait mode.
This is evident by the placement of opening statistics being *under* the main chessboard UI element in the `OpeningExplorerView` page,
rather than being next to it which would suit landscape orientations.

Aside from layout, other UI design decisions were made to make navigation and usage of the app as intuitive as possible.

* With the exception of Views where it is obvious that all UI elements are clickable (`OpeningSelectorView`),
  button UI elements are all coloured in blue to allude to its functionality as a navigation link to the user.
* All forward moves being made in a chessboard (`ChessboardView`) are animated, so that the user understands that the transition being made
  is not abrupt, but a valid method of transition within the context of the app (chess study).
* In the `GameSelectView`, if the user is unable to proceed in starting a game (due to invalid game starting scenarios),
  the user will be prompted with an error message in red, signalling an unsuccessful transition or unsatisfied requirement.
  When proceeding in the game is possible, such messages are turned green with appropriate text changes as a visual signaller of success to the user.

## Error Handling

Error handling is used all throughout the application,
since many operations require fetching information from external sources
such as external APIs or GitHub repositories as data banks.
Another source of potential invalid states or transitions is the complicated logic of a chess game (handled by the imported `ChessKit` package),
since it is always possible to create an instance of an invalid move for a given position.

Error handling most often manifests as the use of `Optional` types in the returns of certain function calls,
with `nil` values denoting that the process has failed. This is either the result of an external data fetch failing,
or the parameters to the function being invalid for the current context.
This is paired with the use of `guard let` or `if let`, such that certain crucial operations like UI updates only occur
if the process was successful. This ensures that the overall app state remains valid, preventing crashes or other glitches.

## Testing and Debugging

Since **ChessScout** combines the usage of a Swift package with multiple external APIs, there are many instances where some processes
can easily fail and invalid transitions can be made. To ensure the app can still work reasonably, some unit test procedures are implemented
in the `ChessScoutTests` folder to verify that the wrapper classes in **ChessScout** built around complex concepts
work correctly in common situations and known valid interaction sequences.

In particular, the custom `Chessboard` model and the API fetching resources (`LichessOpeningFetcher` and `OpeningNamesFetcher`)
are tested with several methods each in `ChessScoutTests.swift`.
They are tested with somewhat common but also potentially convoluted and non-trivial scenarios to emulate typical app usage from an end user.
