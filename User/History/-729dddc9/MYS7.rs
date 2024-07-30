use std::io;

fn main(){
    println!("Enter your name: ");
    let mut name = String::new();
    io::stdin()
        .read_line(&mut name)
        .expect("Failed to get the name");
    
    println!("Hello, nerdy {name}")
}