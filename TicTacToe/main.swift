
enum Player : Equatable {
    case o
    case x
}

enum StateGame : Equatable {
    case turnPlayer(Player)
    case gameOver(StateOver)
}

enum StateOver : Equatable {
    case winner(Player)
    case draw
}

enum StateCell : Equatable {
    case move(Player)
    case nothing
}

enum MoveError : Error {
    case moveOutOfBoundary
    case moveAlreadyMade
    case gameAlreadyEnded
}

class TicTacToe {
    
    var board: [[StateCell]] = Array(repeating: Array(repeating: .nothing, count: 3), count: 3)
    var stateGame: StateGame = .turnPlayer(.x)
    let maxPlays = 9
    var counterPlays = 0
    
    func move(_ x: Int,_ y: Int) throws {
        guard x >= 0 && y >= 0 && x <= 2 && y <= 2 else { throw MoveError.moveOutOfBoundary }
        guard case .nothing = board[x][y] else { throw MoveError.moveAlreadyMade }
        switch stateGame {
        case .turnPlayer(let player):
            board[x][y] = .move(player)
            stateGame = validatePlay(player, x, y)
        case .gameOver(_):
            throw MoveError.gameAlreadyEnded
        }
    }
    
    private func validatePlay(_ player: Player,_ x: Int,_ y: Int) -> StateGame {
        counterPlays += 1
        if counterPlays == maxPlays {
            return .gameOver(.draw)
        }
        if .move(player) == board[x][0] && .move(player) == board[x][1] && .move(player) == board[x][2]  {
            return .gameOver(.winner(player))
        }
        if .move(player) == board[0][y] && .move(player) == board[1][y] && .move(player) == board[2][y]  {
            return .gameOver(.winner(player))
        }
        if .move(player) == board[0][0] && .move(player) == board[1][1] && .move(player) == board[2][2]  {
            return .gameOver(.winner(player))
        }
        if .move(player) == board[2][0] && .move(player) == board[1][1] && .move(player) == board[0][2]  {
            return .gameOver(.winner(player))
        }
        return .turnPlayer(player == .o ? .x : .o )
    }

}

let game = TicTacToe()

while case .turnPlayer(let player) = game.stateGame {
    let playerName = player == .o ? "O" : "X"
    print("Enter the position of Player \(playerName): 0,0 ")
    let inputs = readLine()?.split(separator: ",")
    guard let values = inputs, values.count == 2 else {
        print("invalit string")
        continue
    }
    guard let x = Int(values[0]), let y = Int(values[1]) else {
        print("invalit string")
        continue
    }
    do {
        try game.move(x, y)
    } catch {
        print(error)
        continue
    }
    for row in game.board {
        var rowStr = "|"
        for cell in row {
            switch cell {
            case .move(.x):
                rowStr += "X"
            case .move(.o):
                rowStr += "O"
            case .nothing:
                rowStr += " "
            }
            rowStr += "|"
        }
        print(rowStr)
    }
}

if case .gameOver(let stateOver) = game.stateGame {
    switch stateOver {
    case .winner(let player):
        let playerName = player == .o ? "O" : "X"
        print("WINNER PLAYER: \(playerName)")
    case .draw:
        print("DRAW")
    }
}
