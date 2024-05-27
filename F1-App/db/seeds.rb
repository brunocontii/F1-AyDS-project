users = [
    {username: 'Joaco', password: 'jondoe', cant_life: 3, cant_coins: 20},
    {username: 'Foden', password: 'messi', cant_life: 3, cant_coins: 100},
    {username: 'Juancho', password: 'Juancho1234', cant_life: 3, cant_coins: 100},
    {username: 'erich', password: 'Hamilton', cant_life: 3, cant_coins: 80},
]

users.each do |user|
    User.find_or_create_by(username: user[:username]) do |u|
        u.password = user[:password]
        u.cant_life = user[:cant_life]
        u.cant_coins = user[:cant_coins]
    end
end

profiles = [
    {name: 'Juan Cruz', lastName: 'Gonzalez', description: 'f1 lover', age: 22, user_id: 3},
    {name: 'Bruno', lastName: 'Conti', description: 'messi lover', age: 21, user_id: 2},
    {name: 'Erich', lastName: 'Vollenweider', description: 'KTM Group', age: 25, user_id: 4},
    {name: 'Joaquin', lastName: 'Mezzano', description: 'intento de programador', age: 23, user_id: 1},
]

profiles.each do |profile|
    Profile.find_or_create_by(name: profile[:name], lastName: profile[:lastName]) do |u|
        u.description = profile[:description]
        u.age = profile[:age]
        u.user_id = profile[:user_id]
    end
end


questions = [
    {name_question: '¿Quienes son los pilotos con mas campeonatos mundiales?' , level: 'easy', theme: 'pilot'},
    {name_question: '¿Cual de los siguientes pilotos es conocido como "The Iceman"?', level: 'difficult', theme: 'pilot'},
    {name_question: '¿Que piloto tiene el record de mas pole positions de la historia?' , level: 'normal', theme: 'pilot'},
    {name_question: '¿Quien es el piloto mas joven en haber ganado una carrera?', level: 'normal' , theme: 'pilot'},
    {name_question: '¿Que piloto de los siguientes debuto mas joven en una carrera?', level: 'difficult', theme: 'pilot'},
    {name_question: '¿Que piloto es conocido como "el profesor" debido a su estrategia y a su calculo en las carreras?', level: 'difficult', theme: 'pilot'},
    {name_question: '¿Cual de los siguientes pilotos es hijo de un campeon mundial de rally?', level: 'easy', theme: 'pilot'},
    {name_question: '¿Que piloto de los mencionados es australiano?', level: 'normal', theme: 'pilot'},
    {name_question: '¿Que piloto gano mas carreras en el gran premio de monaco?', level: 'difficult', theme: 'pilot'},
    {name_question: '¿Cual es el piloto mas joven en ganar un campeonato de F1?', level: 'normal', theme: 'pilot'},
    {name_question: '¿Quien es el unico piloto que gano un campeonato con renault?', level: 'difficult', theme: 'pilot'},
    {name_question: '¿Quien es el primer piloto en ganar una carrera para ferrari en la historia?', level: 'difficult', theme: 'pilot'},
    {name_question: '¿Cual fue el unico piloto que gano el campeonato mundial con BrawnGP?', level: 'impossible', theme: 'pilot'},
    {name_question: '¿Quien es el piloto con mas podios(13) sin poder ganar una carrera?', level: 'impossible', theme: 'pilot'},
    {name_question: '¿Cuantos titulos mundiales tiene el ex piloto Juan Manuel Fangio?', level: 'normal', theme: 'pilot'},
    {name_question: '¿En que año Juan Manuel Fangio gano su ultimo campeonato mundial?', level: 'difficult', theme: 'pilot'},
    {name_question: '¿Para que pais corrieron Emerson Fittipaldi y Felipe Massa?', level: 'easy', theme: 'pilot'},
    {name_question: '¿Que pilotos conforman actualmente el equipo MC-LAREN?', level: 'normal', theme: 'pilot'},
    {name_question: '¿De que nacionalidad es el ex piloto Sebastian Vettel?', level: 'normal', theme: 'pilot'},
    {name_question: '¿Cuantos campeonatos gano Jim Clark?', level: 'difficult', theme: 'pilot'},
    {name_question: '¿Que piloto protagonizo el recordado accidente perdiendo la vida en Imola,Italia?', level: 'normal', theme: 'pilot'},
    {name_question: '¿De que nacionalidad es el actual piloto Sergio "Checo" Perez?', level: 'easy', theme: 'pilot'},
    {name_question: '¿Actualmente hay algun piloto argentino en la F1?', level: 'normal', theme: 'pilot'},
    {name_question: '¿Cuantas carreras gano el piloto Michael Schumacher?', level: 'difficult', theme: 'pilot'},
    {name_question: '¿Cuántos circuitos han albergado carreras del campeonato mundial de F1?', level: 'normal', theme: 'circuit'},
    {name_question: '¿En qué circuito se llevó a cabo la primera carrera de F1?', level: 'easy', theme: 'circuit'},
    {name_question: '¿Cuál es el circuito más largo utilizado en la historia de la F1?', level: 'easy', theme: 'circuit'},
    {name_question: '¿Cuánto mide el circuito más largo utilizado en la historia de la F1?', level: 'normal', theme: 'circuit'},
    {name_question: '¿Cuál es el circuito que más ediciones tuvo?', level: 'easy', theme: 'circuit'},
    {name_question: '¿Cuántas ediciones tuvo el circuito que más se utilizó?', level: 'easy', theme: 'circuit'},
    {name_question: 'Cuales de los siguientes NO es un tipo de circuito:', level: 'normal', theme: 'circuit'},
    {name_question: '¿Cuál fue el último circuito agregado a día de hoy?', level: 'normal', theme: 'circuit'},
    {name_question: '¿Cuál es el país con más circuitos en su territorio?', level: 'easy', theme: 'circuit'},
    {name_question: '¿Cuál es el circuito más corto utilizado en la historia de la F1?', level: 'difficult', theme: 'circuit'},
    {name_question: '¿Cómo se llama el tramo del circuito de Pescara donde Guy Moll falleció durante 1934?', level: 'difficult', theme: 'circuit'},
    {name_question: '¿Durante qué años estuvo activo el circuito callejero de Adelaida (Australia)?', level: 'impossible', theme: 'circuit'},
    {name_question: '¿Como se llama el único circuito argentino que estuvo en F1?', level: 'normal', theme: 'circuit'},
    {name_question: '¿Qué circuito es completamente ovalado en su forma?', level: 'easy', theme: 'circuit'},
    {name_question: '¿Cuántos circuitos se corren en la actualidad?', level: 'easy', theme: 'circuit'},
    {name_question: '¿Qué circuito no se corrió dentro del siglo XXI?', level: 'difficult', theme: 'circuit'},
    {name_question: '¿Qué capacidad aproximada de espectadores posee el circuito de Mónaco?', level: 'impossible', theme: 'circuit'},
    {name_question: '¿Quién tiene el récord por la vuelta más rápida en el circuito de Mónaco?', level: 'difficult', theme: 'circuit'},
    {name_question: '¿Cuántas curvas tiene el circuito de Mónaco?', level: 'difficult', theme: 'circuit'},
    {name_question: '¿Qué tipos de eventos NO forman parte del circuito de Mónaco?, dejando de lado la F1', level: 'normal', theme: 'circuit'},
    {name_question: '¿Qué tipo de escapatorias NO tiene el circuito de Monza?', level: 'difficult', theme: 'circuit'},
    {name_question: '¿Cuál es el circuito con mayor capacidad de personas?', level: 'normal', theme: 'circuit'},
    {name_question: '¿Qué circuito tiene más de 100 años desde su primera carrera?', level: 'difficult', theme: 'circuit'},
    {name_question: '¿Cuántos circuitos que estuvieron en F1 se encuentran en sudamérica?', level: 'normal', theme: 'circuit'},
    {name_question: '¿Cuál es el continente con mayor cantidad de circuitos corridos en la F1?', level: 'easy', theme: 'circuit'},
    {name_question: '¿Con cuantos pilotos compite cada equipo/escuderia en cada carrera?', level: 'easy', theme: 'team'},
    {name_question: '¿Quienes son los actuales pilotos de Red Bull?', level: 'easy', theme: 'team'},
    {name_question: '¿Quienes son los actuales pilotos de Mercedes?', level: 'easy', theme: 'team'},
    {name_question: '¿Quienes son los actuales pilotos de Ferrari?', level: 'easy', theme: 'team'},
    {name_question: '¿Quienes son los actuales pilotos de McLaren?', level: 'normal', theme: 'team'},
    {name_question: '¿Quienes son los actuales pilotos de Aston Martin?', level: 'normal', theme: 'team'},
    {name_question: '¿Quienes son los actuales pilotos de Alpine?', level: 'difficult', theme: 'team'},
    {name_question: '¿Quienes son los actuales pilotos de Williams?', level: 'difficult', theme: 'team'},
    {name_question: '¿Quienes son los actuales pilotos de RB?', level: 'difficult', theme: 'team'},
    {name_question: '¿Quienes son los actuales pilotos de Stake?', level: 'difficult', theme: 'team'},
    {name_question: '¿Quienes son los actuales pilotos de Haas?', level: 'difficult', theme: 'team'},
    {name_question: '¿A que año se remonta el origen de Red Bull en el automovilismo?', level: 'impossible', theme: 'team'},
    {name_question: '¿Quien fue el fundador de Red Bull?', level: 'impossible', theme: 'team'},
    {name_question: '¿Cual fue la escuderia antecesora de Red Bull?', level: 'difficult', theme: 'team'},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Constructores de Red Bull?', level: 'normal', theme: 'team'},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Pilotos de Red Bull?', level: 'normal', theme: 'team'},
    {name_question: '¿Cual es la nacionalidad de Red Bull?', level: 'difficult', theme: 'team'},
    {name_question: '¿Cual es la nacionalidad de Mercedes?', level: 'difficult', theme: 'team'},
    {name_question: '¿Quien fue el fundador de Mercedes?', level: 'impossible', theme: 'team'},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Constructores de Mercedes?', level: 'normal', theme: 'team'},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Pilotos de Mercedes?', level: 'normal', theme: 'team'},
    {name_question: '¿Cual es la nacionalidad de Ferrari?', level: 'easy', theme: 'team'},
    {name_question: '¿Quien fue el fundador de Ferrari?', level: 'normal', theme: 'team'},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Constructores de Ferrari?', level: 'normal', theme: 'team'},
    {name_question: '¿Cual fue la mejor posición en el Campeonato del Mundo de Pilotos de Ferrari?', level: 'normal', theme: 'team'},
    {name_question: '¿Qué indica la bandera a cuadros?', level: 'easy', theme: 'career'},
    {name_question: '¿Qué indica la bandera verde?', level: 'easy', theme: 'career'},
    {name_question: '¿Qué indica la bandera amarilla?', level: 'normal', theme: 'career'},
    {name_question: '¿Qué indica la bandera amarilla con Safety Car?', level: 'difficult', theme: 'career'},
    {name_question: '¿Qué indica la bandera amarilla con Virtual Safety Car?', level: 'impossible', theme: 'career'},
    {name_question: '¿Qué indica la bandera roja', level: 'easy', theme: 'career'},
    {name_question: '¿Qué indica la bandera negra junto al número del piloto?', level: 'difficult', theme: 'career'},
    {name_question: '¿Qué indica la bandera negra con un círculo naranja junto al número del piloto?', level: 'impossible', theme: 'career'},
    {name_question: '¿Qué indica la bandera dividida (blanca y negra) junto al dorsal?', level: 'impossible', theme: 'career'},
    {name_question: '¿Qué indica la bandera azul?', level: 'normal', theme: 'career'},
    {name_question: '¿Qué indica la bandera amarilla con franjas rojas?', level: 'impossible', theme: 'career'},
    {name_question: '¿Qué indica la bandera blanca?', level: 'easy', theme: 'career'},
    {name_question: '¿Cuál es el sistema de clasificación utilizado en la Fórmula 1 para determinar el orden de salida en la carrera?', level: 'difficult', theme: 'career'},
    {name_question: '¿Cuál es el límite máximo de vueltas permitidas en una carrera de Fórmula 1?', level: 'normal', theme: 'career'},
    {name_question: '¿Cuál es la duración aproximada de una carrera de Fórmula 1?', level: 'normal', theme: 'career'},
    {name_question: '¿Cuál es el límite máximo de pilotos permitidos en una parrilla de salida de Fórmula 1?', level: 'normal', theme: 'career'},
    {name_question: '¿Qué sucede si un piloto excede los límites de la pista consistentemente durante la carrera?', level: 'difficult', theme: 'career'},
    {name_question: '¿Cuál es la velocidad máxima permitida en el pit lane durante una carrera de Fórmula 1?', level: 'normal', theme: 'career'},
    {name_question: '¿Cuál es el límite máximo de motores que un equipo puede utilizar por temporada según las regulaciones de la Fórmula 1?', level: 'impossible', theme: 'career'},
]


questions.each do |question_data|
    Question.find_or_create_by(name_question: question_data[:name_question]) do |q|
        q.level = question_data[:level]
        q.theme = question_data[:theme]
    end
end

options = [
    ######                 PILOT                     ######
    {name_option: 'Lewis Hamilton y Michael Schumacher' , question_id: 1, correct: true},
    {name_option: 'Lewis Hamilton y Esteban Ocon' , question_id: 1, correct: false},
    {name_option: 'Lewis Hamilton y Franco Colapinto' , question_id: 1, correct: false},
    {name_option: 'Lewis Hamilton y Sergio "Checo" Perez' , question_id: 1, correct: false},

    {name_option: 'Fernando Alonso' , question_id: 2, correct: false},
    {name_option: 'Lewis Hamilton' , question_id: 2, correct: false},
    {name_option: 'Kimi Raikkonen' , question_id: 2, correct: true},
    {name_option: 'George Russell' , question_id: 2, correct: false},

    {name_option: 'Lewis Hamilton', question_id: 3, correct: true},
    {name_option: 'Michael Schumacher', question_id: 3, correct: false},
    {name_option: 'Ayrton Senna', question_id: 3, correct: false},
    {name_option: 'Sebastian Vettel', question_id: 3, correct: false},

    {name_option: 'Max Verstappen', question_id: 4, correct: true},
    {name_option: 'Sebastian Vettel', question_id: 4, correct: false},
    {name_option: 'Fernando Alonso', question_id: 4, correct: false},
    {name_option: 'Lewis Hamilton', question_id: 4, correct: false},

    {name_option: 'Kimi Raikkonen', question_id: 5, correct: false},
    {name_option: 'Sebastian Vettel', question_id: 5, correct: false},
    {name_option: 'Max Verstappen', question_id: 5, correct: true},
    {name_option: 'Lewis Hamilton', question_id: 5, correct: false},

    {name_option: 'Niki Lauda', question_id: 6, correct: false},
    {name_option: 'Alain Prost', question_id: 6, correct: true},
    {name_option: 'Nigel Mansell', question_id: 6, correct: false},
    {name_option: 'Jackie Stewart', question_id: 6, correct: false},

    {name_option: 'George Russell', question_id: 7, correct: false},
    {name_option: 'Lando Norris', question_id: 7, correct: false},
    {name_option: 'Pierre Gasly', question_id: 7, correct: false},
    {name_option: 'Carlos Sainz Jr', question_id: 7, correct: true},

    {name_option: 'Daniel Ricciardo', question_id: 8, correct: true},
    {name_option: 'Lando Norris', question_id: 8, correct: false},
    {name_option: 'Esteban Ocon', question_id: 8, correct: false},
    {name_option: 'Sergio Perez', question_id: 8, correct: false},

    {name_option: 'Lewis Hamilton', question_id: 9, correct: false},
    {name_option: 'Ayrton Senna', question_id: 9, correct: true},
    {name_option: 'Michael Schumacher', question_id: 9, correct: false},
    {name_option: 'Nico Rosberg', question_id: 9, correct: false},

    {name_option: 'Sebastian Vettel', question_id: 10, correct: true},
    {name_option: 'Lewis Hamilton', question_id: 10, correct: false},
    {name_option: 'Fernando Alonso', question_id: 10, correct: false},
    {name_option: 'Max Verstappen', question_id: 10, correct: false},

    {name_option: 'Fernando Alonso', question_id: 11, correct: true},
    {name_option: 'Alain Prost', question_id: 11, correct: false},
    {name_option: 'Nigel Mansell', question_id: 11, correct: false},
    {name_option: 'Damon Hill', question_id: 11, correct: false},

    {name_option: 'José Froilán González', question_id: 12, correct: true},
    {name_option: 'Alberto Ascari', question_id: 12, correct: false},
    {name_option: 'Juan Manuel Fangio', question_id: 12, correct: false},
    {name_option: 'Nino Farina', question_id: 12, correct: false},

    {name_option: 'Jenson Button', question_id: 13, correct: true},
    {name_option: 'Rubens Barrichello', question_id: 13, correct: false},
    {name_option: 'Lewis Hamilton', question_id: 13, correct: false},
    {name_option: 'Michael Schumacher', question_id: 13, correct: false},

    {name_option: '5', question_id: 15, correct: true},
    {name_option: '4', question_id: 15, correct: false},
    {name_option: '3', question_id: 15, correct: false},
    {name_option: '6', question_id: 15, correct: false},

    {name_option: '1957', question_id: 16, correct: true},
    {name_option: '1956', question_id: 16, correct: false},
    {name_option: '1955', question_id: 16, correct: false},
    {name_option: '1958', question_id: 16, correct: false},

    {name_option: 'Brasil', question_id: 17, correct: true},
    {name_option: 'Argentina', question_id: 17, correct: false},
    {name_option: 'España', question_id: 17, correct: false},
    {name_option: 'Italia', question_id: 17, correct: false},

    {name_option: 'Lando Norris y Oscar Piastri', question_id: 18, correct: true},
    {name_option: 'Carlos Sainz y Lando Norris', question_id: 18, correct: false},
    {name_option: 'Daniel Ricciardo y Lando Norris', question_id: 18, correct: false},
    {name_option: 'Lando Norris y Stoffel Vandoorne', question_id: 18, correct: false},

    {name_option: 'Alemán', question_id: 19, correct: true},
    {name_option: 'Austriaco', question_id: 19, correct: false},
    {name_option: 'Suizo', question_id: 19, correct: false},
    {name_option: 'Francés', question_id: 19, correct: false},

    {name_option: '2', question_id: 20, correct: true},
    {name_option: '1', question_id: 20, correct: false},
    {name_option: '3', question_id: 20, correct: false},
    {name_option: '4', question_id: 20, correct: false},

    {name_option: 'Ayrton Senna', question_id: 21, correct: true},
    {name_option: 'Roland Ratzenberger', question_id: 21, correct: false},
    {name_option: 'Jules Bianchi', question_id: 21, correct: false},
    {name_option: 'Gilles Villeneuve', question_id: 21, correct: false},

    {name_option: 'Mexicano', question_id: 22, correct: true},
    {name_option: 'Español', question_id: 22, correct: false},
    {name_option: 'Brasileño', question_id: 22, correct: false},
    {name_option: 'Argentino', question_id: 22, correct: false},

    {name_option: 'No', question_id: 23, correct: true},
    {name_option: 'Si', question_id: 23, correct: false},
    {name_option: 'Sí, en pruebas', question_id: 23, correct: false},
    {name_option: 'Sí, en reserva', question_id: 23, correct: false},

    {name_option: '91', question_id: 24, correct: true},
    {name_option: '85', question_id: 24, correct: false},
    {name_option: '88', question_id: 24, correct: false},
    {name_option: '95', question_id: 24, correct: false},

    {name_option: 'Nick Heidfeld', question_id: 14, correct: true},
    {name_option: 'Romain Grosjean', question_id: 14, correct: false},
    {name_option: 'Nico Hulkenberg', question_id: 14, correct: false},
    {name_option: 'Kevin Magnussen', question_id: 14, correct: false},

    ######                 CIRCUIT                     ######

    {name_option: '74', question_id: 25, correct: true},
    {name_option: '75', question_id: 25, correct: false},
    {name_option: '73', question_id: 25, correct: false},
    {name_option: '78', question_id: 25, correct: false},

    {name_option: 'Albert Park', question_id: 26, correct: false},
    {name_option: 'Silverstone', question_id: 26, correct: true},
    {name_option: 'Fuji', question_id: 26, correct: false},
    {name_option: 'Jerez', question_id: 26, correct: false},
    
    {name_option: 'Monza', question_id: 27, correct: false},
    {name_option: 'Sochi', question_id: 27, correct: false},
    {name_option: 'Pescara', question_id: 27, correct: true},
    {name_option: 'Zolder', question_id: 27, correct: false},
    
    {name_option: '25.602km', question_id: 28, correct: false},
    {name_option: '25.954km', question_id: 28, correct: false},
    {name_option: '26.122km', question_id: 28, correct: false},
    {name_option: '25.801km', question_id: 28, correct: true},
    
    {name_option: 'Monza', question_id: 29, correct: true},
    {name_option: 'Mónaco', question_id: 29, correct: false},
    {name_option: 'Silverstone', question_id: 29, correct: false},
    {name_option: 'Hungaroring', question_id: 29, correct: false},
    
    {name_option: '69', question_id: 30, correct: false},
    {name_option: '72', question_id: 30, correct: true},
    {name_option: '57', question_id: 30, correct: false},
    {name_option: '75', question_id: 30, correct: false},
    
    {name_option: 'Autódromo', question_id: 31, correct: false},
    {name_option: 'Híbrido', question_id: 31, correct: false},
    {name_option: 'Rural', question_id: 31, correct: true},
    {name_option: 'Callejero', question_id: 31, correct: false},
    
    {name_option: 'Riverside', question_id: 31, correct: false},
    {name_option: 'Miami', question_id: 31, correct: false},
    {name_option: 'Mugello', question_id: 31, correct: false},
    {name_option: 'Las Vegas', question_id: 31, correct: true},
    
    {name_option: 'Estados Unidos', question_id: 32, correct: true},
    {name_option: 'España', question_id: 32, correct: false},
    {name_option: 'Inglaterra', question_id: 32, correct: false},
    {name_option: 'Italia', question_id: 32, correct: false},
    
    {name_option: 'AVUS', question_id: 33, correct: false},
    {name_option: 'Mónaco', question_id: 33, correct: true},
    {name_option: 'Yeda', question_id: 33, correct: false},
    {name_option: 'Zolder', question_id: 33, correct: false},
    
    {name_option: 'La capilla', question_id: 34, correct: false},
    {name_option: 'El monte Silvano', question_id: 34, correct: false},
    {name_option: 'El kilómetro volador', question_id: 34, correct: true},
    {name_option: 'El punto raso', question_id: 34, correct: false},
    
    {name_option: '1986-1992', question_id: 35, correct: false},
    {name_option: '1999-2009', question_id: 35, correct: false},
    {name_option: '1975-1983', question_id: 35, correct: false},
    {name_option: '1985-1995', question_id: 35, correct: true},

    {name_option: 'Oscar y Juan Gálvez', question_id: 36, correct: true},
    {name_option: 'Juan Manuel Fangio', question_id: 36, correct: false},
    {name_option: 'Julio Argentino Roca', question_id: 36, correct: false},
    {name_option: 'Diego Armando Maradona', question_id: 36, correct: false},

    {name_option: 'Jerez', question_id: 37, correct: false},
    {name_option: 'Indianapolis', question_id: 37, correct: true},
    {name_option: 'Las Vegas', question_id: 37, correct: false},
    {name_option: 'Mónaco', question_id: 37, correct: false},

    {name_option: '19', question_id: 38, correct: false},
    {name_option: '20', question_id: 38, correct: false},
    {name_option: '21', question_id: 38, correct: true},
    {name_option: '22', question_id: 38, correct: false},

    {name_option: 'Monza', question_id: 39, correct: false},
    {name_option: 'Silverstone', question_id: 39, correct: false},
    {name_option: 'Zandvoort', question_id: 39, correct: false},
    {name_option: 'Aintree', question_id: 39, correct: true},

    {name_option: '37.000', question_id: 40, correct: true},
    {name_option: '38.000', question_id: 40, correct: false},
    {name_option: '36.000', question_id: 40, correct: false},
    {name_option: '40.000', question_id: 40, correct: false},

    {name_option: 'Fernando Alonso', question_id: 41, correct: false},
    {name_option: 'Lewis Hamilton', question_id: 41, correct: true},
    {name_option: 'Rubens Barrichello', question_id: 41, correct: false},
    {name_option: 'Max Verstappen', question_id: 41, correct: false},

    {name_option: '20', question_id: 42, correct: false},
    {name_option: '21', question_id: 43, correct: false},
    {name_option: '19', question_id: 43, correct: true},
    {name_option: '22', question_id: 44, correct: false},

    {name_option: 'Fórmula 2', question_id: 44, correct: false},
    {name_option: 'Fórmula 3', question_id: 44, correct: false},
    {name_option: 'Fórmula E', question_id: 44, correct: false},
    {name_option: 'Karting', question_id: 44, correct: true},

    {name_option: 'Asfalto', question_id: 45, correct: true},
    {name_option: 'Hierba', question_id: 45, correct: false},
    {name_option: 'Grava', question_id: 45, correct: false},
    {name_option: 'Hierba y grava', question_id: 45, correct: false},

    {name_option: 'AVUS', question_id: 46, correct: false},
    {name_option: 'Indianapolis', question_id: 46, correct: true},
    {name_option: 'Mónaco', question_id: 46, correct: false},
    {name_option: 'Enzo e Dino Ferrari', question_id: 46, correct: false},

    {name_option: 'Reims-Gueux', question_id: 47, correct: false},
    {name_option: 'Bremgarten', question_id: 47, correct: false},
    {name_option: 'Ninguno', question_id: 47, correct: true},
    {name_option: 'Silverstone', question_id: 47, correct: false},

    {name_option: '2', question_id: 48, correct: false},
    {name_option: '6', question_id: 48, correct: false},
    {name_option: '4', question_id: 48, correct: false},
    {name_option: '3', question_id: 48, correct: true},

    {name_option: 'Europa', question_id: 49, correct: true},
    {name_option: 'América', question_id: 49, correct: false},
    {name_option: 'Asia', question_id: 49, correct: false},
    {name_option: 'Ocenía', question_id: 49, correct: false},

    ######                 TEAM                     ######

    {name_option: '1 piloto', question_id: 50, correct: false},
    {name_option: '2 pilotos', question_id: 50, correct: true},
    {name_option: '3 pilotos', question_id: 50, correct: false},
    {name_option: '4 pilotos', question_id: 50, correct: false},

    {name_option: 'Max Verstappen y Sergio Perez', question_id: 51, correct: true},
    {name_option: 'Sergio Pérez', question_id: 51, correct: false},
    {name_option: 'Pierre Gasly', question_id: 51, correct: false},
    {name_option: 'Alexander Albon', question_id: 51, correct: false},

    {name_option: 'Lewis Hamilton y George Russell', question_id: 52, correct: true},
    {name_option: 'Valtteri Bottas', question_id: 52, correct: false},
    {name_option: 'George Russell', question_id: 52, correct: false},
    {name_option: 'Esteban Ocon', question_id: 52, correct: false},

    {name_option: 'Charles Leclerc y Carlos Sainz Jr', question_id: 53, correct: true},
    {name_option: 'Carlos Sainz Jr', question_id: 53, correct: false},
    {name_option: 'Sebastian Vettel', question_id: 53, correct: false},
    {name_option: 'Fernando Alonso', question_id: 53, correct: false},

    {name_option: 'Lando Norris y Oscar Piastri', question_id: 54, correct: true},
    {name_option: 'Británica', question_id: 54, correct: false},
    {name_option: 'Austriaca', question_id: 54, correct: false},
    {name_option: 'Italiana', question_id: 54, correct: false},

    {name_option: 'Sebastian Vettel', question_id: 55, correct: false},
    {name_option: 'Lance Stroll y Fernando Alonso', question_id: 55, correct: true},
    {name_option: 'Nico Hülkenberg', question_id: 55, correct: false},
    {name_option: 'Sergio Pérez', question_id: 55, correct: false},

    {name_option: 'Esteban Ocon y Pierre Gasly', question_id: 56, correct: true},
    {name_option: 'Fernando Alonso', question_id: 56, correct: false},
    {name_option: 'Nico Rosberg', question_id: 56, correct: false},
    {name_option: 'Sergio Pérez', question_id: 56, correct: false},

    {name_option: 'Alexander Albon y Logan Sargeant', question_id: 57, correct: true},
    {name_option: 'Nicholas Latifi', question_id: 57, correct: false},
    {name_option: 'Jack Aitken', question_id: 57, correct: false},
    {name_option: 'Robert Kubica', question_id: 57, correct: false},

    {name_option: 'Yuki Tsunoda y Daniel Ricciardo', question_id: 58, correct: true},
    {name_option: 'Sergio Pérez', question_id: 58, correct: false},
    {name_option: 'Pierre Gasly', question_id: 58, correct: false},
    {name_option: 'Alexander Albon', question_id: 58, correct: false},

    {name_option: 'Valtteri Bottas y Guanyu Zhou', question_id: 59, correct: true},
    {name_option: 'Equipo ficticio', question_id: 59, correct: false},
    {name_option: 'No se encuentra en la Fórmula 1', question_id: 59, correct: false},
    {name_option: 'Equipo de desarrollo', question_id: 59, correct: false},

    {name_option: 'Kevin Magnussen y Nico Hulkenberg', question_id: 60, correct: true},
    {name_option: 'Lando Norris', question_id: 60, correct: false},
    {name_option: 'Carlos Sainz Jr.', question_id: 60, correct: false},
    {name_option: 'Fernando Alonso', question_id: 60, correct: false},

    {name_option: '1987', question_id: 61, correct: true},
    {name_option: '1988', question_id: 61, correct: false},
    {name_option: '1986', question_id: 61, correct: false},
    {name_option: '1985', question_id: 61, correct: false},

    {name_option: 'Dietrich Mateschitz', question_id: 62, correct: true},
    {name_option: '2do lugar', question_id: 62, correct: false},
    {name_option: '3er lugar', question_id: 62, correct: false},
    {name_option: '4to lugar', question_id: 62, correct: false},

    {name_option: 'Jaguar', question_id: 63, correct: true},
    {name_option: '2do lugar', question_id: 63, correct: false},
    {name_option: '3er lugar', question_id: 63, correct: false},
    {name_option: '4to lugar', question_id: 63, correct: false},

    {name_option: '1er lugar', question_id: 64, correct: true},
    {name_option: '2do lugar', question_id: 64, correct: false},
    {name_option: '3er lugar', question_id: 64, correct: false},
    {name_option: '4to lugar', question_id: 64, correct: false},

    {name_option: '1er lugar', question_id: 65, correct: true},
    {name_option: '2do lugar', question_id: 65, correct: false},
    {name_option: '3er lugar', question_id: 65, correct: false},
    {name_option: '4to lugar', question_id: 65, correct: false},

    {name_option: 'Austriaca', question_id: 66, correct: true},
    {name_option: 'Alemana', question_id: 66, correct: false},
    {name_option: 'Británica', question_id: 66, correct: false},
    {name_option: 'Italiana', question_id: 66, correct: false},

    {name_option: 'Italiana', question_id: 67, correct: false},
    {name_option: 'Alemana', question_id: 67, correct: true},
    {name_option: 'Británica', question_id: 67, correct: false},
    {name_option: 'Austriaca', question_id: 67, correct: false},

    {name_option: 'Karl Benz y Gottlieb Daimler', question_id: 68, correct: true},
    {name_option: 'Gottlieb Daimler', question_id: 68, correct: false},
    {name_option: 'Ferdinand Porsche', question_id: 68, correct: false},
    {name_option: 'Enzo Ferrari', question_id: 68, correct: false},

    {name_option: '1er lugar', question_id: 69, correct: true},
    {name_option: '2do lugar', question_id: 69, correct: false},
    {name_option: '3er lugar', question_id: 69, correct: false},
    {name_option: '4to lugar', question_id: 69, correct: false},

    {name_option: '1er lugar', question_id: 70, correct: true},
    {name_option: '2do lugar', question_id: 70, correct: false},
    {name_option: '3er lugar', question_id: 70, correct: false},
    {name_option: '4to lugar', question_id: 70, correct: false},
 
    {name_option: 'Italiana', question_id: 71, correct: true},
    {name_option: 'Alemana', question_id: 71, correct: false},
    {name_option: 'Británica', question_id: 71, correct: false},
    {name_option: 'Austriaca', question_id: 71, correct: false},

    {name_option: 'Enzo Ferrari', question_id: 72, correct: true},
    {name_option: 'Piero Ferrari', question_id: 72, correct: false},
    {name_option: 'Luigi Chinetti', question_id: 72, correct: false},
    {name_option: 'Niki Lauda', question_id: 72, correct: false},

    {name_option: '1er lugar', question_id: 73, correct: true},
    {name_option: '2do lugar', question_id: 73, correct: false},
    {name_option: '3er lugar', question_id: 73, correct: false},
    {name_option: '4to lugar', question_id: 73, correct: false},

    {name_option: '1er lugar', question_id: 74, correct: true},
    {name_option: '2do lugar', question_id: 74, correct: false},
    {name_option: '3er lugar', question_id: 74, correct: false},
    {name_option: '4to lugar', question_id: 74, correct: false},   

    ######                 CAREER                     ######

    {name_option: 'Indica el final de la carrera', question_id: 75, correct: true},
    {name_option: 'Indica el comienzo de la carrera', question_id: 75, correct: false},
    {name_option: 'Indica peligro en pista', question_id: 75, correct: false},
    {name_option: 'Indica reducir la velocidad', question_id: 75, correct: false},

    {name_option: 'Indica que va a salir el coche de seguridad', question_id: 76, correct: false},
    {name_option: 'Indica el comienzo de la carrera', question_id: 76, correct: false},
    {name_option: 'Indica que el peligro en pista ha terminado', question_id: 76, correct: true},
    {name_option: 'Indica última vuelta', question_id: 76, correct: false},

    {name_option: 'Indica que el piloto debe reducir su velocidad y no podrá adelantar al menos que tenga por delante un coche dañado', question_id: 77, correct: true},
    {name_option: 'Indica que va a salir el coche de seguridad a pista', question_id: 77, correct: false},
    {name_option: 'Indica peligro en pista', question_id: 77, correct: false},
    {name_option: 'Indica reducir la velocidad', question_id: 77, correct: false},

    {name_option: 'Indica el comienzo de la carrera', question_id: 78, correct: false},
    {name_option: 'Indica reducir la velocidad', question_id: 78, correct: false},
    {name_option: 'Indica peligro en pista', question_id: 78, correct: false},
    {name_option: 'Indica que va a salir el coche de seguridad a pista', question_id: 78, correct: true},

    {name_option: 'Indica que va a salir el coche de seguridad a pista', question_id: 79, correct: false},
    {name_option: 'Es la misma que con un Safety Car pero no sale el coche de seguridad a pista', question_id: 79, correct: true},
    {name_option: 'Indica reducir la velocidad', question_id: 79, correct: false},
    {name_option: 'Indica el final de la carrera', question_id: 79, correct: false},

    {name_option: 'Indica que se detiene por completo la sesión', question_id: 80, correct: true},
    {name_option: 'Indica que va a salir el coche de seguridad a pista', question_id: 80, correct: false},
    {name_option: 'Indica peligro en pista', question_id: 80, correct: false},
    {name_option: 'Indica reducir la velocidad', question_id: 80, correct: false},

    {name_option: 'Indica que el piloto amonestado será excluido de la sesión por una maniobra antideportiva de gravedad', question_id: 81, correct: true},
    {name_option: 'Indica que el piloto amonestado será excluido de la sesión por exceder la velocidad', question_id: 81, correct: false},
    {name_option: 'Indica cambio de piloto', question_id: 81, correct: false},
    {name_option: 'Indica que ese piloto tiene que entrar al box', question_id: 81, correct: false},

    {name_option: 'Indica que el piloto amonestado será excluido de la sesión por una maniobra antideportiva de gravedad', question_id: 82, correct: false},
    {name_option: 'Indica al piloto que su monoplaza tiene severos problemas mecánicos que comprometen su seguridad y que está obligado a entrar en box y detener su vehículo lo antes posible', question_id: 82, correct: true},
    {name_option: 'Indica al piloto que su equipo perdió comunicación con él y tiene que entrar al box para solucionarlo', question_id: 82, correct: false},
    {name_option: 'Indica al piloto que será reemplazado por otro corredor de su equipo', question_id: 82, correct: false},

    {name_option: 'Advierte a los pilotos que tiene fallas en el motor', question_id: 83, correct: false},
    {name_option: 'Indica a los pilotos que tiene que entrar al box para llenar el tanque de combustible', question_id: 83, correct: false},
    {name_option: 'Indica a los pilotos que tiene que entrar al box para cambiar los neumáticos', question_id: 83, correct: false},
    {name_option: 'Advierte a los pilotos por una maniobra peligrosa o antideportiva en pista', question_id: 83, correct: true},

    {name_option: 'Siempre se muestra en entrenamientos y carreras de forma estática al final del pit lane para indicar que hay coches que se aproximan por la pista', question_id: 84, correct: false},
    {name_option: 'En la sesión de entrenamiento el piloto debe dejar pasar a un coche más rápido sin variar su trazada', question_id: 84, correct: false},
    {name_option: 'En situación de carrera, el piloto que va a ser doblado por otro que ha realizado una vuelta de más, será alertado mediante la bandera azul para permitir el adelantamiento tan rápido como sea posible', question_id: 84, correct: false},
    {name_option: 'Todas las opciones son correctas', question_id: 84, correct: true},

    {name_option: 'Indica a los pilotos que va a salir el coche de seguridad a pista', question_id: 85, correct: false},
    {name_option: 'Indica a los pilotos que hubo un accidente en la pista', question_id: 85, correct: false},
    {name_option: 'Indica a los pilotos que la situación en pista no es la idónea para rodar al límite', question_id: 85, correct: true},
    {name_option: 'Indica a los pilotos que deben regresar a los boxes', question_id: 85, correct: false},

    {name_option: 'Indica que un piloto abandonó la carrera', question_id: 86, correct: false},
    {name_option: 'Indica que hay un vehículo excesivamente lento en pista, ya sea una grúa o un coche médico', question_id: 86, correct: true},
    {name_option: 'Indica la última vuelta de la carrera', question_id: 86, correct: false},
    {name_option: 'Indica que todos los vehículos tienen que volver a boxes', question_id: 86, correct: false},

    {name_option: 'Tiempos de práctica libres', question_id: 87, correct: false},
    {name_option: 'Orden de llegada en la carrera anterior', question_id: 87, correct: false},
    {name_option: 'Clasificación de pilotos según sus resultados en el campeonato', question_id: 87, correct: false},
    {name_option: 'Sesión de clasificación de una vuelta cronometrada', question_id: 87, correct: true},

    {name_option: '60 vueltas', question_id: 88, correct: false},
    {name_option: '100 vueltas', question_id: 88, correct: false},
    {name_option: '75 vueltas', question_id: 88, correct: false},
    {name_option: 'No hay límite de vueltas', question_id: 88, correct: true},

    {name_option: '1 hora', question_id: 89, correct: false},
    {name_option: '2 hora ', question_id: 89, correct: false},
    {name_option: '30 minutos', question_id: 89, correct: false},
    {name_option: 'Depende del circuito y las condiciones de la carrera', question_id: 89, correct: true},

    {name_option: '18 pilotos', question_id: 90, correct: false},
    {name_option: '20 pilotos', question_id: 90, correct: false},
    {name_option: '22 pilotos', question_id: 90, correct: true},
    {name_option: '24 pilotos', question_id: 90, correct: false},

    {name_option: 'Se le otorga un bono de tiempo al final de la carrera', question_id: 91, correct: false},
    {name_option: 'Recibe una advertencia del equipo', question_id: 91, correct: false},
    {name_option: 'Puede recibir una penalización de tiempo o un drive-through', question_id: 91, correct: true},
    {name_option: 'No hay consecuencias', question_id: 91, correct: false},

    {name_option: '80 km/h', question_id: 92, correct: true},
    {name_option: '100 km/h', question_id: 92, correct: false},
    {name_option: '120 km/h', question_id: 92, correct: false},
    {name_option: '150 km/h', question_id: 92, correct: false},

    {name_option: '5 motores por temporada', question_id: 93, correct: false},
    {name_option: '7 motores por temporada', question_id: 93, correct: true},
    {name_option: '10 motores por temporada', question_id: 93, correct: false},
    {name_option: 'No hay límite de motores', question_id: 93, correct: false}

]

options.each do |option|
    existing_option = Option.find_by(name_option: option[:name_option], question_id: option[:question_id])
    Option.create(name_option: option[:name_option], question_id: option[:question_id], correct: option[:correct]) if existing_option.nil?
end
