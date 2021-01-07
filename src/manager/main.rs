mod rattata;
use std::thread::{ sleep, spawn };
use std::time::{ Duration };

fn main() {
    let server = spawn(|| rattata::start(8000));
    sleep(Duration::from_millis(2000));
    println!("Files in {}", rattata::location());
    let hostname = rattata::hostname();
    println!("Server running at {}", hostname);
    let _ = server.join();
}
