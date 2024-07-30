use std::io;

fn main(){
    println!("Hello world");
    let mut name = String::new();
    io::stdin()
        .read_line(&mut name)
        .expect("Failed to get name");
    
    println!("Hello, {name}")
}