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

questions.each do |question|
    options = Option.where(question_id: question.id).to_a
    correct_option = options.find(&:correct)
    incorrect_options = options - [correct_option]
    shuffled_options = [correct_option] + incorrect_options.shuffle
    shuffled_options.each do |option|
        option.save
    end
end

options = [
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
    {name_option: 'Kevin Magnussen', question_id: 14, correct: false}
]

options.each do |option|
    existing_option = Option.find_by(name_option: option[:name_option], question_id: option[:question_id])
    Option.create(name_option: option[:name_option], question_id: option[:question_id], correct: option[:correct]) if existing_option.nil?
end