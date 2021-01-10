#  ScoreFive

## Setup

ScoreFive is comprised of several xcodeprojects convieniently packaged as a workspace.
Vendor code does not use a package manager, and copied and compiled in separate targets.
Before opening the `.xcworkspace` and building the app, complete the following steps to setup the tooling

0. Install homebrew.

More information is available at [https://brew.sh](https://brew.sh)

1. ScoreFive uses Needle for type-safe, scoped dependency injection. Install the needle code generation tools from uber/needle through homebrew:

```
$ brew install needle
```

2. ScoreFive uses Mockolo for Mock Generation. Install the mockolo code generation tools from uber/mockolo through homebrew. (This step is optional if you don't want to run the unit tests.)

```
$ brew install mockolo
```

3. ScoreFive uses SwiftFormat for source code style consistency. Install nicklockwood/swiftformat through homebrew.

```
$ brew install swiftformat
```

4. Rather than interfacing with the aformentioned tools directly. ScoreFive provides a built-in command line application to that knows the right arguments and paths to use. Build this tool by running the shell script. The executable will become available in the repo root.

```
$ cd path/to/repo
$ sh build_tooling.sh
```

4. Generate the dependency graph:

```
$ cd path/to/repo
$ ./sfcli gen deps
```

5. Generate the object mocks (this step is optional if you aren't going to run the unit tests)

```
$ cd path/to/repo
$ ./sfcli gen mocks
```

After these steps have been taken, you can open `ScoreFive.xcworkspace` and run the app.
