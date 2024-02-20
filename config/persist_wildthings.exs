import Config

alias Servy.{Bear, Lion}

config :servy,
  bears: [
    %Bear{id:  1, name: "Teddy 🧸"  , type: "Brown"  , hibernating: true},
    %Bear{id:  2, name: "Smokey 🐻" , type: "Black"  ,                  },
    %Bear{id:  3, name: "Paddington", type: "Brown"  ,                  },
    %Bear{id:  4, name: "Scarface"  , type: "Grizzly", hibernating: true},
    %Bear{id:  5, name: "Snow"      , type: "Polar"  ,                  },
    %Bear{id:  6, name: "Brutus"    , type: "Grizzly",                  },
    %Bear{id:  7, name: "Rosie"     , type: "Black"  , hibernating: true},
    %Bear{id:  8, name: "Roscoe"    , type: "Panda"  ,                  },
    %Bear{id:  9, name: "Iceman"    , type: "Polar"  , hibernating: true},
    %Bear{id: 10, name: "Kenai"     , type: "Grizzly",                  }
  ]

config :servy,
  lions: [
    %Lion{id: 1, name: "Mufasa"  , type: "King"    },
    %Lion{id: 2, name: "Simba 🦁", type: "Cub"     },
    %Lion{id: 3, name: "Kimba"   , type: "White"   },
    %Lion{id: 4, name: "Lambert" , type: "Sheepish"},
    %Lion{id: 5, name: "Elsa"    , type: "Cub"     }
  ]
