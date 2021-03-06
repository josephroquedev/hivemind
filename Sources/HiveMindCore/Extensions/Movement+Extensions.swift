//
//  Movement+Extensions.swift
//  HiveMindCore
//
//  Created by Joseph Roque on 2019-03-03.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation
import HiveEngine

extension Movement {
	/// Convert to a JSON string
	func json() -> String {
		let encoder = JSONEncoder()
		guard let data = try? encoder.encode(self) else { return "" }
		return String(data: data, encoding: .utf8) ?? ""
	}
}
