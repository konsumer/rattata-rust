mod rattata;
use std::thread::{ sleep };
use std::time::{ Duration };

fn main() {
    let (_socket, tor) = rattata::start(8000);
    sleep(Duration::from_millis(2000));
    println!("Files in {}", rattata::location());
    println!("Server running at {}", rattata::hostname());
    let _ = tor.join();
}
