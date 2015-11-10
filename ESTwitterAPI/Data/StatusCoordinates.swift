//
//  StatusCoordinates.swift
//  CodePiece
//
//  Created by Tomohiro Kumagai on H27/10/07.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Himotoki

extension Status {
	
	public struct CoordinatesBox {
		
		var coordinates: Coordinate.Item
		var type: String
	}
}

extension Status.CoordinatesBox : Decodable {
	
	public static func decode(e: Extractor) throws -> Status.CoordinatesBox {
		
		return try build(Status.CoordinatesBox.init)(
			
			e <| "coordinates",
			e <| "type"
		)
	}
}