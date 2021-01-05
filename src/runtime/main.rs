// this is 56 bytes, space-padded
// it will be changed at deploy-time, look for "ONION_ADDRESS" in binary
const ONION_ADDRESS: &str = "ONION_ADDRESS                                                        ";

// get the manager adress (inserted at deploy-time)
fn get_manager_address() -> String {
    // TODO: I'm new to rust. Not sure if I am doing this right.
    return format!("{}.onion", String::from(ONION_ADDRESS).split_off(13).trim());
}

fn main() {
    println!("The hard-coded manager address is {}.", get_manager_address());
}
