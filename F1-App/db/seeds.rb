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
    {name_question: '¿Cual fue el unico piloto que gano el campeonato mundial con BrawnGP?', level: impossible, theme: pilot , id_q: 13},
    {name_question: '¿Quien es el piloto con mas podios(13) sin poder ganar una carrera?', level: impossible, theme: pilot , id_q: 14},
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
    {name_question: '¿Cuántos circuitos han albergado carreras del campeonato mundial de F1?', level: normal, theme: circuit, id_q:26},
    {name_question: '¿En qué circuito se llevó a cabo la primera carrera de F1?', level: easy, theme: circuit, id_q:27},
    {name_question: '¿Cuál es el circuito más largo utilizado en la historia de la F1?', level: easy, theme: circuit, id_q:28},
    {name_question: '¿Cuánto mide el circuito más largo utilizado en la historia de la F1?', level: normal, theme: circuit, id_q:29},
    {name_question: '¿Cuál es el circuito que más ediciones tuvo?', level: easy, theme: circuit, id_q:30},
    {name_question: '¿Cuántas ediciones tuvo el circuito que más se utilizó?', level: easy, theme: circuit, id_q:31},
    {name_question: 'Cuales de los siguientes NO es un tipo de circuito:', level: normal, theme: circuit, id_q:32},
    {name_question: '¿Cuál fue el último circuito agregado a día de hoy?', level: normal, theme: circuit, id_q:33},
    {name_question: '¿Cuál es el país con más circuitos en su territorio?', level: easy, theme: circuit, id_q:34},
    {name_question: '¿Cuál es el circuito más corto utilizado en la historia de la F1?', level: difficult, theme: circuit, id_q:35},
    {name_question: '¿Cómo se llama el tramo del circuito de Pescara donde Guy Moll falleció durante 1934?', level: difficult, theme: circuit, id_q:36},
    {name_question: '¿Durante qué años estuvo activo el circuito callejero de Adelaida (Australia)?', level: impossible, theme: circuit, id_q:37},
    {name_question: '¿Como se llama el único circuito argentino que estuvo en F1?', level: normal, theme: circuit, id_q:38},
    {name_question: '¿Qué circuito es completamente ovalado en su forma?', level: easy, theme: circuit, id_q:39},
    {name_question: '¿Cuántos circuitos se corren en la actualidad?', level: easy, theme: circuit, id_q:40},
    {name_question: '¿Qué circuito no se corrió dentro del siglo XXI?', level: difficult, theme: circuit, id_q:41},
    {name_question: '¿Qué capacidad aproximada de espectadores posee el circuito de Mónaco?', level: impossible, theme: circuit, id_q:42},
    {name_question: '¿Quién tiene el récord por la vuelta más rápida en el circuito de Mónaco?', level: difficult, theme: circuit, id_q:43},
    {name_question: '¿Cuántas curvas tiene el circuito de Mónaco?', level: difficult, theme: circuit, id_q:44},
    {name_question: '¿Qué tipos de eventos NO forman parte del circuito de Mónaco?, dejando de lado la F1', level: normal, theme: circuit, id_q:45},
    {name_question: '¿Qué tipo de escapatorias NO tiene el circuito de Monza?', level: difficult, theme: circuit, id_q:46},
    {name_question: '¿Cuál es el circuito con mayor capacidad de personas?', level: normal, theme: circuit, id_q:47},
    {name_question: '¿Qué circuito tiene más de 100 años desde su primera carrera?', level: difficult, theme: circuit, id_q:48},
    {name_question: '¿Cuántos circuitos que estuvieron en F1 se encuentran en sudamérica?', level: normal, theme: circuit, id_q:49},
    {name_question: '¿Cuál es el continente con mayor cantidad de circuitos corridos en la F1?', level: easy, theme: circuit, id_q:50},
    {name_question: '¿Con cuantos pilotos compite cada equipo/escuderia en cada carrera?', level: easy, theme: team, id_q: 51},
    {name_question: '¿Quienes son los actuales pilotos de Red Bull?', level: easy, theme: team, id_q: 52},
    {name_question: '¿Quienes son los actuales pilotos de Mercedes?', level: easy, theme: team, id_q: 53},
    {name_question: '¿Quienes son los actuales pilotos de Ferrari?', level: easy, theme: team, id_q: 54},
    {name_question: '¿Quienes son los actuales pilotos de McLaren?', level: normal, theme: team, id_q: 55},
    {name_question: '¿Quienes son los actuales pilotos de Aston Martin?', level: normal, theme: team, id_q: 56},
    {name_question: '¿Quienes son los actuales pilotos de Alpine?', level: difficult, theme: team, id_q: 57},
    {name_question: '¿Quienes son los actuales pilotos de Williams?', level: difficult, theme: team, id_q: 58},
    {name_question: '¿Quienes son los actuales pilotos de RB?', level: difficult, theme: team, id_q: 59},
    {name_question: '¿Quienes son los actuales pilotos de Stake?', level: difficult, theme: team, id_q: 60},
    {name_question: '¿Quienes son los actuales pilotos de Haas?', level: difficult, theme: team, id_q: 61},
    {name_question: '¿A que año se remonta el origen de Red Bull en el automovilismo?', level: impossible, theme: , id_q: 62},
    {name_question: '¿Quien fue el fundador de Red Bull?', level: impossible, theme: team, id_q: 63},
    {name_question: '¿Cual fue la escuderia antecesora de Red Bull?', level: difficult, theme: team, id_q: 64},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Constructores de Red Bull?', level: normal, theme: team, id_q: 65},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Pilotos de Red Bull?', level: normal, theme: team, id_q: 66},
    {name_question: '¿Cual es la nacionalidad de Red Bull?', level: difficult, theme: team, id_q: 67},
    {name_question: '¿Cual es la nacionalidad de Mercedes?', level: difficult, theme: team, id_q: 68},
    {name_question: '¿Quien fue el fundador de Mercedes?', level: impossible, theme: team, id_q: 69},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Constructores de Mercedes?', level: normal, theme: team, id_q: 70},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Pilotos de Mercedes?', level: normal, theme: team, id_q: 71},
    {name_question: '¿Cual es la nacionalidad de Ferrari?', level: easy, theme: team, id_q: 72},
    {name_question: '¿Quien fue el fundador de Ferrari?', level: normal, theme: team, id_q: 73},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Constructores de Ferrari?', level: normal, theme: team, id_q: 74},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Pilotos de Ferrari?', level: normal, theme: team, id_q: 75},
]

questions.each do |u|
    Question.create(u)
end