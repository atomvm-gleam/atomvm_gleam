pub type PlatformName {
  GenericUnix
  Emscripten
  Esp32
  Pico
  Stm32
}

@external(erlang, "atomvm", "platform")
pub fn get_system_platform() -> PlatformName
