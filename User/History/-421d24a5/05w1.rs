
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


fn main() {
    println!("Hello, world!");
}
