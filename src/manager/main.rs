use libtor::{ Tor, TorFlag, HiddenServiceVersion, TorAddress, Error, log };
use dirs;
use std::fs::{ File };
use std::io::{ Read };
use std::thread::{ JoinHandle, sleep };
use std::time::{ Duration };

/// get the current setings dir (which has tor stuff in it)
fn rattata_location() -> String {
    return format!("{}/rattata", dirs::config_dir().unwrap().into_os_string().into_string().unwrap());
}

/// start a tor server & the local service connected to it
fn rattata_start(port: u16) -> JoinHandle<Result<u8, Error>> {
    // TODO: write actual service here

    return Tor::new()
        .flag(TorFlag::SocksPort(0))
        .flag(TorFlag::HiddenServiceDir(rattata_location()))
        .flag(TorFlag::HiddenServiceVersion(HiddenServiceVersion::V3))
        .flag(TorFlag::HiddenServicePort(TorAddress::Port(port), None.into()))
        .flag(TorFlag::Log(log::LogLevel::Err))
        .start_background();
}

/// get the current onion-hostname from running tor-server
fn rattata_hostname() -> String {
    let mut content = String::new();
    let fname = format!("{}/hostname", rattata_location());
    let f = File::open(&fname);
    let _ = match f {
        Ok(mut file) => file.read_to_string(&mut content),
        Err(error) => panic!("Problem opening the file {}: {:?}", &fname, error),
    };
    return content;
}

fn main() {
    let server = rattata_start(8000);
    sleep(Duration::from_millis(1000));
    let hostname = rattata_hostname();
    println!("Server running at {}", &hostname);
    let _ = server.join();
}