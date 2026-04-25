# SwiftRaylib

A minimal Swift + [raylib](https://www.raylib.com/) starter for macOS.

## Requirements

- macOS 13 or later
- Swift 6.3+ (Xcode 16 or recent Swift toolchain)

## Start a new project from this template

Use `clone.sh` to spawn a fresh, renamed copy of this project:

```sh
./clone.sh Asteroids              # creates ../Asteroids/
./clone.sh Pong ~/Projects        # creates ~/Projects/Pong/
```

The new folder is a standalone project with its own git history, ready to run:

```sh
cd ../Asteroids
swift run                         # window opens with a bouncing box
```

raylib is statically linked into the final binary, so the built executable is self-contained.

Your `SwiftRaylib` template stays untouched and reusable.

## License

This project's code is released under the MIT license (see `LICENSE`).

It bundles a prebuilt copy of [raylib](https://github.com/raysan5/raylib) 6.0 in `raylib-6.0_macos/`, distributed under the zlib license. See `raylib-6.0_macos/LICENSE` for details.
