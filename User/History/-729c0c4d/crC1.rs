

struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}

fn main(){
    let user1 = User{
        active: true,
        username: String::from("wraient"),
        email: String::from("wraient@ruserver.com"),
        sign_in_count:1,
    };

    let user2 = User{
        username: String::from("FakeWraient"),
        sign_in_count: 2,
        ..user1
    };

    println!("{}", user2.active);

}
