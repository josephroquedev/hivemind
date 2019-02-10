//
//  Unit+Hopper.swift
//  HiveMind
//
//  Created by Joseph Roque on 2019-02-08.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import Foundation

extension Unit {
	func movesAsHopper(in state: GameState) -> Set<Movement> {
		guard self.canMove(as: .hopper, in: state) else { return [] }
		guard let position = state.units[self], position != .inHand else { return [] }

		return Set(position.adjacent().compactMap { adjacentPosition in
			guard state.stacks[adjacentPosition] != nil else { return nil }

			// Determine direction to extend jump in
			let difference = adjacentPosition.subtracting(position)
			var targetPosition = adjacentPosition

			// Extend in direction until an empty space is found
			while state.stacks[targetPosition] != nil {
				targetPosition = targetPosition.adding(difference)
			}

			return .move(unit: self, to: targetPosition)
		})
	}
}