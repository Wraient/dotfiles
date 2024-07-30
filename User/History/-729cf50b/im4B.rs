use std::io;

struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}

fn main(){
    user1 = User {
        active: true,
        username: String::from("wraient"),
        email: String::from("wraient@ruserver.com"),
        sign_in_count: 1,
    }
    println!("{}", user1.active);
}
