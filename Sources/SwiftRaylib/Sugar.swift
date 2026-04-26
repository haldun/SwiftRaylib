import raylib

extension Color {
    /// Build a color from 0–255 components. Alpha defaults to fully opaque.
    init(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: UInt8 = 255) {
        self.init(r: r, g: g, b: b, a: a)
    }

    /// Build a color from a 0xRRGGBB hex literal. Alpha is fully opaque.
    /// Example: `Color(rgb: 0xE65A78)`
    init(rgb: UInt32) {
        precondition(rgb <= 0xFFFFFF, "rgb must be a 24-bit value (0x000000...0xFFFFFF)")
        self.init(
            r: UInt8((rgb >> 16) & 0xFF),
            g: UInt8((rgb >> 8) & 0xFF),
            b: UInt8(rgb & 0xFF),
            a: 255
        )
    }

    /// Build a color from a 0xRRGGBBAA hex literal.
    /// Example: `Color(rgba: 0xE65A78FF)`
    init(rgba: UInt32) {
        self.init(
            r: UInt8((rgba >> 24) & 0xFF),
            g: UInt8((rgba >> 16) & 0xFF),
            b: UInt8((rgba >> 8) & 0xFF),
            a: UInt8(rgba & 0xFF)
        )
    }
}

extension Color {
    static let lightgray = Color(200, 200, 200)
    static let gray = Color(130, 130, 130)
    static let darkgray = Color(80, 80, 80)
    static let yellow = Color(253, 249, 0)
    static let gold = Color(255, 203, 0)
    static let orange = Color(255, 161, 0)
    static let pink = Color(255, 109, 194)
    static let red = Color(230, 41, 55)
    static let maroon = Color(190, 33, 55)
    static let green = Color(0, 228, 48)
    static let lime = Color(0, 158, 47)
    static let darkgreen = Color(0, 117, 44)
    static let skyblue = Color(102, 191, 255)
    static let blue = Color(0, 121, 241)
    static let darkblue = Color(0, 82, 172)
    static let purple = Color(200, 122, 255)
    static let violet = Color(135, 60, 190)
    static let darkpurple = Color(112, 31, 126)
    static let beige = Color(211, 176, 131)
    static let brown = Color(127, 106, 79)
    static let darkbrown = Color(76, 63, 47)
    static let white = Color(255, 255, 255)
    static let black = Color(0, 0, 0)
    static let blank = Color(0, 0, 0, 0)  // transparent
    static let magenta = Color(255, 0, 255)
    static let raywhite = Color(245, 245, 245)
}

extension ConfigFlags {
    init(rawValue: UInt32) {
        self.init(UInt32(rawValue))
    }

    // Window flags
    static let vsyncHint = FLAG_VSYNC_HINT
    static let fullscreenMode = FLAG_FULLSCREEN_MODE
    static let windowResizable = FLAG_WINDOW_RESIZABLE
    static let windowUndecorated = FLAG_WINDOW_UNDECORATED
    static let windowHidden = FLAG_WINDOW_HIDDEN
    static let windowMinimized = FLAG_WINDOW_MINIMIZED
    static let windowMaximized = FLAG_WINDOW_MAXIMIZED
    static let windowUnfocused = FLAG_WINDOW_UNFOCUSED
    static let windowTopmost = FLAG_WINDOW_TOPMOST
    static let windowAlwaysRun = FLAG_WINDOW_ALWAYS_RUN
    static let windowTransparent = FLAG_WINDOW_TRANSPARENT
    static let windowHighdpi = FLAG_WINDOW_HIGHDPI
    static let windowMousePassthrough = FLAG_WINDOW_MOUSE_PASSTHROUGH
    static let borderlessWindowedMode = FLAG_BORDERLESS_WINDOWED_MODE

    // Rendering flags
    static let msaa4xHint = FLAG_MSAA_4X_HINT
    static let interlacedHint = FLAG_INTERLACED_HINT
}

/// Overload that accepts the Swifty OptionSet form.
func SetConfigFlags(_ flags: ConfigFlags) {
    SetConfigFlags(flags.rawValue)
}

func IsKeyDown(_ key: KeyboardKey) -> Bool { IsKeyDown(Int32(key.rawValue)) }

func IsKeyUp(_ key: KeyboardKey) -> Bool { IsKeyUp(Int32(key.rawValue)) }

func IsKeyPressed(_ key: KeyboardKey) -> Bool { IsKeyPressed(Int32(key.rawValue)) }

func IsKeyReleased(_ key: KeyboardKey) -> Bool { IsKeyReleased(Int32(key.rawValue)) }

func IsKeyPressedRepeat(_ key: KeyboardKey) -> Bool {
    IsKeyPressedRepeat(Int32(key.rawValue))
}

func IsMouseButtonDown(_ button: MouseButton) -> Bool {
    IsMouseButtonDown(Int32(button.rawValue))
}

func IsMouseButtonUp(_ button: MouseButton) -> Bool {
    IsMouseButtonUp(Int32(button.rawValue))
}

func IsMouseButtonPressed(_ button: MouseButton) -> Bool {
    IsMouseButtonPressed(Int32(button.rawValue))
}

func IsMouseButtonReleased(_ button: MouseButton) -> Bool {
    IsMouseButtonReleased(Int32(button.rawValue))
}

extension Vector2 {
    static let zero = Vector2(x: 0, y: 0)

    static func + (a: Vector2, b: Vector2) -> Vector2 { Vector2(x: a.x + b.x, y: a.y + b.y) }
    static func - (a: Vector2, b: Vector2) -> Vector2 { Vector2(x: a.x - b.x, y: a.y - b.y) }
    static func * (v: Vector2, s: Float) -> Vector2 { Vector2(x: v.x * s, y: v.y * s) }
    static func * (s: Float, v: Vector2) -> Vector2 { v * s }
    static func / (v: Vector2, s: Float) -> Vector2 { Vector2(x: v.x / s, y: v.y / s) }
    static prefix func - (v: Vector2) -> Vector2 { Vector2(x: -v.x, y: -v.y) }

    static func += (a: inout Vector2, b: Vector2) { a = a + b }
    static func -= (a: inout Vector2, b: Vector2) { a = a - b }
    static func *= (v: inout Vector2, s: Float) { v = v * s }

    var lengthSquared: Float { x * x + y * y }
    var length: Float { sqrtf(lengthSquared) }
    var normalized: Vector2 { length > 0 ? self / length : .zero }

    func dot(_ other: Vector2) -> Float { x * other.x + y * other.y }
}

extension Vector3 {
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.init(x: x, y: y, z: z)
    }

    static let zero = Vector3(0, 0, 0)
    static let one = Vector3(1, 1, 1)
    static let unitX = Vector3(1, 0, 0)
    static let unitY = Vector3(0, 1, 0)
    static let unitZ = Vector3(0, 0, 1)

    static func + (a: Vector3, b: Vector3) -> Vector3 {
        Vector3(a.x + b.x, a.y + b.y, a.z + b.z)
    }
    static func - (a: Vector3, b: Vector3) -> Vector3 {
        Vector3(a.x - b.x, a.y - b.y, a.z - b.z)
    }
    static func * (v: Vector3, s: Float) -> Vector3 { Vector3(v.x * s, v.y * s, v.z * s) }
    static func * (s: Float, v: Vector3) -> Vector3 { v * s }
    static func / (v: Vector3, s: Float) -> Vector3 { Vector3(v.x / s, v.y / s, v.z / s) }
    static prefix func - (v: Vector3) -> Vector3 { Vector3(-v.x, -v.y, -v.z) }

    static func += (a: inout Vector3, b: Vector3) { a = a + b }
    static func -= (a: inout Vector3, b: Vector3) { a = a - b }
    static func *= (v: inout Vector3, s: Float) { v = v * s }

    var lengthSquared: Float { x * x + y * y + z * z }
    var length: Float { sqrtf(lengthSquared) }
    var normalized: Vector3 { length > 0 ? self / length : .zero }

    func dot(_ other: Vector3) -> Float { x * other.x + y * other.y + z * other.z }
    func cross(_ other: Vector3) -> Vector3 {
        Vector3(
            y * other.z - z * other.y,
            z * other.x - x * other.z,
            x * other.y - y * other.x
        )
    }
}

extension Vector4 {
    init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.init(x: x, y: y, z: z, w: w)
    }

    static let zero = Vector4(0, 0, 0, 0)
    static let one = Vector4(1, 1, 1, 1)

    static func + (a: Vector4, b: Vector4) -> Vector4 {
        Vector4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w)
    }
    static func - (a: Vector4, b: Vector4) -> Vector4 {
        Vector4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w)
    }
    static func * (v: Vector4, s: Float) -> Vector4 {
        Vector4(v.x * s, v.y * s, v.z * s, v.w * s)
    }
    static func * (s: Float, v: Vector4) -> Vector4 { v * s }
    static func / (v: Vector4, s: Float) -> Vector4 {
        Vector4(v.x / s, v.y / s, v.z / s, v.w / s)
    }
    static prefix func - (v: Vector4) -> Vector4 { Vector4(-v.x, -v.y, -v.z, -v.w) }

    static func += (a: inout Vector4, b: Vector4) { a = a + b }
    static func -= (a: inout Vector4, b: Vector4) { a = a - b }
    static func *= (v: inout Vector4, s: Float) { v = v * s }

    var lengthSquared: Float { x * x + y * y + z * z + w * w }
    var length: Float { sqrtf(lengthSquared) }
    var normalized: Vector4 { length > 0 ? self / length : .zero }

    func dot(_ other: Vector4) -> Float {
        x * other.x + y * other.y + z * other.z + w * other.w
    }
}

extension Quaternion {
    /// Identity quaternion (no rotation): (0, 0, 0, 1)
    static let identity = Quaternion(0, 0, 0, 1)

    /// Build a rotation quaternion from an axis and angle (in radians).
    /// Convenience wrapper over raylib's `QuaternionFromAxisAngle`.
    init(axis: Vector3, angle: Float) {
        self = QuaternionFromAxisAngle(axis, angle)
    }

    /// Build a rotation quaternion from Euler angles (in radians).
    init(pitch: Float, yaw: Float, roll: Float) {
        self = QuaternionFromEuler(pitch, yaw, roll)
    }
}

extension Matrix {
    static let identity = MatrixIdentity()

    /// Matrix multiplication. Note raylib's convention is column-major,
    /// so `a * b` applies `b` first, then `a`.
    static func * (a: Matrix, b: Matrix) -> Matrix {
        MatrixMultiply(a, b)
    }

    /// Transform a Vector3 by this matrix.
    static func * (m: Matrix, v: Vector3) -> Vector3 {
        Vector3Transform(v, m)
    }
}

extension Rectangle {
    /// Positional init: x, y, width, height.
    init(_ x: Float, _ y: Float, _ width: Float, _ height: Float) {
        self.init(x: x, y: y, width: width, height: height)
    }

    /// Build a rectangle from a top-left position and a size.
    init(at position: Vector2, size: Vector2) {
        self.init(x: position.x, y: position.y, width: size.x, height: size.y)
    }

    /// Build a rectangle centered on a point with the given size.
    init(center: Vector2, size: Vector2) {
        self.init(
            x: center.x - size.x / 2,
            y: center.y - size.y / 2,
            width: size.x,
            height: size.y
        )
    }

    static let zero = Rectangle(0, 0, 0, 0)

    var position: Vector2 {
        get { Vector2(x: x, y: y) }
        set {
            x = newValue.x
            y = newValue.y
        }
    }

    var size: Vector2 {
        get { Vector2(x: width, y: height) }
        set {
            width = newValue.x
            height = newValue.y
        }
    }

    var center: Vector2 {
        get { Vector2(x: x + width / 2, y: y + height / 2) }
        set {
            x = newValue.x - width / 2
            y = newValue.y - height / 2
        }
    }

    var minX: Float { x }
    var maxX: Float { x + width }
    var minY: Float { y }
    var maxY: Float { y + height }

    /// True if the rectangle contains the given point.
    func contains(_ point: Vector2) -> Bool {
        point.x >= x && point.x <= x + width && point.y >= y && point.y <= y + height
    }
}
