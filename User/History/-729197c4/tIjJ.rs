enum UsStates{
    Alabama,
    NewYork,
    Bitchless
}

enum Coin{
    Penny,
    Nickel,
    Dime,
    Quarter(UsStates),
}

fn value_in_cents(coin:Coin) -> u8 {
    match coin{
        Coin::Penny => {
            println!("Lucky penny");
            1
        }
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter(state) => {
            println!("State quarter is from {state:?}!");
            25
        }
    }
}

fn main(){
    use Coin::Penny;
    println!("{}", value_in_cents(Penny));

}