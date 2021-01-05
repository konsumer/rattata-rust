use libtor::{ Tor, TorFlag, HiddenServiceVersion, TorAddress };
use dirs;
use std::fs::File;
use std::io::Read;

fn main() {
    let config_dir = dirs::config_dir().unwrap().into_os_string().into_string().unwrap();
    
    let server = Tor::new()
        .flag(TorFlag::SocksPort(0))
        .flag(TorFlag::HiddenServiceDir(format!("{}/rattata", config_dir)))
        .flag(TorFlag::HiddenServiceVersion(HiddenServiceVersion::V3))
        .flag(TorFlag::HiddenServicePort(TorAddress::Port(8000), None.into()))
        .start_background();
    
    // TODO: write actual service here
    
    match File::open(format!("{}/rattata/hostname", config_dir)) {
        Ok(mut file) => {
            let mut content = String::new();
            file.read_to_string(&mut content).unwrap();
            println!("Server running at {}", content);
            server.join();
        },
        
        Err(error) => {
            println!("Error opening host file: {}", error);
        }
    }
}