
const BOARD_SIZE: u8 = 64;

enum Pieces {
    Empty,
    King,
    Queen,
    Rook,
    Bishop,
    Knight,
    Pawn
}

struct Board {
    sqaures : [Pieces; BOARD_SIZE],
}

impl Board {
    fn new() -> Self {
        Self {
            sqaures : [Pieces::Empty; BOARD_SIZE],
        }
    }

    fn setup(&mut self) {
        self.squares = [
            Piece::WhiteRook, Piece::WhiteKnight, Piece::WhiteBishop, Piece::WhiteQueen, Piece::WhiteKing, Piece::WhiteBishop, Piece::WhiteKnight, Piece::WhiteRook,
            Piece::WhitePawn, Piece::WhitePawn, Piece::WhitePawn, Piece::WhitePawn, Piece::WhitePawn, Piece::WhitePawn, Piece::WhitePawn, Piece::WhitePawn,
            Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty,
            Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty,
            Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty,
            Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty, Piece::Empty,
            Piece::BlackPawn, Piece::BlackPawn, Piece::BlackPawn, Piece::BlackPawn, Piece::BlackPawn, Piece::BlackPawn, Piece::BlackPawn, Piece::BlackPawn,
            Piece::BlackRook, Piece::BlackKnight, Piece::BlackBishop, Piece::BlackQueen, Piece::BlackKing, Piece::BlackBishop, Piece::BlackKnight, Piece::BlackRook,
        ];
    }

    fn print(&self) {
        for (i, piece) in self.squares.iter().enumerate() {
            if i % 8 == 0 {
                println!();
            }
            print!("{:?} ", piece);
        }
        println!();
    }

}

fn main() {

    let mut board = Board::new();
    board.setup();
    board.print();
}
