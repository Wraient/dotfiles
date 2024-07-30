use std::io

struct User {
    active: bool,
    username: String,
    email: String,
    sign_in_count: u64,
}

fn mkuser(username:String, email:String){
    let user = User{
        active: true,
        username,
        email,
        sign_in_count: 1,
    };

    user;
}

fn main(){
    let user1 = mkuser(String::from("wraient"))

}
