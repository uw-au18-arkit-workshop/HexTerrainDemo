//
//  Coordinates.swift
//  HexTerrainDemo
//
//  Created by Peter Kos on 11/17/18.
//  Copyright © 2018 UW. All rights reserved.
//

import Foundation



protocol CoordinateSystem {
    
}

struct Cartesian: CoordinateSystem {
    var x: Int
    var y: Int
}

struct Axial: CoordinateSystem {
    

}

struct Cube: CoordinateSystem {


}

struct Offset: CoordinateSystem {


}
