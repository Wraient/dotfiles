
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
        
        
    }

}

fn main() {
    println!("Hello, world!");
}
