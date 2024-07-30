// use std::io;

fn main(){
    let s = String::from("Hello");
    
    let ref1 = &s;

    println!("{}", s);

}

fn func1(s: String){
    s.push_str(", World");
}
