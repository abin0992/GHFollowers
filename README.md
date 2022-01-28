[![YourActionName Actions Status](https://github.com/abin0992/GHFollowers/workflows/CI/badge.svg)](https://github.com/abin0992/GHFollowers/actions) [![Build Status](https://travis-ci.com/abin0992/GHFollowers.svg?branch=CI-integration)](https://travis-ci.com/abin0992/GHFollowers)
# GHFollowers
GHFollowers is an iOS app that allows the user to search for github users.
## MVVM-C architecture is used
- Combine framework is used for binding between view and viewmodel.
- Navigation is handled by using Coordinators
## Project developed with product-oriented approach 
This Project only has the UI and business logic for this project. The network API calls and models are managed in a different apple framework project - [FeedEngine](https://github.com/abin0992/FeedEngine). This approach is the primary step in app modularisation which helps for the separation of responsibilities. The advantages of this approach are
- Its easy to make a separate iPad app /tvOS app / watchOS app / macOS app since this framework can be integrated and many functions and business logic becomes readily available to use.
- Ease to add new features and maintainability
- Serparation of responsibilities

#### Project Features

  - Seach for user, see list of users and user info screen
  - Adds pagination for loading user or follower list
  - Makes use of new APIs like [UICollectionViewDiffableDataSource](https://developer.apple.com/documentation/uikit/uicollectionviewdiffabledatasource), [Result type](https://developer.apple.com/documentation/swift/result)
  - Integrated UI tests
  - Integrated Unit tests 
  - Code coverage of **89.7**
  - Supports dark mode
  - Uses [Swiftlint](https://github.com/realm/SwiftLint)
  - Continous Integration implemented using [Travis](https://travis-ci.com/github/abin0992/GHFollowers), [Github Actions](https://github.com/abin0992/GHFollowers/actions)

### Installation
The project comes ready to test. 
Clone and run on your machine. No additional steps required

  ```bash
  git clone https://github.com/abin0992/GHFollowers.git
  ```
  GHFollowers do not have any 3rd party dependencies! The only dependency is our internal framework - [FeedEngine](https://github.com/abin0992/FeedEngine). Its integrated through Swift Package Manager. 
### Screenshots
##### Dark Mode
![alt text](https://github.com/abin0992/GHFollowers/blob/CI-integration/.screenshots/darkMode.png?raw=true)

##### Light Mode
![alt text](https://github.com/abin0992/GHFollowers/blob/CI-integration/.screenshots/lightMode.png?raw=true)

### Todos

 - Write MORE Tests
  
### License

MIT

----

