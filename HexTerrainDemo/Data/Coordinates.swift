//
//  Coordinates.swift
//  HexTerrainDemo
//
//  Created by Peter Kos on 11/17/18.
//  Copyright © 2018 UW. All rights reserved.
//

import Foundation

/** Stores precomputed values used for converting between coordinate systems
	These values are precomputed to avoid needing to execute potentially
	expensive computations during coordinate system conversions.
*/
struct CoordinateStatics {
	static let SQRT3: Float = sqrt(3.0);
}

protocol CoordinateSystem {
	// Converts from the current coordinate system to the Axial Hex Coordinate system
	func toAxial() -> Axial
	// Converts from the current coordinate system to the Cartesian Coordinate system
	func toCartesian() -> Cartesian
	// Converts from the current coordinate system to the Cube Hex Coordinate system
	func toCube() -> Cube
	// Converts from the current coordinate system to the Offset Hex Coordinate system
	func toOffset() -> Offset
}

// Algorithms sourced from Amit Patel's Red Blob Games:
// https://www.redblobgames.com/grids/hexagons/#conversions

/// Struct used to represent a coordinate in Axial Hex Coordinates
struct Axial: CoordinateSystem {
	var x = 0
	var y = 0
	
	func toAxial() -> Axial {
		return self
	}
	func toCartesian() -> Cartesian {
		var retVal = Cartesian()
		retVal.x = TerrainStatics.SCALE_FACTOR *
			(CoordinateStatics.SQRT3 * Float(x) + CoordinateStatics.SQRT3 / 2.0 * Float(y))
		retVal.y = TerrainStatics.SCALE_FACTOR * (3.0 / 2.0 * Float(y))
		return retVal
	}
	func toCube() -> Cube {
		var retVal = Cube()
		retVal.x = x;
		retVal.z = y;
		retVal.y = -x - y;
		return retVal;
	}
	func toOffset() -> Offset {
		return self.toCube().toOffset();
	}
}

/** Struct used to represent a coordinate in Cartesian Coordinates
	Unlike the three other coordinate systems, this coordinate system is
	used to represent positions in the SceneKit coordinate system, rather
	than representing a hex tile's coordinates.
	- Note: The Cartesian Hex Coordinate System only uses the X and Y axes
*/
struct Cartesian: CoordinateSystem {
	var x: Float = 0.0
	var y: Float = 0.0
	
	func toAxial() -> Axial {
		var retVal = Axial()
		retVal.x = Int(round(((CoordinateStatics.SQRT3 / 3.0 * x) - (1.0 / 3.0) * y) / TerrainStatics.SCALE_FACTOR))
		retVal.y = Int(round((2.0 / 3.0 * y) / TerrainStatics.SCALE_FACTOR))
		return retVal
	}
	func toCartesian() -> Cartesian {
		return self
	}
	func toCube() -> Cube {
		return self.toAxial().toCube()
	}
	func toOffset() -> Offset {
		return self.toAxial().toOffset()
	}
}

///Struct used to represent a coordinate in Cube Hex Coordinates
/// - Note: The Cube Hex Coordinate System uses the X, Y, and Z axes
struct Cube: CoordinateSystem {
	var x = 0
	var y = 0
	var z = 0
	
	func toAxial() -> Axial {
		var retVal = Axial()
		retVal.x = x
		retVal.y = z
		return retVal
	}
	func toCartesian() -> Cartesian {
		return self.toAxial().toCartesian()
	}
	func toCube() -> Cube {
		return self
	}
	func toOffset() -> Offset {
		var retVal = Offset()
		retVal.x = x + Int(round(Float(z - (z & 1)) / 2.0))
		retVal.y = z
		return retVal
	}
}

/// Struct used to represent a coordinate in Offset Hex Coordinates
/// - Note: The Offset Hex Coordinate System only uses the X and Y axes
struct Offset: CoordinateSystem {
	var x = 0
	var y = 0
	
	func toAxial() -> Axial {
		return self.toCube().toAxial()
	}
	func toCartesian() -> Cartesian {
		var retVal = Cartesian()
		retVal.x = TerrainStatics.SCALE_FACTOR * CoordinateStatics.SQRT3 * (Float(x) + 0.5 * Float((y & 1)))
		retVal.y = TerrainStatics.SCALE_FACTOR * 3.0 / 2.0 * Float(y)
		return retVal
	}
	func toCube() -> Cube {
		var retVal = Cube()
		retVal.x = x - Int(round(Float((y - (y & 1))) / 2.0))
		retVal.z = y
		retVal.y = -x - retVal.z
		return retVal
	}
	func toOffset() -> Offset {
		return self
	}
}
