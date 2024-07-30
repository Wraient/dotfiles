fn main(){
    fn plus_one(x: Option<i32>) -> Option<i32> {
        match x {
            None => None,
            Some(i) => Some(i+1),
        }
    }

    let five = Some(5);
    let six = plus_one(five);
    let seven = plus_one(six);

    println!("{}", six.unwrap_or(0));
    println!("{}", seven.unwrap_or(0));
}