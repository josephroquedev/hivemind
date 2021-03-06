//
//  BasicEvaluation.swift
//  HiveMindCore
//
//  Created by Joseph Roque on 2019-03-27.
//  Copyright © 2019 Joseph Roque. All rights reserved.
//

import HiveEngine

struct BasicEvaluator: Evaluator {
	func eval(state: GameState, with support: GameStateSupport) -> Int {
		let opponent = state.currentPlayer.next

		let playerQueen: HiveEngine.Unit
		let opponentQueen: HiveEngine.Unit
		switch state.currentPlayer {
		case .white:
			playerQueen = support.whiteQueen
			opponentQueen = support.blackQueen
		case .black:
			playerQueen = support.blackQueen
			opponentQueen = support.whiteQueen
		}

		// Look for lose condition and set to min priority
		let playerQueenSidesRemaining = state.exposedSides(of: playerQueen)
		if playerQueenSidesRemaining == 0 {
			return Int.min
		}

		// Look for win condition and set to max priority
		let opponentQueenSidesRemaining = state.exposedSides(of: opponentQueen)
		if opponentQueenSidesRemaining == 0 {
			return Int.max
		}

		// Don't let the opponent shut you out
		if state.availableMoves.count == 0 {
			return Int.min + 1
		}

		// Evaluate the board based on the number of pieces available and moveable
		var value = 0
		state.unitsInPlay[state.currentPlayer]!.forEach {
			value += eval(unit: $0.key, in: state, with: support)
		}

		state.unitsInPlay[opponent]!.forEach {
			value -= eval(unit: $0.key, in: state, with: support)
		}

		return value + 100 * (6 - opponentQueenSidesRemaining)
	}

	func eval(movement: Movement, in state: GameState, with support: GameStateSupport) -> Int {
		switch movement {
		case .move(let unit, _):
			return 1_000_000 + eval(unit: unit, in: state, with: support)
		case .place(let unit, _):
			return 500_000 + eval(unit: unit, in: state, with: support)
		case .yoink(_, let unit, _):
			return eval(unit: unit, in: state, with: support)
		case .pass:
			return 0
		}
	}

	func eval(unit: Unit, in state: GameState, with support: GameStateSupport) -> Int {
		// Prevent playing queen on the first move
		if state.move <= 1 && unit.class == .queen { return 0 }

		let isMobile = unit.availableMoves(in: state).count > 0
		return isMobile ? basicValue(of: unit) : basicValue(of: unit) / 2
	}

	private func basicValue(of unit: Unit) -> Int {
		switch unit.class {
		case .ant: return 80
		case .beetle: return 80
		case .hopper: return 40
		case .ladyBug: return 50
		case .mosquito: return 75
		case .pillBug: return 60
		case .queen: return 100
		case .spider: return 20
		}
	}
}
