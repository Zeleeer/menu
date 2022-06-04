fx_version "cerulean"
game "gta5"
lua54 "yes"
use_fxv2_oal "yes"

description "Menu created with RageUI V3, only comptability with ncs_core"

client_scripts {
    "src/RageUI.lua",
    "src/Menu.lua",
    "src/MenuController.lua",
    "src/components/*.lua",
    "src/elements/*.lua",
    "src/items/*.lua",
    "src/panels/*.lua",
    "src/windows/*.lua",
}

client_scripts {
    "import.lua",
    "client/menu.lua"
}

dependencies {
    "ncs_core"
  }