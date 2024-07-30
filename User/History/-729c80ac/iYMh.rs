// use std::io;

struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}

fn mkuser(username:String, email:String) -> User {
    User {
        active: true,
        username,
        email,
        sign_in_count: 1,
    }
}

fn main(){
    let user1 = mkuser(String::from("wraient"), String::from("wraient@ruserver.com"));

    println!("Active: {}", user1.active);
    println!("Username: {}", user1.username);
    println!("Email: {}", user1.email);
    println!("Sign in count: {}", user1.sign_in_count);

}
