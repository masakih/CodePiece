//
//  HashtagEntity.swift
//  CodePiece
//
//  Created by Tomohiro Kumagai on H27/10/04.
//  Copyright © 平成27年 EasyStyle G.K. All rights reserved.
//

import Himotoki
import ESTwitter

public struct URLEntity {
	
	public var url: URL
	public var indices: Indices
	public var displayUrl: String
	public var expandedUrl: URL
}

extension URLEntity : Decodable {
	
	public static func decode(e: Extractor) throws -> URLEntity {
		
		return try build(URLEntity.init)(
			
			e <| "url",
			e <| "indices",
			e <| "display_url",
			e <| "expanded_url"
		)
	}
}