# Diary

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/spydercapriani/diary-log.git", from: "0.1.0"),
```

## Usage

Diary is designed to work out of the box, you can use the pre-configured logger anytime, anywhere:

```swift
Diary.debug("hi")

Diary.error("somethings went wrong")
```

You can quickly create a logger with just a label, it will use the predefined log handler:

```swift
let logger = Logger.diary(label: "some-label")
logger.level = .info

logger.info("hi")
```

### DiaryHandler

The core component that makes this all work is `DiaryHandler`.

The following code snippet shows how to create a `DiaryHandler` and use it to bootstrap the logging system.

```swift
LoggingSystem.bootstrap { label in
    /// ! to create your own `DiaryHandler`, you need the following
    /// - `Modifier`: Maps which / how `Record`s will be handled.
    /// - `Writer`: Describes where `Record`s will be written.
    /// - `errorHandler` <Optional>: Handle any scenarios where records could not be modified / written. 
    let modifier = Modifiers.medium
    let writer = TerminalWriter.stdout
    let errorHandler = { error: Error in
        print("Failed to log: \(error)")
    }

    return DiaryHandler(
        label: label, 
        modifier: modifier, 
        writer: writer, 
        errorHandler: errorHandler
    )
}

let logger = Logger(label: "app")
logger.error("Something went wrong")
```

### Modifier

Modifiers process log records.

A modifier can be a formatter, a filter, a transformer, or a chain of modifiers.

#### Map, CompactMap, TryMap, ThrowMap, Format

You can create a modifier with just a closure.

```swift
let modifier = Modifiers.base
    .map {
        "\($0.entry.level.emoji) \($0.entry.message)\n"
    }
```
// Output:
//
//     🔷 hello

or via keyPaths:
```swift
let modifier = Modifiers.base
    .format(
        \.level.emoji,
        \.message.description,
        separator: " "
    )
    
// Output:
//
//     🔷 hello
```

Or use the built-in modifiers directly.

```swift
Modifiers.short     // default for Diary logger.

// Output:
//
//     🔷 ▶ Attempting to connect to DB
//     ❌ ▶ Could not connect to DB


Modifiers.medium

// Output:
//
//     🔷 ▶ INFO ▶ label ▶ source ▶ Attempting to connect to DB
//     ❌ ▶ ERROR ▶ label ▶ source ▶ Could not connect to DB


Modifiers.long

// Output:
//
//     🔷 ▶ INFO ▶ diary ▶ MyApp ▶ someFunction(_:) ▶ <Line#>
//      Message: Attempting to connect to DB
//      Metadata:
//          --db_destination=example-destination
//          --token=example-token

Modifiers.jsonString

// Output:
//
//  {
//    "file" : "/diary-log/Sources/Playground/main.swift",
//    "function" : "demo(_:)",
//    "label" : "com.playground.json",
//    "level" : "info",
//    "line" : 15,
//    "message" : "OS Log Sample",
//    "source" : "Playground"
//  },
```

#### Filter

You can create a filter modifier with just a closure.

```swift
let filtered = Modifiers.short
    .filter {
        $0.entry.source != "Diary"
    }
    
// logs from `Diary` will not be output.
```

**DSL**

Or use the built-in expressive dsl to create one.

```swift
let filtered = Modifiers.short
    .when(\.entry.source)     // Utilizes Record keypath's
    .equals("Diary")
    .deny
    
let filtered = Modifiers.short
    .when(\.entry.level)
    .greaterThanOrEqualTo(.error)
    .allow
```

#### Concat

Modifiers are chainable, a `modifier` can concatenate another `modifier`.

```swift
let modifier = modifierA + modifierB + modifierC // + modifierD + ...

// or
let modifier = modifierA
    .concat(modifierB)
    .concat(modifierC)
    // .concat(modifierD) ...
```

Diary ships with many commonly used operators.

**Prefix & Suffix**

```swift
let modifier = Modifiers.base
    .format(\.message.description)
    .prefix("🎈 ")
    
// Output:
//
//     🎈 Hello World!


let modifier = Modifiers.base
    .format(\.message.description)
    .suffix(" 🎈")
    
// Output:
//
//     Hello World! 🎈
```

**Encode**
Encodes Encodable records

```swift
let encoded = Modifiers.base
    .encode(using: JSONEncoder())
    
// Or feel free to use the prebuilt modifer
let encoded = Modifers.jsonData
```

**Encrypt**
Encrypts Data records

```swift
let modifier = Modifiers.base
    .encode(using: JSONEncoder())
    .encrypt(using: key, cipher: .ChaChaPoly)
```

**Compress**
Compresses Data records

```swift
let modifier = Modifiers.base
    .encode(using: JSONEncoder())
    .compress(using: .COMPRESSION_LZFSE)
```

#### Append

You may wish to add custom `Context` to records to capture additional data points.

You can use `Context` protocol with `append` to capture and pass the context into the records `Entry.Metadata`.

```swift
private struct CustomContext: Context {
    let date = Date()
    let thread = LogHelper.thread
}

let encodedLogger2 = Logger(label: "com.playground.encoder2") { label in
    struct Custom: Context {
        let info = "Some Custom Info"
        let date = Date()
    }
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
    
    let modifier = Modifiers.base
        .append(Custom())
        .encode(using: encoder)
        .stringValue()
        .commaSeparated
        .newLine
    
    return DiaryHandler(
        label: label,
        modifier: modifier,
        writer: TerminalWriter.stdout,
        errorHandler: errorHandler
    )
}

//  Output
//  {
//    "category" : "example-category",
//    "custom" : {
//      "date" : "2022-01-27T00:23:15Z",
//      "info" : "Some Custom Info"
//    },
//    "file" : "/diary-log/Sources/Playground/main.swift",
//    "function" : "demo(_:)",
//    "label" : "com.playground.encoder2",
//    "level" : "info",
//    "line" : 32,
//    "message" : "OS Log Sample",
//    "source" : "Playground",
//    "subsystem" : "example-subsystem"
//  },
```

### Writer

Writers handle destinations for log records.

#### Built-in Writers

**OSWriter**

Write strings to the underlying `OSLog`.

```swift
let writer = OSWriter()
```

**TerminalWriter**

Write strings to the underlying `TextOutputStream`.

```swift
let writer = TerminalWriter(stream)

let stdout = TerminalWriter.stdout
let stderr = TerminalWriter.stderr
```

**MultiplexLogHandler Support**

Write records to multiple destinations.

```swift
let multiLogger = Logger(
    label: label,
    modifier: modifier,
    TerminalWriter.stdout.eraseToAnyWriter(),   // Due to type handling you must .eraseToAnyWriter()
    OSWriter().eraseToAnyWriter()               // Note that all writers must have the same Output type.
)
```
