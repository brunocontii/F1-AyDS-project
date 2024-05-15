users = [
    { username: 'Jon Doe', password: 'jondoe', cant_life: 3, cant_coins: 0},
    { username: 'Bruno', password: 'messi', cant_life: 2, cant_coins: 999},
    { username: 'Juan', password: 'mbappe', cant_life: 3, cant_coins: 500},
]

users.each do |u|
    User.create(u)
end

profiles = [
    {name: 'juan', lastName: 'cru', description: 'f1 lover', age: 22},
    {name: 'bruno', lastName: 'cti', description: '@brunnoconti attractive boy', age: 21},
]

profiles.each do |u|
    Profile.create(u)
end

questions = [
    {name_question: '¿Quien es el piloto con mas campeonatos mundiales?' , level: easy, theme: pilot, id_q: 1},
    {name_question: '¿Cual de los siguientes pilotos es conocido como "The Iceman"?', level: difficult, theme: pilot, id_q: 2},
    {name_question: '¿Que piloto tiene el record de mas pole positions de la historia?' , level: normal, theme: pilot, id_q: 3},
    {name_question: '¿Quien es el piloto mas joven en haber ganado una carrera?', level: normal , theme: pilot , id_q: 4},
    {name_question: '¿Que piloto de los siguientes debuto mas joven en una carrera?', level: difficult, theme: pilot, id_q: 5},
    {name_question: '¿Que piloto es conocido como "el profesor" debido a su estrategia y a su calculo en las carreras?', level: difficult , theme: pilot , id_q: 6},
    {name_question: '¿Cual de los siguientes pilotos es hijo de un campeon mundial de rally?', level: easy, theme: pilot, id_q: 7},
    {name_question: '¿Que piloto de los mencionados es australiano?', level: normal , theme: pilot , id_q: 8 },
    {name_question: '¿Que piloto gano mas carreras en el gran premio de monaco?', level: difficult, theme: pilot, id_q: 9},
    {name_question: '¿Cual es el piloto mas joven en ganar un campeonato de F1?', level: normal, theme: pilot, id_q: 10},
    {name_question: '¿Quien es el unico piloto que gano un campeonato con renault?', level: difficult , theme: pilot , id_q: 11},
    {name_question: '¿Quien es el primer piloto en ganar una carrera para ferrari en la historia?', level: difficult, theme: pilot , id_q: 12},
    {name_question: '¿Cual fue el unico piloto que gano el campeonato mundial con BrawnGP?', level: imposible, theme: pilot , id_q: 13},
    {name_question: '¿Quien es el piloto con mas podios(13) sin poder ganar una carrera?', level: imposible, theme: pilot , id_q: 14},
    {name_question: '¿Cuantos titulos mundiales tiene el ex piloto Juan Manuel Fangio?', level: normal, theme: pilot , id_q: 15},
    {name_question: '¿En que año Juan Manuel Fangio gano su ultimo campeonato mundial?', level: difficult, theme: pilot , id_q: 17},
    {name_question: '¿Para que pais corrieron Emerson Fittipaldi y Felipe Massa?', level: easy, theme: pilot , id_q: 18},
    {name_question: '¿Que pilotos conforman actualmente el equipo MC-LAREN?', level: normal, theme: pilot , id_q: 19},
    {name_question: '¿De que nacionalidad es el ex piloto Sebastian Vettel?', level: normal, theme: pilot , id_q: 20},
    {name_question: '¿Cuantos campeonatos gano Jim Clark?', level: difficult, theme: pilot , id_q: 21},
    {name_question: '¿Que piloto protagonizo el recordado accidente perdiendo la vida en Imola,Italia?', level: normal, theme: pilot , id_q: 22},
    {name_question: '¿De que nacionalidad es el actual piloto Sergio "Checo" Perez?', level: easy, theme: pilot , id_q: 23},
    {name_question: '¿Actualmente hay algun piloto argentino en la F1?', level: normal, theme: pilot , id_q: 24},
    {name_question: '¿Cuantas carreras gano el piloto Michael Schumacher?', level: difficult, theme: pilot , id_q: 25},
    
]

questions.each do |u|
    Question.create(u)
end