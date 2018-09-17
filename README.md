# MonzoSwift

MonzoSwift is a framework for interacting with the Monzo API. The project uses Travis-CI for testing:

[![Build Status](https://travis-ci.com/jaylees14/MonzoSwift.svg?token=DHJ1zWJnxL4gE1gKLsuC&branch=master)](https://travis-ci.com/jaylees14/MonzoSwift)



## Installation

The project uses SwiftPM as it's main method of distribution. Simply add a dependency in your `Package.swift` file:
```swift
...
dependencies: [
    .package(url: "https://github.com/jaylees14/MonzoSwift.git", from: "1.0.0"),
],
...
```


## Usage

To start, access the shared Monzo class instance and set your access token

```swift
let monzo = Monzo.instance
monzo.setAccessToken("$TOKEN")
```

#### Response

Each of the API responses is returned is of type `Either`. This is similar to the [Haskell](https://hackage.haskell.org/package/base-4.11.1.0/docs/Data-Either.html) style implementation, with the constructors renamed as `Error` and `Result`.  The example below shows two alternative ways of dealing with this response:

##### Using `.handle`

```swift
monzo.getAllAccounts { (result) in
	  result.handle( { (error) in 
        // Deal with an error if it occurs
	  }, { (accounts) in
   		  // Otherwise deal with the successful accounts
    })
}   
```

##### Switching over the result

```swift
monzo.getAllAccounts { (response) in
	  switch response {
      case .error(let error):
       	  // Deal with the error
      case .result(let accounts):
       	  // Otherwise deal with the successful accounts
	  }
}
```



## API Methods

### Validation of Auth Token

Validate your existing auth token

```swift
public func validateAccessToken(callback: @escaping (_ result: Either<Error, Bool>) -> Void )
```

### Accounts

Request all of the accounts associated with your access token

```swift
public func getAllAccounts(callback: @escaping (_ accounts: Either<Error, MonzoUser>) -> Void)
```

### Balance

Request the balance for a Monzo Account

``` swift 
public func getBalance(for account: MonzoAccount, callback: @escaping (_ balance: Either<Error, MonzoBalance>) -> Void)
```

### Transactions
Request all of the transactions associated with a Monzo account

```swift
public func getTransactions(for account: MonzoAccount, callback: @escaping (_ transactions: Either<Error, [MonzoTransaction]>) -> Void)
```

Request a specific transaction id for your associated access token

```swift
public func getTransaction(for id: String, callback: @escaping ((Either<Error, MonzoTransaction>) -> Void))
```


