use libtor::{ Tor, TorFlag, HiddenServiceVersion, TorAddress, Error, log };
use dirs;
use std::fs::{ File };
use std::io::{ Read };
use std::thread::{ JoinHandle };
use std::ffi::CString;

// FFI/C interface

#[no_mangle]
pub extern fn rattata_location() -> *const i8 {
    return CString::new(location()).unwrap().into_raw();
}

#[no_mangle]
pub extern fn rattata_hostname() -> *const i8 {
    return  CString::new(hostname()).unwrap().into_raw();
}



/// get the current setings dir (which has tor stuff in it)
pub fn location() -> String {
    return format!("{}/rattata", dirs::config_dir().unwrap().into_os_string().into_string().unwrap());
}

/// start a tor server & the local service connected to it
pub fn start(port: u16) -> JoinHandle<Result<u8, Error>> {
    // TODO: write actual service here
    return Tor::new()
        .flag(TorFlag::SocksPort(0))
        .flag(TorFlag::HiddenServiceDir(location()))
        .flag(TorFlag::HiddenServiceVersion(HiddenServiceVersion::V3))
        .flag(TorFlag::HiddenServicePort(TorAddress::Port(port), None.into()))
        .flag(TorFlag::Log(log::LogLevel::Err))
        .start_background();
}

/// get the current onion-hostname from running tor-server
pub fn hostname() -> String {
    let mut content = String::new();
    let fname = format!("{}/hostname", location());
    let f = File::open(&fname);
    let _ = match f {
        Ok(mut file) => file.read_to_string(&mut content),
        Err(error) => panic!("Problem opening the file {}: {:?}", &fname, error),
    };
    return content;
}