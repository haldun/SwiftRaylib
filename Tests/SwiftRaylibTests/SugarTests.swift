import Testing
import raylib

@testable import SwiftRaylib

// MARK: - Color initializers

@Suite("Color initializers")
struct ColorInitTests {

    @Test func componentInitSetsAllChannels() {
        let c = Color(0x12, 0x34, 0x56, 0x78)
        #expect(c.r == 0x12 && c.g == 0x34 && c.b == 0x56 && c.a == 0x78)
    }

    @Test func componentInitDefaultsAlphaToOpaque() {
        let c = Color(10, 20, 30)
        #expect(c.r == 10 && c.g == 20 && c.b == 30 && c.a == 255)
    }

    @Test func rgbInitUnpacksChannels() {
        let c = Color(rgb: 0xE65A78)
        #expect(c.r == 0xE6 && c.g == 0x5A && c.b == 0x78 && c.a == 255)
    }

    @Test func rgbInitHandlesBlackAndWhite() {
        let black = Color(rgb: 0x000000)
        #expect(black.r == 0 && black.g == 0 && black.b == 0 && black.a == 255)
        let white = Color(rgb: 0xFFFFFF)
        #expect(white.r == 255 && white.g == 255 && white.b == 255 && white.a == 255)
    }

    @Test(arguments: [
        (UInt32(0xFF0000), UInt8(255), UInt8(0), UInt8(0)),
        (UInt32(0x00FF00), UInt8(0), UInt8(255), UInt8(0)),
        (UInt32(0x0000FF), UInt8(0), UInt8(0), UInt8(255)),
    ])
    func rgbInitIsolatesChannels(hex: UInt32, r: UInt8, g: UInt8, b: UInt8) {
        let c = Color(rgb: hex)
        #expect(c.r == r && c.g == g && c.b == b && c.a == 255)
    }

    @Test func rgbaInitUnpacksChannels() {
        let c = Color(rgba: 0xE65A_78FF)
        #expect(c.r == 0xE6 && c.g == 0x5A && c.b == 0x78 && c.a == 0xFF)
    }

    /// Regression: original implementation misclassified RGBA values with
    /// a zero red channel as RGB.
    @Test func rgbaInitHandlesZeroRedChannel() {
        let c = Color(rgba: 0x00FF_00FF)
        #expect(c.r == 0x00 && c.g == 0xFF && c.b == 0x00 && c.a == 0xFF)
    }

    @Test func rgbaInitHandlesZeroAlpha() {
        let c = Color(rgba: 0xAABB_CC00)
        #expect(c.r == 0xAA && c.g == 0xBB && c.b == 0xCC && c.a == 0x00)
    }

    @Test func rgbaInitHandlesAllZeroAndAllMax() {
        let zero = Color(rgba: 0x0000_0000)
        #expect(zero.r == 0 && zero.g == 0 && zero.b == 0 && zero.a == 0)
        let max = Color(rgba: 0xFFFF_FFFF)
        #expect(max.r == 255 && max.g == 255 && max.b == 255 && max.a == 255)
    }

    @Test func rgbAndRgbaAgreeWhenAlphaOpaque() {
        let viaRgb = Color(rgb: 0xE65A78)
        let viaRgba = Color(rgba: 0xE65A_78FF)
        #expect(
            viaRgb.r == viaRgba.r && viaRgb.g == viaRgba.g
                && viaRgb.b == viaRgba.b && viaRgb.a == viaRgba.a)
    }
}

// MARK: - Color constants

@Suite("Color constants")
struct ColorConstantTests {

    @Test func raywhiteIsCorrect() {
        let c = Color.raywhite
        #expect(c.r == 245 && c.g == 245 && c.b == 245 && c.a == 255)
    }

    @Test func blankIsFullyTransparent() {
        #expect(Color.blank.a == 0)
    }

    @Test func blackAndWhiteAreCorrect() {
        #expect(
            Color.black.r == 0 && Color.black.g == 0 && Color.black.b == 0 && Color.black.a == 255)
        #expect(
            Color.white.r == 255 && Color.white.g == 255 && Color.white.b == 255
                && Color.white.a == 255)
    }

    @Test func raylibPaletteValues() {
        #expect(Color.red.r == 230 && Color.red.g == 41 && Color.red.b == 55)
        #expect(Color.green.r == 0 && Color.green.g == 228 && Color.green.b == 48)
        #expect(Color.blue.r == 0 && Color.blue.g == 121 && Color.blue.b == 241)
        #expect(Color.yellow.r == 253 && Color.yellow.g == 249 && Color.yellow.b == 0)
    }

    @Test func allConstantsAreOpaqueExceptBlank() {
        let opaqueColors: [Color] = [
            .lightgray, .gray, .darkgray, .yellow, .gold, .orange, .pink,
            .red, .maroon, .green, .lime, .darkgreen, .skyblue, .blue,
            .darkblue, .purple, .violet, .darkpurple, .beige, .brown,
            .darkbrown, .white, .black, .magenta, .raywhite,
        ]
        for c in opaqueColors {
            #expect(c.a == 255)
        }
    }
}

// MARK: - ConfigFlags OptionSet

@Suite("ConfigFlags OptionSet")
struct ConfigFlagsTests {

    @Test func arrayLiteralCombinesWithBitwiseOr() {
        let combined: ConfigFlags = [.vsyncHint, .msaa4xHint]
        #expect(
            combined.rawValue == ConfigFlags.vsyncHint.rawValue | ConfigFlags.msaa4xHint.rawValue)
    }

    @Test func contains() {
        let combined: ConfigFlags = [.vsyncHint, .msaa4xHint]
        #expect(combined.contains(.vsyncHint))
        #expect(combined.contains(.msaa4xHint))
        #expect(!combined.contains(.windowHidden))
    }

    @Test func insertAndRemove() {
        var f: ConfigFlags = [.vsyncHint]
        f.insert(.windowResizable)
        #expect(f.contains(.windowResizable))
        #expect(f.contains(.vsyncHint))
        f.remove(.vsyncHint)
        #expect(!f.contains(.vsyncHint))
        #expect(f.contains(.windowResizable))
    }

    @Test func unionAndIntersection() {
        let a: ConfigFlags = [.vsyncHint, .msaa4xHint]
        let b: ConfigFlags = [.msaa4xHint, .windowResizable]
        let u = a.union(b)
        let i = a.intersection(b)
        #expect(u.contains(.vsyncHint) && u.contains(.msaa4xHint) && u.contains(.windowResizable))
        #expect(i.contains(.msaa4xHint))
        #expect(!i.contains(.vsyncHint) && !i.contains(.windowResizable))
    }

    @Test func emptySetHasZeroRawValue() {
        let empty: ConfigFlags = []
        #expect(empty.rawValue == 0)
    }
}

// MARK: - Vector2

@Suite("Vector2")
struct Vector2Tests {

    @Test func zeroConstant() {
        #expect(Vector2.zero.x == 0 && Vector2.zero.y == 0)
    }

    @Test func addition() {
        let r = Vector2(x: 1, y: 2) + Vector2(x: 3, y: 4)
        #expect(r.x == 4 && r.y == 6)
    }

    @Test func subtraction() {
        let r = Vector2(x: 5, y: 7) - Vector2(x: 2, y: 3)
        #expect(r.x == 3 && r.y == 4)
    }

    @Test func scalarMultiplyBothSides() {
        let v = Vector2(x: 2, y: 3)
        let a = v * 2
        let b = 2 * v
        #expect(a.x == 4 && a.y == 6)
        #expect(b.x == 4 && b.y == 6)
    }

    @Test func scalarDivide() {
        let r = Vector2(x: 6, y: 8) / 2
        #expect(r.x == 3 && r.y == 4)
    }

    @Test func negation() {
        let r = -Vector2(x: 1, y: -2)
        #expect(r.x == -1 && r.y == 2)
    }

    @Test func compoundAssignment() {
        var v = Vector2(x: 1, y: 1)
        v += Vector2(x: 2, y: 3)
        #expect(v.x == 3 && v.y == 4)
        v -= Vector2(x: 1, y: 1)
        #expect(v.x == 2 && v.y == 3)
        v *= 2
        #expect(v.x == 4 && v.y == 6)
    }

    @Test func lengthSquaredAndLength() {
        let v = Vector2(x: 3, y: 4)
        #expect(v.lengthSquared == 25)
        #expect(v.length == 5)  // sqrt(25) is exact in Float
    }

    @Test func normalizedHasUnitLength() {
        let v = Vector2(x: 3, y: 4).normalized
        #expect(abs(v.length - 1) < 1e-5)
        #expect(abs(v.x - 0.6) < 1e-5 && abs(v.y - 0.8) < 1e-5)
    }

    @Test func normalizedZeroVectorReturnsZero() {
        let v = Vector2.zero.normalized
        #expect(v.x == 0 && v.y == 0)
    }

    @Test func dotProduct() {
        let a = Vector2(x: 1, y: 2)
        let b = Vector2(x: 3, y: 4)
        #expect(a.dot(b) == 11)  // 1*3 + 2*4
    }

    @Test func dotOfPerpendicularsIsZero() {
        let a = Vector2(x: 1, y: 0)
        let b = Vector2(x: 0, y: 1)
        #expect(a.dot(b) == 0)
    }
}

// MARK: - Vector3

@Suite("Vector3")
struct Vector3Tests {

    @Test func positionalInit() {
        let v = Vector3(1, 2, 3)
        #expect(v.x == 1 && v.y == 2 && v.z == 3)
    }

    @Test func constants() {
        #expect(Vector3.zero.x == 0 && Vector3.zero.y == 0 && Vector3.zero.z == 0)
        #expect(Vector3.one.x == 1 && Vector3.one.y == 1 && Vector3.one.z == 1)
        #expect(Vector3.unitX.x == 1 && Vector3.unitX.y == 0 && Vector3.unitX.z == 0)
        #expect(Vector3.unitY.x == 0 && Vector3.unitY.y == 1 && Vector3.unitY.z == 0)
        #expect(Vector3.unitZ.x == 0 && Vector3.unitZ.y == 0 && Vector3.unitZ.z == 1)
    }

    @Test func addition() {
        let r = Vector3(1, 2, 3) + Vector3(4, 5, 6)
        #expect(r.x == 5 && r.y == 7 && r.z == 9)
    }

    @Test func subtraction() {
        let r = Vector3(4, 5, 6) - Vector3(1, 2, 3)
        #expect(r.x == 3 && r.y == 3 && r.z == 3)
    }

    @Test func scalarMultiplyBothSides() {
        let v = Vector3(1, 2, 3)
        let a = v * 2
        let b = 2 * v
        #expect(a.x == 2 && a.y == 4 && a.z == 6)
        #expect(b.x == 2 && b.y == 4 && b.z == 6)
    }

    @Test func scalarDivide() {
        let r = Vector3(2, 4, 6) / 2
        #expect(r.x == 1 && r.y == 2 && r.z == 3)
    }

    @Test func negation() {
        let r = -Vector3(1, -2, 3)
        #expect(r.x == -1 && r.y == 2 && r.z == -3)
    }

    @Test func compoundAssignment() {
        var v = Vector3(1, 1, 1)
        v += Vector3(1, 2, 3)
        #expect(v.x == 2 && v.y == 3 && v.z == 4)
        v -= Vector3(1, 1, 1)
        #expect(v.x == 1 && v.y == 2 && v.z == 3)
        v *= 2
        #expect(v.x == 2 && v.y == 4 && v.z == 6)
    }

    @Test func lengthOfThreeFourTwelve() {
        // 3-4-12 is a Pythagorean quadruple: sqrt(9+16+144) = 13
        let v = Vector3(3, 4, 12)
        #expect(v.lengthSquared == 169)
        #expect(v.length == 13)
    }

    @Test func normalizedHasUnitLength() {
        let v = Vector3(3, 4, 12).normalized
        #expect(abs(v.length - 1) < 1e-5)
    }

    @Test func normalizedZeroIsZero() {
        let v = Vector3.zero.normalized
        #expect(v.x == 0 && v.y == 0 && v.z == 0)
    }

    @Test func dotProduct() {
        let a = Vector3(1, 2, 3)
        let b = Vector3(4, 5, 6)
        #expect(a.dot(b) == 32)  // 4+10+18
    }

    @Test func crossProductOfUnitAxes() {
        // Right-hand rule: x × y = z, y × z = x, z × x = y
        let xy = Vector3.unitX.cross(.unitY)
        #expect(xy.x == 0 && xy.y == 0 && xy.z == 1)
        let yz = Vector3.unitY.cross(.unitZ)
        #expect(yz.x == 1 && yz.y == 0 && yz.z == 0)
        let zx = Vector3.unitZ.cross(.unitX)
        #expect(zx.x == 0 && zx.y == 1 && zx.z == 0)
    }

    @Test func crossProductIsAntiCommutative() {
        let a = Vector3(1, 2, 3)
        let b = Vector3(4, 5, 6)
        let ab = a.cross(b)
        let ba = b.cross(a)
        #expect(ab.x == -ba.x && ab.y == -ba.y && ab.z == -ba.z)
    }
}

// MARK: - Vector4

@Suite("Vector4")
struct Vector4Tests {

    @Test func positionalInit() {
        let v = Vector4(1, 2, 3, 4)
        #expect(v.x == 1 && v.y == 2 && v.z == 3 && v.w == 4)
    }

    @Test func constants() {
        #expect(
            Vector4.zero.x == 0 && Vector4.zero.y == 0 && Vector4.zero.z == 0 && Vector4.zero.w == 0
        )
        #expect(
            Vector4.one.x == 1 && Vector4.one.y == 1 && Vector4.one.z == 1 && Vector4.one.w == 1)
    }

    @Test func addition() {
        let r = Vector4(1, 2, 3, 4) + Vector4(5, 6, 7, 8)
        #expect(r.x == 6 && r.y == 8 && r.z == 10 && r.w == 12)
    }

    @Test func subtraction() {
        let r = Vector4(5, 6, 7, 8) - Vector4(1, 2, 3, 4)
        #expect(r.x == 4 && r.y == 4 && r.z == 4 && r.w == 4)
    }

    @Test func scalarMultiplyBothSides() {
        let v = Vector4(1, 2, 3, 4)
        let a = v * 2
        let b = 2 * v
        #expect(a.x == 2 && a.y == 4 && a.z == 6 && a.w == 8)
        #expect(b.x == 2 && b.y == 4 && b.z == 6 && b.w == 8)
    }

    @Test func scalarDivide() {
        let r = Vector4(2, 4, 6, 8) / 2
        #expect(r.x == 1 && r.y == 2 && r.z == 3 && r.w == 4)
    }

    @Test func negation() {
        let r = -Vector4(1, -2, 3, -4)
        #expect(r.x == -1 && r.y == 2 && r.z == -3 && r.w == 4)
    }

    @Test func compoundAssignment() {
        var v = Vector4(1, 1, 1, 1)
        v += Vector4(1, 2, 3, 4)
        #expect(v.x == 2 && v.y == 3 && v.z == 4 && v.w == 5)
        v -= Vector4(1, 1, 1, 1)
        #expect(v.x == 1 && v.y == 2 && v.z == 3 && v.w == 4)
        v *= 2
        #expect(v.x == 2 && v.y == 4 && v.z == 6 && v.w == 8)
    }

    @Test func lengthSquaredAndLength() {
        let v = Vector4(1, 2, 2, 4)  // sqrt(1+4+4+16) = 5
        #expect(v.lengthSquared == 25)
        #expect(v.length == 5)
    }

    @Test func normalizedHasUnitLength() {
        let v = Vector4(1, 2, 2, 4).normalized
        #expect(abs(v.length - 1) < 1e-5)
    }

    @Test func normalizedZeroIsZero() {
        let v = Vector4.zero.normalized
        #expect(v.x == 0 && v.y == 0 && v.z == 0 && v.w == 0)
    }

    @Test func dotProduct() {
        let a = Vector4(1, 2, 3, 4)
        let b = Vector4(5, 6, 7, 8)
        #expect(a.dot(b) == 70)  // 5+12+21+32
    }
}

// MARK: - Quaternion

@Suite("Quaternion")
struct QuaternionTests {

    @Test func identityIsZeroZeroZeroOne() {
        let q = Quaternion.identity
        #expect(q.x == 0 && q.y == 0 && q.z == 0 && q.w == 1)
    }

    @Test func axisAngleZeroAngleIsIdentity() {
        let q = Quaternion(axis: .unitY, angle: 0)
        // cos(0) = 1, sin(0) = 0 → (0, 0, 0, 1)
        #expect(
            abs(q.x) < 1e-5 && abs(q.y) < 1e-5
                && abs(q.z) < 1e-5 && abs(q.w - 1) < 1e-5)
    }

    @Test func axisAnglePiAroundY() {
        // Rotation by π around Y → (0, ±1, 0, 0)
        let q = Quaternion(axis: .unitY, angle: .pi)
        #expect(abs(q.x) < 1e-5)
        #expect(abs(abs(q.y) - 1) < 1e-5)
        #expect(abs(q.z) < 1e-5)
        #expect(abs(q.w) < 1e-4)
    }

    @Test func eulerZeroIsIdentity() {
        let q = Quaternion(pitch: 0, yaw: 0, roll: 0)
        #expect(
            abs(q.x) < 1e-5 && abs(q.y) < 1e-5
                && abs(q.z) < 1e-5 && abs(q.w - 1) < 1e-5)
    }
}

// MARK: - Matrix

@Suite("Matrix")
struct MatrixTests {

    @Test func identityHasOnesOnDiagonal() {
        let m = Matrix.identity
        #expect(m.m0 == 1 && m.m5 == 1 && m.m10 == 1 && m.m15 == 1)
        #expect(m.m1 == 0 && m.m2 == 0 && m.m3 == 0)
        #expect(m.m4 == 0 && m.m6 == 0 && m.m7 == 0)
        #expect(m.m8 == 0 && m.m9 == 0 && m.m11 == 0)
        #expect(m.m12 == 0 && m.m13 == 0 && m.m14 == 0)
    }

    @Test func identityTimesIdentityIsIdentity() {
        let r = Matrix.identity * Matrix.identity
        #expect(r.m0 == 1 && r.m5 == 1 && r.m10 == 1 && r.m15 == 1)
    }

    @Test func identityTimesVectorIsVector() {
        let v = Vector3(1, 2, 3)
        let r = Matrix.identity * v
        #expect(r.x == 1 && r.y == 2 && r.z == 3)
    }
}

// MARK: - Rectangle

@Suite("Rectangle")
struct RectangleTests {

    @Test func positionalInit() {
        let r = Rectangle(1, 2, 3, 4)
        #expect(r.x == 1 && r.y == 2 && r.width == 3 && r.height == 4)
    }

    @Test func atPositionSizeInit() {
        let r = Rectangle(at: Vector2(x: 5, y: 6), size: Vector2(x: 10, y: 20))
        #expect(r.x == 5 && r.y == 6 && r.width == 10 && r.height == 20)
    }

    @Test func centerSizeInit() {
        let r = Rectangle(center: Vector2(x: 10, y: 10), size: Vector2(x: 4, y: 6))
        #expect(r.x == 8 && r.y == 7 && r.width == 4 && r.height == 6)
    }

    @Test func zeroConstant() {
        let r = Rectangle.zero
        #expect(r.x == 0 && r.y == 0 && r.width == 0 && r.height == 0)
    }

    @Test func positionGetter() {
        let r = Rectangle(1, 2, 3, 4)
        #expect(r.position.x == 1 && r.position.y == 2)
    }

    @Test func positionSetterMovesRect() {
        var r = Rectangle(0, 0, 10, 20)
        r.position = Vector2(x: 5, y: 7)
        #expect(r.x == 5 && r.y == 7)
        // Size unchanged
        #expect(r.width == 10 && r.height == 20)
    }

    @Test func sizeGetter() {
        let r = Rectangle(1, 2, 3, 4)
        #expect(r.size.x == 3 && r.size.y == 4)
    }

    @Test func sizeSetterResizesRect() {
        var r = Rectangle(1, 2, 3, 4)
        r.size = Vector2(x: 30, y: 40)
        #expect(r.width == 30 && r.height == 40)
        // Position unchanged
        #expect(r.x == 1 && r.y == 2)
    }

    @Test func centerGetter() {
        let r = Rectangle(0, 0, 10, 20)
        #expect(r.center.x == 5 && r.center.y == 10)
    }

    @Test func centerSetterMovesRectKeepingSize() {
        var r = Rectangle(0, 0, 10, 20)
        r.center = Vector2(x: 100, y: 100)
        // After centering at (100, 100): top-left = (95, 90)
        #expect(r.x == 95 && r.y == 90)
        #expect(r.width == 10 && r.height == 20)
    }

    @Test func minMaxAccessors() {
        let r = Rectangle(10, 20, 30, 40)
        #expect(r.minX == 10 && r.maxX == 40)
        #expect(r.minY == 20 && r.maxY == 60)
    }

    @Test func containsPointInside() {
        let r = Rectangle(0, 0, 10, 10)
        #expect(r.contains(Vector2(x: 5, y: 5)))
    }

    @Test func containsPointOutside() {
        let r = Rectangle(0, 0, 10, 10)
        #expect(!r.contains(Vector2(x: 11, y: 5)))
        #expect(!r.contains(Vector2(x: 5, y: 11)))
        #expect(!r.contains(Vector2(x: -1, y: 5)))
        #expect(!r.contains(Vector2(x: 5, y: -1)))
    }

    @Test func containsIsInclusiveOnEdges() {
        // Documenting current behavior: contains is inclusive on all edges,
        // matching raylib's CheckCollisionPointRec convention.
        let r = Rectangle(0, 0, 10, 10)
        #expect(r.contains(Vector2(x: 0, y: 0)))  // top-left corner
        #expect(r.contains(Vector2(x: 10, y: 10)))  // bottom-right corner
        #expect(r.contains(Vector2(x: 0, y: 5)))  // left edge
        #expect(r.contains(Vector2(x: 10, y: 5)))  // right edge
    }
}
