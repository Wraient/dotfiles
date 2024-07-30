// use std::io;

fn main(){
    let mut s = String::from("Hello");
    
    let ref1 = &mut s;
    {
        let ref2 = &mut s;
        println!("{}", s);
    }

    func1(ref1);

    println!("{}", s);

}

fn func1(s: &mut String){
    s.push_str(", World");
}
