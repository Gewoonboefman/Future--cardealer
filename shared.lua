Shared = {}

Shared.Locations = {
    {
        blip = true,
        coords = vec4(-30.4155, -1096.8690, 27.2744, 74.3577)
    },
    {
        coords = vec4(-31.1940, -1099.0640, 27.2744, 68.0661)
    }
}


Shared.QuickSellEnabled = true

Shared.QuickSellPrices = {
    Low = {min = 25000, max = 35000, chance = 595},
    Medium = {min = 45000, max = 55000, chance = 400},
    High = {min = 120000, max = 130000, chance = 5}
}


Shared.QuickSell = {
    coords = vec3(-23.8175, -1094.0479, 27.3052),
    sellPercentage = 0.15
}

Shared.Showroom = {
    {
        model = `rmodrs6`,
        coords = vec3(-37.0475, -1093.1947, 27.3023),
        heading = 156.7317
    },
    {
        model = `rmodrs6`,
        coords = vec3(-42.2574, -1101.4169, 27.3023),
        heading = 342.992126
    },
    {
        model = `rmode63s`,
        coords = vec3(-54.6786, -1096.9877, 27.3023),
        heading = 337.88
    },
    {
        model = `x5bmw`,
        coords = vec3(-49.7459, -1083.6982, 27.3023),
        heading = 203.10
    },
    {
        model = `rmodmk7`,
        coords = vec3(-47.6833, -1091.9606, 27.3023),
        heading = 211.102372
    }
}

Shared.SpawnPlaces = {
    {
        coords = vec3(-11.54, -1081.04, 26.68),
        heading = 124.55
    }
}

Shared.TestritSpawns = {
    {
        coords = vec3(-47.6543, -1112.0164, 26.6702),
        heading = 71.0992
    }
}

Shared.Vehicles = {
    ['progen'] = {
        {
            model = 'emerus',
            label = 'Emurus',
            price = 305000  -- 50% korting
         },
         {
            model = 'gp1',
            label = 'GP 1',
            price = 200000  -- 50% korting
         },
         {
            model = 'italigtb',
            label = 'Italia GTB',
            price = 335000  -- 50% korting
         },
        {
            model = 't20',
            label = 'T20',
            price = 460000  -- 50% korting
        },
        {
            model = 'tyrus',
            label = 'Tyrus',
            price = 540000  -- 50% korting
        },
    },
    ['Canis'] = {
        {
            model = 'seminole2',
            label = 'Seminole Frontier',
            price = 12500  -- 50% korting
        },
        {
            model = 'mesa',
            label = 'Mesa',
            price = 32500  -- 50% korting
        },
        {
            model = 'kamacho',
            label = 'Kamacho',
            price = 75000  -- 50% korting
        }
    },
    ['Emperor'] = {
        {
            model = 'habanro',
            label = 'HABANRO',
            price = 32500  -- 50% korting
        },
        {
            model = 'vectre',
            label = 'VECTRE',
            price = 39000  -- 50% korting
        },
    },
    ['Maibatsu'] = {
        {
            model = 'mule4',
            label = 'Mule Custom',
            price = 225000  -- 50% korting
        },
        {
            model = 'sanchez',
            label = 'Sanchez',
            price = 22500  -- 50% korting
        },
        {
            model = 'manchez',
            label = 'Manchez',
            price = 27500  -- 50% korting
        },
    },
    ['Overflod'] = {
        {
            model = 'autarch',
            label = 'Autarch',
            price = 145000  -- 50% korting
        },
        {
            model = 'entity2',
            label = 'entity XXR',
            price = 335000  -- 50% korting
        },
        {
            model = 'imorgon',
            label = 'Imorgon',
            price = 280000  -- 50% korting
        },
        {
            model = 'tyrant',
            label = 'Tyrant',
            price = 550000  -- 50% korting
        },
        {
            model = 'zeno',
            label = 'Zeno',
            price = 650000  -- 50% korting
        }
    },
    ['Pegassi'] = {
        {
            model = 'ignus',
            label = 'Ignus',
            price = 1400000  -- 50% korting
        }
    },
    ['Grotti'] = {
        {
            model = 'bestiagts',
            label = 'BESTIAGTS',
            price = 42500  -- 50% korting
        },
        {
            model = 'brioso3',
            label = 'BRIOSO3',
            price = 30000  -- 50% korting
        },
        {
            model = 'italigto',
            label = 'ITALIGTO',
            price = 70000  -- 50% korting
        },
        {
            model = 'italirsx',
            label = 'ITALIRSX',
            price = 460000  -- 50% korting
        }
    },
    ['Burgerfahrzeug'] = {
        {
            model = 'surfer',
            label = 'SURFER',
            price = 17500  -- 50% korting
        },
        {
            model = 'weevil',
            label = 'WEEVIL',
            price = 12500  -- 50% korting
        }
    },
    ['Dinka'] = {
        {
            model = 'kanjo',
            label = 'KANJO',
            price = 17500  -- 50% korting
        },
        {
            model = 'blista',
            label = 'BLISTA',
            price = 12500  -- 50% korting
        },
        {
            model = 'akuma',
            label = 'AKUMA',
            price = 40000  -- 50% korting
        },
        {
            model = 'double',
            label = 'DOUBLE',
            price = 65000  -- 50% korting
        },
        {
            model = 'jester',
            label = 'JESTER',
            price = 120000  -- 50% korting
        },
    },
    ['Truffade'] = {
        {
            model = 'adder',
            label = 'Adder',
            price = 600000  -- 50% korting
        },
        {
            model = 'nero2',
            label = 'Nero Custom',
            price = 1300000  -- 50% korting
        },
        {
            model = 'thrax',
            label = 'Thrax',
            price = 1050000  -- 50% korting
        }
    },
    ['WesternMC'] = {
        {
            model = 'bagger',
            label = 'Bagger',
            price = 35000  -- 50% korting
        },
        {
            model = 'cliffhanger',
            label = 'Cliffhanger',
            price = 32500  -- 50% korting
        }
    },
    ['Denefactor'] = {
        {
            model = 'dubsta',
            label = 'Dubsta',
            price = 140000  -- 50% korting
        },
        {
            model = 'dubsta3',
            label = 'Dubsta 6x6',
            price = 220000  -- 50% korting
        },
        {
            model = 'feltzer',
            label = 'Feltzer',
            price = 90000  -- 50% korting
        },
        {
            model = 'krieger',
            label = 'Krieger',
            price = 700000  -- 50% korting
        },
        {
            model = 'schafter3',
            label = 'Schafter V12',
            price = 75000  -- 50% korting
        },
        {
            model = 'schlagen',
            label = 'Schlagen GT',
            price = 165000  -- 50% korting
        },
        {
            model = 'surano',
            label = 'Surano',
            price = 80000  -- 50% korting
        },
    },
    ['Pfister'] = {
        {
            model = 'astron',
            label = 'ASTRON',
            price = 90000  -- 50% korting
        },
        {
            model = 'comet7',
            label = 'COMET7',
            price = 130000  -- 50% korting
        },
        {
            model = 'growler',
            label = 'GROWLER',
            price = 120000  -- 50% korting
        },
    },
    ['bravado'] = {
        {
            model = 'rumpo',
            label = 'Rumpo',
            price = 60000  -- 50% korting
        },
        {
            model = 'youga',
            label = 'Youga',
            price = 50000  -- 50% korting
        },
        {
            model = 'youga3',
            label = 'Youga Classic 4x4',
            price = 87500  -- 50% korting
        },
    },
    ['Ubermacht'] = {
        {
            model = 'cypher',
            label = 'Cypher',
            price = 110000  -- 50% korting
        },
        {
            model = 'rebla',
            label = 'Rebla GTS',
            price = 140000  -- 50% korting
        },
        {
            model = 'rhinehart',
            label = 'Rhinehart',
            price = 120000  -- 50% korting
        },
        {
            model = 'zion2',
            label = 'Zion Cabrio',
            price = 40000  -- 50% korting
        },
    },
    ['Gallivanter'] = {
        {
            model = 'baller3',
            label = 'Baller LE',
            price = 120000  -- 50% korting
        },
        {
            model = 'baller4',
            label = 'Baller LE LWB',
            price = 110000  -- 50% korting
        },
    },
    ['Ocelot'] = {
        {
            model = 'jugular',
            label = 'Jugular',
            price = 55000  -- 50% korting
        },
        {
            model = 'locust',
            label = 'Locust',
            price = 120000  -- 50% korting
        },
        {
            model = 'pariah',
            label = 'Pariah',
            price = 45000  -- 50% korting
        },
        {
            model = 'xa21',
            label = 'XA-21',
            price = 75000  -- 50% korting
        },
    },
}


Shared.Fotobook = {
    CarSettings = {
        coords = vector3(-211.6762, -1324.0729, 30.4683),
        heading = 326.7165
    },
    Colors = {
        ['black'] = { index = 0 },
        ['white'] = { index = 111 },
        ['blue'] = { index = 64 },
        ['red'] = { index = 27 },
        ['green'] = { index = 55 },
        ['yellow'] = { index = 42 },
        ['pink'] = { index = 137 }
    },
    Cameras = {
        -- Maincam
        [1] = { coords = vector3(-211.2689, -1318.4303, 32.7023), aimAt = vector3(-211.5825, -1324.5447, 31.3203) },
        -- Side-cam
        [2] = { coords = vector3(-216.0495, -1321.5521, 32.0965), aimAt = vector3(-210.9144, -1325.0021, 31.2245) },
        -- back-cam
        [3] = { coords = vector3(-214.9406, -1329.0220, 32.1822), aimAt = vector3(-209.4646, -1320.7615, 31.3221) },
        -- front-cam
        [4] = { coords = vector3(-208.5354, -1319.2239, 32.7384), aimAt = vector3(-212.7731, -1325.7120, 30.9167) },
    },
    Vehicles = {}
}

-- Zet alle voertuigen vanuit Shared.Vehicles hierin
for merk, models in pairs(Shared.Vehicles) do
    for _, vehicle in ipairs(models) do
        table.insert(Shared.Fotobook.Vehicles, {
            model = vehicle.model,
            merk = merk
        })
    end
end