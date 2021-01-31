#  ScoreFive

## Setup

ScoreFive is comprised of several xcodeprojects convieniently packaged as a workspace.
Vendor code does not use a package manager, and copied and compiled in separate targets.
Before opening the `.xcworkspace` and building the app, complete the following steps to setup the tooling

0. Install homebrew.

More information is available at [https://brew.sh](https://brew.sh)

1. ScoreFive uses [Needle](https://www.github.com/uber/needle) for type-safe, scoped dependency injection. Install the needle code generation tools from uber/needle through homebrew:

```
$ brew install needle
```

2. ScoreFive uses [Mockolo](https://www.github.com/uber/mockolo) for efficient Swift mock generation. Install the mockolo code generation tools from uber/mockolo through homebrew. (This step is optional if you don't want to run the unit tests.)

```
$ brew install mockolo
```

3. Rather than interfacing with the aformentioned tools directly. ScoreFive provides a built-in command line utility called `sftool` to that knows the right arguments and paths to use. The source code for this tool is included in the repo. Build the tool and move it to the root directory.

```
$ cd path/to/repo
$ swift build --package-path Tooling/sftool --configuration release
$ cp Tooling/sftool/.build/release/sftool sftool
```

4. Generate the dependency graph:

```
$ cd path/to/repo
$ ./sftool gen deps
```


After these steps have been taken, you can open `ScoreFive.xcworkspace` and run the app.

## Development

This project is hosted at phab.vsanthanam.com and manage using phacility tools. The copy on github is a mirror. To contribute, visit [the hosted phabricator install](https://phab.vsanthanam.com) and request a user account.

### Running the Unit Tests

1. Generate the object mocks 

```
$ cd path/to/repo
$ ./sftool gen mocks
```

2. Open `ScoreFive.xcworkspae` and run the unit tests from within Xcode.

### Running SwiftFormat

You can run switformat on the repo with the correct rules and files using `sftool`:

1. Install `swiftformat` via homebrew

```
$ brew install swiftformat
```

2. Run `swiftformat` via `sftool`

```
$ cd path/to/repo
$ ./sftool format
```

### Running SwiftLint

You can run switlint on the repo with the correct rules and files using `sftool`:

1. Install `swiftlint` via homebrew

```
$ brew install swiftformat
```

2. Run `swiftlint` via `sftool`


```
$ cd path/to/repo
$ ./sftool lint
```
