config = {}

config.servicios = {["ambulance"] = "ambulance",
                    ["police"] = "police",
                    ["taxi"] = "taxi",
                    ["mechanic"] = "mechanic",}

config.apps = {
    ["gps"] = {["nombre"] = "GPS" , ["data"] = { ["bajada"] = false, 
                                                 ["descargando"] = false, 
                                                 ["contador"] = 0, 
                                                 ["disponible"] = false},
                                                 ["codigo"] = { ["necesario"] = false, ["code"] = ""
                                                },
                                                },
    ["account"] = {["nombre"] = "eWallet" , ["data"] = { ["bajada"] = false, 
                                                        ["descargando"] = false, 
                                                        ["contador"] = 0, 
                                                        ["disponible"] = true},
                                                        ["codigo"] = { ["necesario"] = false, ["code"] = ""
                                                    },
                                                    },
    ["twatter"] = {["nombre"] = "Twitter" , ["data"] = { ["bajada"] = false, 
                                                        ["descargando"] = false, 
                                                        ["contador"] = 0, 
                                                        ["disponible"] = true},
                                                        ["codigo"] = { ["necesario"] = false, ["code"] = ""
                                                    },
                                                    },   
    ["yellowpages"] = {["nombre"] = "Yellow Pages" , ["data"] = { ["bajada"] = false, 
                                                          ["descargando"] = false, 
                                                          ["contador"] = 0, 
                                                          ["disponible"] = true},
                                                          ["codigo"] = { ["necesario"] = false, ["code"] = ""
                                                    },
                                                    },
    ["internet"] = {["nombre"] = "Browser" , ["data"] = { ["bajada"] = false, 
                                                            ["descargando"] = false, 
                                                            ["contador"] = 0, 
                                                            ["disponible"] = false},
                                                            ["codigo"] = { ["necesario"] = false, ["code"] = ""
                                                    },
                                                    },
    ["car"] = {["nombre"] = "Garage" , ["data"] = { ["bajada"] = false, 
                                                    ["descargando"] = false, 
                                                    ["contador"] = 0, 
                                                    ["disponible"] = false},
                                                    ["codigo"] = { ["necesario"] = false, ["code"] = ""
                                                    },
                                                },
    ["llaves"] = {["nombre"] = "Keys" , ["data"] = { ["bajada"] = false, 
                                                       ["descargando"] = false, 
                                                       ["contador"] = 0, 
                                                       ["disponible"] = false},
                                                       ["codigo"] = { ["necesario"] = false, ["code"] = ""
                                                    },
                                                    },
}
