users = [
    {username: 'Joaco', password: 'jondoe', cant_life: 3, cant_coins: 20, total_points: 0},
    {username: 'Foden', password: 'messi', cant_life: 3, cant_coins: 100, total_points: 0},
    {username: 'Juancho', password: 'Juancho1234', cant_life: 3, cant_coins: 100, total_points: 0},
    {username: 'erich', password: 'Hamilton', cant_life: 3, cant_coins: 80, total_points: 0},
]

users.each do |user|
    User.find_or_create_by(username: user[:username]) do |u|
        u.password = user[:password]
        u.cant_life = user[:cant_life]
        u.cant_coins = user[:cant_coins]
        u.total_points = user[:total_points]
    end
end

profiles = [
    {name: 'Juan Cruz', lastName: 'Gonzalez', email:'juancruzg30@gmail.com', description: 'f1 lover', age: 22, user_id: 3, profile_picture: '/profile_pictures/charles-leclerc-2024.png'},
    {name: 'Bruno', lastName: 'Conti', email:'brunocse.5@gmail.com', description: 'messi lover', age: 21, user_id: 2, profile_picture: '/profile_pictures/charles-leclerc-2024.png'},
    {name: 'Erich', lastName: 'Vollenweider', email:'vollenweidererich@gmail.com', description: 'KTM Group', age: 25, user_id: 4, profile_picture: '/profile_pictures/charles-leclerc-2024.png'},
    {name: 'Joaquin', lastName: 'Mezzano', email:'mezzanojoaquin@gmail.com', description: 'intento de programador', age: 23, user_id: 1, profile_picture: '/profile_pictures/charles-leclerc-2024.png'},
]

profiles.each do |profile|
    Profile.find_or_create_by(name: profile[:name], lastName: profile[:lastName]) do |u|
        u.email = profile[:email]
        u.description = profile[:description]
        u.age = profile[:age]
        u.user_id = profile[:user_id]
        u.profile_picture = profile[:profile_picture]
    end
end


questions = [
    {name_question: 'Who are the drivers with the most World Championships?', image_question: nil, level: 'easy', theme: 'pilot' },
    {name_question: 'Which of the following drivers is known as "The Iceman"?', image_question: nil, level: 'difficult', theme: 'pilot' },
    {name_question: 'Which driver holds the record for the most pole positions in history?', image_question: nil, level: 'normal', theme: 'pilot' },
    {name_question: 'Who is the youngest driver to have won a race?', image_question: nil, level: 'normal', theme: 'pilot' },
    {name_question: 'Which of the following drivers debuted at the youngest age in a race?', image_question: nil, level: 'difficult', theme: 'pilot' },
    {name_question: 'Which driver is known as "the professor" due to his strategy and calculation in races?', image_question: nil, level: 'difficult', theme: 'pilot' },
    {name_question: 'Which of the following drivers is the son of a world rally champion?', image_question: nil, level: 'easy', theme: 'pilot' },
    {name_question: 'Which of the mentioned drivers is Australian?', image_question: nil, level: 'normal', theme: 'pilot' },
    {name_question: 'Which driver won the most races in the Monaco Grand Prix?', image_question: nil, level: 'difficult', theme: 'pilot' },
    {name_question: 'Who is the youngest driver to win an F1 championship?', image_question: nil, level: 'normal', theme: 'pilot' },
    {name_question: 'Who is the only driver to win a championship with Renault?', image_question: nil, level: 'difficult', theme: 'pilot' },
    {name_question: 'Who is the first driver to win a race for Ferrari in history?', image_question: nil, level: 'difficult', theme: 'pilot' },
    {name_question: 'Who was the only driver to win the World Championship with Brawn GP?', image_question: nil, level: 'impossible', theme: 'pilot' },
    {name_question: 'How many world titles does former driver Juan Manuel Fangio have?', image_question: nil, level: 'normal', theme: 'pilot' },
    {name_question: 'Who is the driver with the most podiums (13) without winning a race?', image_question: nil, level: 'impossible', theme: 'pilot' },
    {name_question: 'In what year did Juan Manuel Fangio win his last world championship?', image_question: nil, level: 'difficult', theme: 'pilot' },
    {name_question: 'For which country did Emerson Fittipaldi and Felipe Massa race?', image_question: nil, level: 'easy', theme: 'pilot' },
    {name_question: 'Which drivers currently make up the MC-LAREN team?', image_question: nil, level: 'normal', theme: 'pilot' },
    {name_question: 'What nationality is former driver Sebastian Vettel?', image_question: nil, level: 'normal', theme: 'pilot' },
    {name_question: 'How many championships did Jim Clark win?', image_question: nil, level: 'difficult', theme: 'pilot' },
    {name_question: 'Which driver was involved in the remembered accident losing his life in Imola, Italy?', image_question: nil, level: 'normal', theme: 'pilot' },
    {name_question: 'What is the nationality of current driver Sergio "Checo" Perez?', image_question: nil, level: 'easy', theme: 'pilot' },
    {name_question: 'Is there currently an Argentine driver in F1?', image_question: nil, level: 'normal', theme: 'pilot' },
    {name_question: 'How many races did driver Michael Schumacher win?', image_question: nil, level: 'difficult', theme: 'pilot' },
    {name_question: 'Which driver, nicknamed “The Flying Scot,” won three World Championships in Formula 1?', image_question: nil, level: 'easy', theme: 'pilot' },

    {name_question: 'How many circuits have hosted races in the F1 world championship?', image_question: nil, level: 'normal', theme: 'circuit' },
    {name_question: 'In which circuit was the first F1 race held?', image_question: nil, level: 'easy', theme: 'circuit' },
    {name_question: 'What is the longest circuit used in the history of F1?', image_question: nil, level: 'easy', theme: 'circuit' },
    {name_question: 'How long is the longest circuit used in the history of F1?', image_question: nil, level: 'normal', theme: 'circuit' },
    {name_question: 'What is the circuit with the most editions?', image_question: nil, level: 'easy', theme: 'circuit' },
    {name_question: 'How many editions did the most used circuit have?', image_question: nil, level: 'easy', theme: 'circuit' },
    {name_question: 'Which of the following is NOT a type of circuit:', image_question: nil, level: 'normal', theme: 'circuit' },
    {name_question: 'What was the last circuit added to date?', image_question: nil, level: 'normal', theme: 'circuit' },
    {name_question: 'Which country has the most circuits in its territory?', image_question: nil, level: 'easy', theme: 'circuit' },
    {name_question: 'What is the shortest circuit used in the history of F1?', image_question: nil, level: 'difficult', theme: 'circuit' },
    {name_question: 'What is the name of the section of the Pescara circuit where Guy Moll died during 1934?', image_question: nil, level: 'difficult', theme: 'circuit' },
    {name_question: 'During which years was the Adelaide Street Circuit (Australia) active?', image_question: nil, level: 'impossible', theme: 'circuit' },
    {name_question: 'What is the name of the only Argentine circuit that was in F1?', image_question: nil, level: 'normal', theme: 'circuit' },
    {name_question: 'Which circuit is completely oval in shape?', image_question: nil, level: 'easy', theme: 'circuit' },
    {name_question: 'How many circuits are currently raced?', image_question: nil, level: 'easy', theme: 'circuit' },
    {name_question: 'Which circuit was not raced in the 21st century?', image_question: nil, level: 'difficult', theme: 'circuit' },
    {name_question: 'What is the approximate spectator capacity of the Monaco circuit?', image_question: nil, level: 'impossible', theme: 'circuit' },
    {name_question: 'Who holds the record for the fastest lap at the Monaco circuit?', image_question: nil, level: 'difficult', theme: 'circuit' },
    {name_question: 'How many corners does the Monaco circuit have?', image_question: nil, level: 'difficult', theme: 'circuit' },
    {name_question: 'What types of events do NOT take place at the Monaco circuit, aside from F1?', image_question: nil, level: 'normal', theme: 'circuit' },
    {name_question: 'What type of run-off areas does the Monza circuit NOT have?', image_question: nil, level: 'difficult', theme: 'circuit' },
    {name_question: 'Which circuit has the largest spectator capacity?', image_question: nil, level: 'normal', theme: 'circuit' },
    {name_question: 'Which circuit is over 100 years old since its first race?', image_question: nil, level: 'difficult', theme: 'circuit' },
    {name_question: 'How many circuits that were in F1 are located in South America?', image_question: nil, level: 'normal', theme: 'circuit' },
    {name_question: 'Which continent has the most circuits raced in F1?', image_question: nil, level: 'easy', theme: 'circuit' },

    {name_question: 'How many drivers does each team compete with in each race?', image_question: nil, level: 'easy', theme: 'team' },
    {name_question: 'Who are the current Red Bull drivers?', image_question: nil, level: 'easy', theme: 'team' },
    {name_question: 'Who are the current Mercedes drivers?', image_question: nil, level: 'easy', theme: 'team' },
    {name_question: 'Who are the current Ferrari drivers?', image_question: nil, level: 'easy', theme: 'team' },
    {name_question: 'Who are the current McLaren drivers?', image_question: nil, level: 'normal', theme: 'team' },
    {name_question: 'Who are the current Aston Martin drivers?', image_question: nil, level: 'normal', theme: 'team' },
    {name_question: 'Who are the current Alpine drivers?', image_question: nil, level: 'difficult', theme: 'team' },
    {name_question: 'Who are the current Williams drivers?', image_question: nil, level: 'difficult', theme: 'team' },
    {name_question: 'Who are the current RB drivers?', image_question: nil, level: 'difficult', theme: 'team' },
    {name_question: 'Who are the current Stake drivers?', image_question: nil, level: 'difficult', theme: 'team' },
    {name_question: 'Who are the current Haas drivers?', image_question: nil, level: 'difficult', theme: 'team' },
    {name_question: 'In what year did Red Bull start in motorsport?', image_question: nil, level: 'impossible', theme: 'team' },
    {name_question: 'Who was the founder of Red Bull?', image_question: nil, level: 'impossible', theme: 'team' },
    {name_question: 'What was the predecessor team to Red Bull?', image_question: nil, level: 'difficult', theme: 'team' },
    {name_question: 'What was the best position in the Constructors\' World Championship for Red Bull?', image_question: nil, level: 'normal', theme: 'team' },
    {name_question: 'What was the best position in the Drivers\' World Championship for Red Bull?', image_question: nil, level: 'normal', theme: 'team' },
    {name_question: 'What is the nationality of Red Bull?', image_question: nil, level: 'difficult', theme: 'team' },
    {name_question: 'What is the nationality of Mercedes?', image_question: nil, level: 'difficult', theme: 'team' },
    {name_question: 'Who was the founder of Mercedes?', image_question: nil, level: 'impossible', theme: 'team' },
    {name_question: 'What was the best position in the Constructors\' World Championship for Mercedes?', image_question: nil, level: 'normal', theme: 'team' },
    {name_question: 'What was the best position in the Drivers\' World Championship for Mercedes?', image_question: nil, level: 'normal', theme: 'team' },
    {name_question: 'What is the nationality of Ferrari?', image_question: nil, level: 'easy', theme: 'team' },
    {name_question: 'Who was the founder of Ferrari?', image_question: nil, level: 'normal', theme: 'team' },
    {name_question: 'What was the best position in the Constructors\' World Championship for Ferrari?', image_question: nil, level: 'normal', theme: 'team' },
    {name_question: 'What was the best position in the Drivers\' World Championship for Ferrari?', image_question: nil, level: 'normal', theme: 'team' },

    {name_question: 'What does the checkered flag indicate?', image_question: nil, level: 'easy', theme: 'career' },
    {name_question: 'What does the green flag indicate?', image_question: nil, level: 'easy', theme: 'career' },
    {name_question: 'What does the yellow flag indicate?', image_question: nil, level: 'normal', theme: 'career' },
    {name_question: 'What does the yellow flag next to sign Safety Car indicate?', image_question: nil, level: 'difficult', theme: 'career' },
    {name_question: 'What does the yellow flag next to sign Virtual Safety Car indicate?', image_question: nil, level: 'impossible', theme: 'career' },
    {name_question: 'What does the red flag indicate?', image_question: nil, level: 'easy', theme: 'career' },
    {name_question: 'What does the black flag with the driver\'s number indicate?', image_question: nil, level: 'difficult', theme: 'career' },
    {name_question: 'What does a black flag with an orange circle mean?', image_question: nil, level: 'impossible', theme: 'career' },
    {name_question: 'What does the split (black and white) flag with the number indicate?', image_question: nil, level: 'impossible', theme: 'career' },
    {name_question: 'What does the blue flag indicate?', image_question: nil, level: 'normal', theme: 'career' },
    {name_question: 'What does the yellow flag with red stripes indicate?', image_question: nil, level: 'impossible', theme: 'career' },
    {name_question: 'What does the white flag indicate?', image_question: nil, level: 'easy', theme: 'career' },
    {name_question: 'What is the qualifying system used in Formula 1?', image_question: nil, level: 'difficult', theme: 'career' },
    {name_question: 'What is the maximum number of laps allowed in a Formula 1 race?', image_question: nil, level: 'normal', theme: 'career' },
    {name_question: 'What is the approximate duration of a Formula 1 race?', image_question: nil, level: 'normal', theme: 'career' },
    {name_question: 'What is the common number of drivers on a Formula 1 starting grid?', image_question: nil, level: 'normal', theme: 'career' },
    {name_question: 'What happens if a driver consistently exceeds track limits during the race?', image_question: nil, level: 'difficult', theme: 'career' },
    {name_question: 'What is the maximum speed allowed in the pit lane during a Formula 1 race?', image_question: nil, level: 'normal', theme: 'career' },
    {name_question: 'How are drivers and teams rewarded according to their performance in the Formula 1 race?', image_question: nil, level: 'normal', theme: 'career' },
    {name_question: 'How many points does the driver who achieves the fastest lap in a race receive?', image_question: nil, level: 'easy', theme: 'career' },
    {name_question: 'How many drivers receive points at the end of each race?', image_question: nil, level: 'difficult', theme: 'career' },
    {name_question: 'In what year was the first race in F1 history??', image_question: nil, level: 'normal', theme: 'career' },
    {name_question: 'What technical regulations govern car specifications in Formula 1?', image_question: nil, level: 'difficult', theme: 'career' },
    {name_question: 'What do drivers have to do at the end of a race?', image_question: nil, level: 'impossible', theme: 'career' },
    {name_question: 'What happens if a driver ignores three consecutive blue flags?', image_question: nil, level: 'difficult', theme: 'career' },

    {name_question: 'Which driver is joining Ferrari in 2025?', image_question: nil, level: 'easy', theme: 'free' },
    {name_question: 'How do you win the drivers championship at the end of the world championship?', image_question: nil, level: 'easy', theme: 'free' },
    {name_question: 'Which driver is leaving Ferrari this year (2024)?', image_question: nil, level: 'normal', theme: 'free' },
    {name_question: 'Who was the pilot of Mercedes in 2022 accompanying Lewis Hamilton?', image_question: nil, level: 'normal', theme: 'free' },
    {name_question: 'What type of garment has to be fireproof according to the FIA regulations?', image_question: nil, level: 'difficult', theme: 'free' },
    {name_question: 'Which team has the most Constructors Championships in F1 history?', image_question: nil, level: 'difficult', theme: 'free' },
    {name_question: 'In what year were hybrid engines introduced in F1?', image_question: nil, level: 'impossible', theme: 'free' },
    {name_question: 'What are drivers prohibited from using during a race?', image_question: nil, level: 'impossible', theme: 'free' },

    {name_question: nil, image_question: '/grandprix/imagen8.png', level: 'easy', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen12.png', level: 'easy', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen16.png', level: 'easy', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen21.png', level: 'easy', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen14.png', level: 'easy', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen10.png', level: 'easy', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen9.png', level: 'easy', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen3.png', level: 'easy', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen1.png', level: 'normal', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen2.png', level: 'normal', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen7.png', level: 'normal', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen17.png', level: 'normal', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen18.png', level: 'normal', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen23.png', level: 'normal', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen24.png', level: 'normal', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen20.png', level: 'normal', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen5.png', level: 'difficult', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen13.png', level: 'difficult', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen11.png', level: 'difficult', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen15.png', level: 'difficult', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen6.png', level: 'difficult', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen19.png', level: 'difficult', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen22.png', level: 'difficult', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen4.png', level: 'difficult', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen25.png', level: 'impossible', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen26.png', level: 'impossible', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen27.png', level: 'impossible', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen28.png', level: 'impossible', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen29.png', level: 'impossible', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen30.png', level: 'impossible', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen31.png', level: 'impossible', theme: 'grandprix' },
    {name_question: nil, image_question: '/grandprix/imagen32.png', level: 'impossible', theme: 'grandprix' }
]


questions.each do |question_data|
    if question_data[:name_question].present?
        Question.find_or_create_by(name_question: question_data[:name_question]) do |q|
            q.image_question = question_data[:image_question] # Esto deberia ser nil para preguntas de texto
            q.level = question_data[:level]
            q.theme = question_data[:theme]
        end
    elsif question_data[:image_question].present?
        Question.find_or_create_by(image_question: question_data[:image_question]) do |q|
            q.name_question = question_data[:name_question] # Esto deberia ser nil para preguntas de imagen
            q.level = question_data[:level]
            q.theme = question_data[:theme]
        end
    end
end


options = [

    ######                 PILOT                     ######
    {name_option: 'Lewis Hamilton and Michael Schumacher' , question_id: 1, correct: true},
    {name_option: 'Lewis Hamilton and Esteban Ocon' , question_id: 1, correct: false},
    {name_option: 'Lewis Hamilton and Franco Colapinto' , question_id: 1, correct: false},
    {name_option: 'Lewis Hamilton and Sergio "Checo" Perez' , question_id: 1, correct: false},

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

    {name_option: 'Max Verstappen', question_id: 5, correct: true},
    {name_option: 'Sebastian Vettel', question_id: 5, correct: false},
    {name_option: 'Jose Froilan Gonzalez', question_id: 5, correct: false},
    {name_option: 'George Russell', question_id: 5, correct: false},

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

    {name_option: '5', question_id: 14, correct: true},
    {name_option: '4', question_id: 14, correct: false},
    {name_option: '3', question_id: 14, correct: false},
    {name_option: '6', question_id: 14, correct: false},

    {name_option: 'Nick Heidfeld', question_id: 15, correct: true},
    {name_option: 'Romain Grosjean', question_id: 15, correct: false},
    {name_option: 'Nico Hulkenberg', question_id: 15, correct: false},
    {name_option: 'Kevin Magnussen', question_id: 15, correct: false},

    {name_option: '1957', question_id: 16, correct: true},
    {name_option: '1956', question_id: 16, correct: false},
    {name_option: '1955', question_id: 16, correct: false},
    {name_option: '1958', question_id: 16, correct: false},

    {name_option: 'Brazil', question_id: 17, correct: true},
    {name_option: 'Argentina', question_id: 17, correct: false},
    {name_option: 'Spain', question_id: 17, correct: false},
    {name_option: 'Italy', question_id: 17, correct: false},

    {name_option: 'Lando Norris and Oscar Piastri', question_id: 18, correct: true},
    {name_option: 'Carlos Sainz and Lando Norris', question_id: 18, correct: false},
    {name_option: 'Daniel Ricciardo and Lando Norris', question_id: 18, correct: false},
    {name_option: 'Lando Norris and Stoffel Vandoorne', question_id: 18, correct: false},

    {name_option: 'German', question_id: 19, correct: true},
    {name_option: 'Austrian', question_id: 19, correct: false},
    {name_option: 'Swiss', question_id: 19, correct: false},
    {name_option: 'French', question_id: 19, correct: false},

    {name_option: '2', question_id: 20, correct: true},
    {name_option: '1', question_id: 20, correct: false},
    {name_option: '3', question_id: 20, correct: false},
    {name_option: '4', question_id: 20, correct: false},

    {name_option: 'Ayrton Senna', question_id: 21, correct: true},
    {name_option: 'Roland Ratzenberger', question_id: 21, correct: false},
    {name_option: 'Jules Bianchi', question_id: 21, correct: false},
    {name_option: 'Gilles Villeneuve', question_id: 21, correct: false},

    {name_option: 'Mexican', question_id: 22, correct: true},
    {name_option: 'Spanish', question_id: 22, correct: false},
    {name_option: 'Brazilian', question_id: 22, correct: false},
    {name_option: 'Argentinian', question_id: 22, correct: false},

    {name_option: 'No', question_id: 23, correct: true},
    {name_option: 'Yes', question_id: 23, correct: false},
    {name_option: 'Yes, in tests', question_id: 23, correct: false},
    {name_option: 'Yes, in reserve', question_id: 23, correct: false},

    {name_option: '91', question_id: 24, correct: true},
    {name_option: '85', question_id: 24, correct: false},
    {name_option: '88', question_id: 24, correct: false},
    {name_option: '95', question_id: 24, correct: false},

    {name_option: 'Jackie Stewart', question_id: 25, correct: true},
    {name_option: 'James Hunt', question_id: 25, correct: false},
    {name_option: 'Graham Hill', question_id: 25, correct: false},
    {name_option: 'Jochen Rindt', question_id: 25, correct: false},

    ######                 CIRCUIT                     ######

    {name_option: '74', question_id: 26, correct: true},
    {name_option: '75', question_id: 26, correct: false},
    {name_option: '73', question_id: 26, correct: false},
    {name_option: '78', question_id: 26, correct: false},

    {name_option: 'Albert Park', question_id: 27, correct: false},
    {name_option: 'Silverstone', question_id: 27, correct: true},
    {name_option: 'Fuji', question_id: 27, correct: false},
    {name_option: 'Jerez', question_id: 27, correct: false},

    {name_option: 'Monza', question_id: 28, correct: false},
    {name_option: 'Sochi', question_id: 28, correct: false},
    {name_option: 'Pescara', question_id: 28, correct: true},
    {name_option: 'Zolder', question_id: 28, correct: false},

    {name_option: '25.602km', question_id: 29, correct: false},
    {name_option: '25.954km', question_id: 29, correct: false},
    {name_option: '26.122km', question_id: 29, correct: false},
    {name_option: '25.801km', question_id: 29, correct: true},

    {name_option: 'Monza', question_id: 30, correct: true},
    {name_option: 'Mónaco', question_id: 30, correct: false},
    {name_option: 'Silverstone', question_id: 30, correct: false},
    {name_option: 'Hungaroring', question_id: 30, correct: false},

    {name_option: '69', question_id: 31, correct: false},
    {name_option: '72', question_id: 31, correct: true},
    {name_option: '57', question_id: 31, correct: false},
    {name_option: '75', question_id: 31, correct: false},

    {name_option: 'Autodrome', question_id: 32, correct: false},
    {name_option: 'Hybrid', question_id: 32, correct: false},
    {name_option: 'Rural', question_id: 32, correct: true},
    {name_option: 'Street circuit', question_id: 32, correct: false},

    {name_option: 'Riverside', question_id: 33, correct: false},
    {name_option: 'Miami', question_id: 33, correct: false},
    {name_option: 'Mugello', question_id: 33, correct: false},
    {name_option: 'Las Vegas', question_id: 33, correct: true},

    {name_option: 'United States', question_id: 34, correct: true},
    {name_option: 'Spain', question_id: 34, correct: false},
    {name_option: 'England', question_id: 34, correct: false},
    {name_option: 'Italy', question_id: 34, correct: false},

    {name_option: 'AVUS', question_id: 35, correct: false},
    {name_option: 'Mónaco', question_id: 35, correct: true},
    {name_option: 'Yeda', question_id: 35, correct: false},
    {name_option: 'Zolder', question_id: 35, correct: false},

    {name_option: 'The Chapel', question_id: 36, correct: false},
    {name_option: 'Mount Silvano', question_id: 36, correct: false},
    {name_option: 'The Flying Kilometer', question_id: 36, correct: true},
    {name_option: 'The Flat Point', question_id: 36, correct: false},

    {name_option: '1986-1992', question_id: 37, correct: false},
    {name_option: '1999-2009', question_id: 37, correct: false},
    {name_option: '1975-1983', question_id: 37, correct: false},
    {name_option: '1985-1995', question_id: 37, correct: true},

    {name_option: 'Oscar and Juan Gálvez', question_id: 38, correct: true},
    {name_option: 'Juan Manuel Fangio', question_id: 38, correct: false},
    {name_option: 'Julio Argentino Roca', question_id: 38, correct: false},
    {name_option: 'Diego Armando Maradona', question_id: 38, correct: false},

    {name_option: 'Jerez', question_id: 39, correct: false},
    {name_option: 'Indianapolis', question_id: 39, correct: true},
    {name_option: 'Las Vegas', question_id: 39, correct: false},
    {name_option: 'Mónaco', question_id: 39, correct: false},

    {name_option: '19', question_id: 40, correct: false},
    {name_option: '20', question_id: 40, correct: false},
    {name_option: '21', question_id: 40, correct: true},
    {name_option: '22', question_id: 40, correct: false},

    {name_option: 'Monza', question_id: 41, correct: false},
    {name_option: 'Silverstone', question_id: 41, correct: false},
    {name_option: 'Zandvoort', question_id: 41, correct: false},
    {name_option: 'Aintree', question_id: 41, correct: true},

    {name_option: '37.000', question_id: 42, correct: true},
    {name_option: '38.000', question_id: 42, correct: false},
    {name_option: '36.000', question_id: 42, correct: false},
    {name_option: '40.000', question_id: 42, correct: false},

    {name_option: 'Fernando Alonso', question_id: 43, correct: false},
    {name_option: 'Lewis Hamilton', question_id: 43, correct: true},
    {name_option: 'Rubens Barrichello', question_id: 43, correct: false},
    {name_option: 'Max Verstappen', question_id: 43, correct: false},

    {name_option: '20', question_id: 44, correct: false},
    {name_option: '21', question_id: 44, correct: false},
    {name_option: '19', question_id: 44, correct: true},
    {name_option: '22', question_id: 44, correct: false},

    {name_option: 'Fórmula 2', question_id: 45, correct: false},
    {name_option: 'Fórmula 3', question_id: 45, correct: false},
    {name_option: 'Fórmula E', question_id: 45, correct: false},
    {name_option: 'Karting', question_id: 45, correct: true},

    {name_option: 'Asphalt', question_id: 46, correct: true},
    {name_option: 'Grass', question_id: 46, correct: false},
    {name_option: 'Gravel', question_id: 46, correct: false},
    {name_option: 'Grass and Gravel', question_id: 46, correct: false},

    {name_option: 'AVUS', question_id: 47, correct: false},
    {name_option: 'Indianapolis', question_id: 47, correct: true},
    {name_option: 'Mónaco', question_id: 47, correct: false},
    {name_option: 'Enzo e Dino Ferrari', question_id: 47, correct: false},

    {name_option: 'Reims-Gueux', question_id: 48, correct: false},
    {name_option: 'Bremgarten', question_id: 48, correct: false},
    {name_option: 'None', question_id: 48, correct: true},
    {name_option: 'Silverstone', question_id: 48, correct: false},

    {name_option: '2', question_id: 49, correct: false},
    {name_option: '6', question_id: 49, correct: false},
    {name_option: '4', question_id: 49, correct: false},
    {name_option: '3', question_id: 49, correct: true},

    {name_option: 'Europe', question_id: 50, correct: true},
    {name_option: 'América', question_id: 50, correct: false},
    {name_option: 'Asia', question_id: 50, correct: false},
    {name_option: 'Ocenía', question_id: 50, correct: false},

    ######                 TEAM                     ######

    {name_option: '1 driver', question_id: 51, correct: false},
    {name_option: '2 drivers', question_id: 51, correct: true},
    {name_option: '3 drivers', question_id: 51, correct: false},
    {name_option: '4 drivers', question_id: 51, correct: false},

    {name_option: 'Max Verstappen and Sergio Perez', question_id: 52, correct: true},
    {name_option: 'Max Verstappen and Kevin Magnussen', question_id: 52, correct: false},
    {name_option: 'Max Verstappen and Pierre Gasly', question_id: 52, correct: false},
    {name_option: 'Alexander Albon and George Russell', question_id: 52, correct: false},

    {name_option: 'Lewis Hamilton and George Russell', question_id: 53, correct: true},
    {name_option: 'Lewis Hamilton and Valtteri Bottas', question_id: 53, correct: false},
    {name_option: 'Lewis Hamilton and Logan Sargeant', question_id: 53, correct: false},
    {name_option: 'Esteban Ocon and Nico Hulkenberg', question_id: 53, correct: false},

    {name_option: 'Charles Leclerc and Carlos Sainz Jr', question_id: 54, correct: true},
    {name_option: 'Charles Leclerc and Sebastian Vettel', question_id: 54, correct: false},
    {name_option: 'Charles Leclerc and Sergio Perez', question_id: 54, correct: false},
    {name_option: 'Fernando Alonso and Lewis Hamilton', question_id: 54, correct: false},

    {name_option: 'Lando Norris and Oscar Piastri', question_id: 55, correct: true},
    {name_option: 'Lando Norris and Esteban Ocon', question_id: 55, correct: false},
    {name_option: 'Lando Norris and George Russell', question_id: 55, correct: false},
    {name_option: 'Lance Stroll and Pierre Gasly', question_id: 55, correct: false},

    {name_option: 'Sebastian Vettel and Daniel Ricciardo', question_id: 56, correct: false},
    {name_option: 'Lance Stroll and Fernando Alonso', question_id: 56, correct: true},
    {name_option: 'Lance Stroll and George Russell', question_id: 56, correct: false},
    {name_option: 'Lance Stroll and Carlos Sainz Jr', question_id: 56, correct: false},

    {name_option: 'Esteban Ocon and Pierre Gasly', question_id: 57, correct: true},
    {name_option: 'Esteban Oocon and Fernando Alonso', question_id: 57, correct: false},
    {name_option: 'Esteban Ocon and Nico Rosberg', question_id: 57, correct: false},
    {name_option: 'Sergio Pérez and Alexander Albon', question_id: 57, correct: false},

    {name_option: 'Alexander Albon and Logan Sargeant', question_id: 58, correct: true},
    {name_option: 'Alexander Albon and Nicholas Latifi', question_id: 58, correct: false},
    {name_option: 'Alexander Albon and Jack Aitken', question_id: 58, correct: false},
    {name_option: 'Robert Kubica and Yuki Tsunoda', question_id: 58, correct: false},

    {name_option: 'Yuki Tsunoda and Daniel Ricciardo', question_id: 59, correct: true},
    {name_option: 'Sergio Pérez and Charles Leclerc', question_id: 59, correct: false},
    {name_option: 'Yuki Tsunoda and Pierre Gasly', question_id: 59, correct: false},
    {name_option: 'Yuki Tsunoda and Alexander Albon', question_id: 59, correct: false},

    {name_option: 'Valtteri Bottas and Guanyu Zhou', question_id: 60, correct: true},
    {name_option: 'Valtteri Bottas and Max Verstappen', question_id: 60, correct: false},
    {name_option: 'Valtteri Bottas and Logan Sargeant', question_id: 60, correct: false},
    {name_option: 'Lewis Hamilton and Carlos Sainz Jr', question_id: 60, correct: false},

    {name_option: 'Kevin Magnussen and Nico Hulkenberg', question_id: 61, correct: true},
    {name_option: 'Kevin Magnussen and Lando Norris', question_id: 61, correct: false},
    {name_option: 'Kevin Magnussen and Felipe Massa', question_id: 61, correct: false},
    {name_option: 'Fernando Alonso and Sergio Perez', question_id: 61, correct: false},

    {name_option: '1987', question_id: 62, correct: true},
    {name_option: '1988', question_id: 62, correct: false},
    {name_option: '1986', question_id: 62, correct: false},
    {name_option: '1985', question_id: 62, correct: false},

    {name_option: 'Dietrich Mateschitz', question_id: 63, correct: true},
    {name_option: 'Charlerm Yoovidhya', question_id: 63, correct: false},
    {name_option: 'Christian Horner', question_id: 63, correct: false},
    {name_option: 'Helmut Marko', question_id: 63, correct: false},

    {name_option: 'Jaguar', question_id: 64, correct: true},
    {name_option: 'Stewart Grand Prix', question_id: 64, correct: false},
    {name_option: 'Minardi', question_id: 64, correct: false},
    {name_option: 'Toro Rosso', question_id: 64, correct: false},

    {name_option: '1st place', question_id: 65, correct: true},
    {name_option: '2nd place', question_id: 65, correct: false},
    {name_option: '3rd place', question_id: 65, correct: false},
    {name_option: '4th place', question_id: 65, correct: false},

    {name_option: '1st place', question_id: 66, correct: true},
    {name_option: '2nd place', question_id: 66, correct: false},
    {name_option: '3rd place', question_id: 66, correct: false},
    {name_option: '4th place', question_id: 66, correct: false},

    {name_option: 'Austrian', question_id: 67, correct: true},
    {name_option: 'German', question_id: 67, correct: false},
    {name_option: 'British', question_id: 67, correct: false},
    {name_option: 'Italian', question_id: 67, correct: false},

    {name_option: 'Italian', question_id: 68, correct: false},
    {name_option: 'German', question_id: 68, correct: true},
    {name_option: 'British', question_id: 68, correct: false},
    {name_option: 'Austrian', question_id: 68, correct: false},

    {name_option: 'Karl Benz and Gottlieb Daimler', question_id: 69, correct: true},
    {name_option: 'Wilhelm Maybach and Gottlieb Daimler', question_id: 69, correct: false},
    {name_option: 'Ferdinand Porsche and Helmut Marko', question_id: 69, correct: false},
    {name_option: 'Karl Benz and Christian Horner', question_id: 69, correct: false},

    {name_option: '1st place', question_id: 70, correct: true},
    {name_option: '2nd place', question_id: 70, correct: false},
    {name_option: '3rd place', question_id: 70, correct: false},
    {name_option: '4th place', question_id: 70, correct: false},

    {name_option: '1st place', question_id: 71, correct: true},
    {name_option: '2nd place', question_id: 71, correct: false},
    {name_option: '3rd place', question_id: 71, correct: false},
    {name_option: '4th place', question_id: 71, correct: false},

    {name_option: 'Italian', question_id: 72, correct: true},
    {name_option: 'German', question_id: 72, correct: false},
    {name_option: 'British', question_id: 72, correct: false},
    {name_option: 'Austrian', question_id: 72, correct: false},

    {name_option: 'Enzo Ferrari', question_id: 73, correct: true},
    {name_option: 'Piero Ferrari', question_id: 73, correct: false},
    {name_option: 'Luigi Chinetti', question_id: 73, correct: false},
    {name_option: 'Niki Lauda', question_id: 73, correct: false},

    {name_option: '1st place', question_id: 74, correct: true},
    {name_option: '2nd place', question_id: 74, correct: false},
    {name_option: '3rd place', question_id: 74, correct: false},
    {name_option: '4th place', question_id: 74, correct: false},

    {name_option: '1st place', question_id: 75, correct: true},
    {name_option: '2nd place', question_id: 75, correct: false},
    {name_option: '3rd place', question_id: 75, correct: false},
    {name_option: '4th place', question_id: 75, correct: false},

    ######                 CAREER                     ######

    {name_option: 'Indicates the end of the race', question_id: 76, correct: true},
    {name_option: 'Indicates the start of the race', question_id: 76, correct: false},
    {name_option: 'Indicates danger on track', question_id: 76, correct: false},
    {name_option: 'Indicates to slow down', question_id: 76, correct: false},

    {name_option: 'Indicates that the safety car or virtual safety car is coming out', question_id: 77, correct: false},
    {name_option: 'Indicates the start of the race', question_id: 77, correct: false},
    {name_option: 'Indicates that the danger on track has ended', question_id: 77, correct: true},
    {name_option: 'Indicates the final lap', question_id: 77, correct: false},

    {name_option: 'Indicates that the driver must slow down', question_id: 78, correct: true},
    {name_option: 'Indicates the safety car is coming out', question_id: 78, correct: false},
    {name_option: 'Indicates danger on track', question_id: 78, correct: false},
    {name_option: 'Indicates to slow down', question_id: 78, correct: false},

    {name_option: 'Indicates the start of the race', question_id: 79, correct: false},
    {name_option: 'Indicates to slow down', question_id: 79, correct: false},
    {name_option: 'Indicates danger on track', question_id: 79, correct: false},
    {name_option: 'Indicates the safety car is coming out', question_id: 79, correct: true},

    {name_option: 'Indicates the safety car is coming out', question_id: 80, correct: false},
    {name_option: 'Same as with a Safety Car but the safety car does not come out', question_id: 80, correct: true},
    {name_option: 'Indicates to slow down', question_id: 80, correct: false},
    {name_option: 'Indicates the end of the race', question_id: 80, correct: false},

    {name_option: 'Indicates that the session is completely stopped', question_id: 81, correct: true},
    {name_option: 'Indicates the safety car is coming out', question_id: 81, correct: false},
    {name_option: 'Indicates danger on track', question_id: 81, correct: false},
    {name_option: 'Indicates to slow down', question_id: 81, correct: false},

    {name_option: 'Indicates that the warned driver will be excluded from the session', question_id: 82, correct: true},
    {name_option: 'Indicates that the pilot has a 10 second penalty', question_id: 82, correct: false},
    {name_option: 'Indicates driver change', question_id: 82, correct: false},
    {name_option: 'Indicates that the driver must enter the pit', question_id: 82, correct: false},

    {name_option: 'The race has benn suspended', question_id: 83, correct: false},
    {name_option: 'Mechanical problem in the car, must return to the pits', question_id: 83, correct: true},
    {name_option: 'Penalty for dangerous driving', question_id: 83, correct: false},
    {name_option: 'Return all drivers to the pits', question_id: 83, correct: false},

    {name_option: 'Warns drivers of engine failure', question_id: 84, correct: false},
    {name_option: 'Indicates to drivers to enter the pit to refuel', question_id: 84, correct: false},
    {name_option: 'Indicates to drivers to enter the pit to change tires', question_id: 84, correct: false},
    {name_option: 'Warns drivers of a dangerous or unsporting maneuver on track', question_id: 84, correct: true},

    {name_option: 'Always shown in practice and races statically at the end of the pit lane to indicate that cars are approaching', question_id: 85, correct: false},
    {name_option: 'In practice session, the driver must let a faster car pass without changing their line', question_id: 85, correct: false},
    {name_option: 'In race situation, the driver who will be lapped by another that has completed an additional lap will be alerted', question_id: 85, correct: false},
    {name_option: 'All options are correct', question_id: 85, correct: true},

    {name_option: 'Indicates to drivers that the safety car is coming out', question_id: 86, correct: false},
    {name_option: 'Indicates to drivers that there was an accident on track', question_id: 86, correct: false},
    {name_option: 'Indicates to drivers that the track conditions are not optimal for driving at the limit', question_id: 86, correct: true},
    {name_option: 'Indicates to drivers to return to the pits', question_id: 86, correct: false},

    {name_option: 'Indicates that a driver has retired from the race', question_id: 87, correct: false},
    {name_option: 'Indicates that there is an excessively slow vehicle on track, such as a crane or medical car', question_id: 87, correct: true},
    {name_option: 'Indicates the final lap of the race', question_id: 87, correct: false},
    {name_option: 'Indicates that all vehicles must return to the pits', question_id: 87, correct: false},

    {name_option: 'Practice session times', question_id: 88, correct: false},
    {name_option: 'Order of arrival in the previous race', question_id: 88, correct: false},
    {name_option: 'Driver standings based on their championship results', question_id: 88, correct: false},
    {name_option: 'Timed lap qualifying session', question_id: 88, correct: true},

    {name_option: '60 laps', question_id: 89, correct: false},
    {name_option: '100 laps', question_id: 89, correct: false},
    {name_option: '75 laps', question_id: 89, correct: false},
    {name_option: 'No lap limit', question_id: 89, correct: true},

    {name_option: '1 hour', question_id: 90, correct: false},
    {name_option: '2 hours', question_id: 90, correct: false},
    {name_option: '30 minutes', question_id: 90, correct: false},
    {name_option: 'Depends on the circuit and race conditions', question_id: 90, correct: true},

    {name_option: '18 drivers', question_id: 91, correct: false},
    {name_option: '20 drivers', question_id: 91, correct: true},
    {name_option: '22 drivers', question_id: 91, correct: false},
    {name_option: '24 drivers', question_id: 91, correct: false},

    {name_option: 'A time penalty is awarded at the end of the race', question_id: 92, correct: false},
    {name_option: 'Receives a warning from the team', question_id: 92, correct: false},
    {name_option: 'May receive a time penalty or a drive-through', question_id: 92, correct: true},
    {name_option: 'No consequences', question_id: 92, correct: false},

    {name_option: '80 km/h', question_id: 93, correct: true},
    {name_option: '100 km/h', question_id: 93, correct: false},
    {name_option: '120 km/h', question_id: 93, correct: false},
    {name_option: '150 km/h', question_id: 93, correct: false},

    {name_option: 'By the maximun speed reached', question_id: 94, correct: false},
    {name_option: 'By the amount of progress', question_id: 94, correct: false},
    {name_option: 'For the total race time', question_id: 94, correct: false},
    {name_option: 'By the specific scoring system', question_id: 94, correct: true},

    {name_option: '2 points', question_id: 95, correct: false},
    {name_option: '1 point', question_id: 95, correct: true},
    {name_option: '5 point', question_id: 95, correct: false},
    {name_option: 'Does not receive points', question_id: 95, correct: false},

    {name_option: 'The first 5 pilots', question_id: 96, correct: false},
    {name_option: 'The first 10 pilots', question_id: 96, correct: true},
    {name_option: 'The first 8 pilots', question_id: 96, correct: false},
    {name_option: 'All drivers who finish the race', question_id: 96, correct: false},

    {name_option: '1965', question_id: 97, correct: false},
    {name_option: '1950', question_id: 97, correct: true},
    {name_option: '1955', question_id: 97, correct: false},
    {name_option: '1953', question_id: 97, correct: false},

    {name_option: 'Satefy regulations', question_id: 98, correct: false},
    {name_option: 'Race rules', question_id: 98, correct: false},
    {name_option: 'Technical regulations', question_id: 98, correct: true},
    {name_option: 'Classification rules', question_id: 98, correct: false},

    {name_option: 'Weight himself', question_id: 99, correct: false},
    {name_option: 'Weigh yourself without touching anyone', question_id: 99, correct: true},
    {name_option: 'Take a bath', question_id: 99, correct: false},
    {name_option: 'None is correct', question_id: 99, correct: false},

    {name_option: 'Get a warning', question_id: 100, correct: false},
    {name_option: 'He is disqualified from the race', question_id: 100, correct: true},
    {name_option: 'Receive a time penalty', question_id: 100, correct: false},
    {name_option: 'Lose points in the championship', question_id: 100, correct: false},

    ######                 FREES                     ######

    {name_option: 'Lewis Hamilton' , question_id: 101, correct: true},
    {name_option: 'Esteban Ocon' , question_id: 101, correct: false},
    {name_option: 'Franco Colapinto' , question_id: 101, correct: false},
    {name_option: 'Sergio "Checo" Perez' , question_id: 101, correct: false},

    {name_option: 'The one with the most points' , question_id: 102, correct: true},
    {name_option: 'Winning the last race' , question_id: 102, correct: false},
    {name_option: 'The one with the fewest penalties' , question_id: 102, correct: false},
    {name_option: 'Whoever has the fastest lap in the last race' , question_id: 102, correct: false},

    {name_option: 'Michael Schumacher' , question_id: 103, correct: false},
    {name_option: 'Carlos Sainz jr' , question_id: 103, correct: true},
    {name_option: 'Lando Norris' , question_id: 103, correct: false},
    {name_option: 'Romain Grosjean' , question_id: 103, correct: false},

    {name_option: 'Valtteri Bottas', question_id: 104, correct: true},
    {name_option: 'Carlos Sainz jr', question_id: 104, correct: false},
    {name_option: 'Charles Leclerc', question_id: 104, correct: false},
    {name_option: 'Juan Manuel Fangio', question_id: 104, correct: false},

    {name_option: 'Nomex, Gloves and Helmets' , question_id: 105, correct: true},
    {name_option: 'Nomex and Gloves' , question_id: 105, correct: false},
    {name_option: 'Nomex and Helmets' , question_id: 105, correct: false},
    {name_option: 'Nomex, Gloves, Helmets and underwear' , question_id: 105, correct: false},

    {name_option: 'Ferrari' , question_id: 106, correct: true},
    {name_option: 'Mercedes' , question_id: 106, correct: false},
    {name_option: 'RB' , question_id: 106, correct: false},
    {name_option: 'Red Bull' , question_id: 106, correct: false},

    {name_option: '2014' , question_id: 107, correct: true},
    {name_option: '2013' , question_id: 107, correct: false},
    {name_option: '2015' , question_id: 107, correct: false},
    {name_option: '2012' , question_id: 107, correct: false},

    {name_option: 'Jewelry' , question_id: 108, correct: true},
    {name_option: 'They have no prohibitions' , question_id: 108, correct: false},
    {name_option: 'Very long hair' , question_id: 108, correct: false},
    {name_option: 'Maximum weight' , question_id: 108, correct: false},

    #####                 GRAND PRIX                     ######

    {name_option: 'Monaco' , question_id: 109, correct: true},
    {name_option: 'Montjuic' , question_id: 109, correct: false},
    {name_option: 'Motorsport Park' , question_id: 109, correct: false},
    {name_option: 'Nelson Piquet' , question_id: 109, correct: false},

    {name_option: 'Silverstone' , question_id: 110, correct: true},
    {name_option: 'Sochi' , question_id: 110, correct: false},
    {name_option: 'Jeddah' , question_id: 110, correct: false},
    {name_option: 'Zolder' , question_id: 110, correct: false},

    {name_option: 'Monza' , question_id: 111, correct: true},
    {name_option: 'Nordschleife' , question_id: 111, correct: false},
    {name_option: 'Phoenix' , question_id: 111, correct: false},
    {name_option: 'Nelson Piquet' , question_id: 111, correct: false},

    {name_option: 'Sao Paulo' , question_id: 112, correct: true},
    {name_option: 'Pescara' , question_id: 112, correct: false},
    {name_option: 'Montreal' , question_id: 112, correct: false},
    {name_option: 'Baku' , question_id: 112, correct: false},

    {name_option: 'Spa-Francorchamps' , question_id: 113, correct: true},
    {name_option: 'Lusail' , question_id: 113, correct: false},
    {name_option: 'Mexico City' , question_id: 113, correct: false},
    {name_option: 'Pescara' , question_id: 113, correct: false},

    {name_option: 'Barcelona-Cataluna' , question_id: 114, correct: true},
    {name_option: 'Austin' , question_id: 114, correct: false},
    {name_option: 'Baku' , question_id: 114, correct: false},
    {name_option: 'Miami' , question_id: 114, correct: false},

    {name_option: 'Montreal' , question_id: 115, correct: true},
    {name_option: 'Nordschleife' , question_id: 115, correct: false},
    {name_option: 'Nurburgring' , question_id: 115, correct: false},
    {name_option: 'Pescara' , question_id: 115, correct: false},

    {name_option: 'Melbourne' , question_id: 116, correct: true},
    {name_option: 'Montreal' , question_id: 116, correct: false},
    {name_option: 'Miami' , question_id: 116, correct: false},
    {name_option: 'Monza' , question_id: 116, correct: false},

    {name_option: 'Sakhir' , question_id: 117, correct: true},
    {name_option: 'Americas' , question_id: 117, correct: false},
    {name_option: 'AVUS' , question_id: 117, correct: false},
    {name_option: 'Baku' , question_id: 117, correct: false},

    {name_option: 'Jeddah' , question_id: 118, correct: true},
    {name_option: 'Austin' , question_id: 118, correct: false},
    {name_option: 'Sao Paulo' , question_id: 118, correct: false},
    {name_option: 'Silverstone' , question_id: 118, correct: false},

    {name_option: 'Imola' , question_id: 119, correct: true},
    {name_option: 'Lusail' , question_id: 119, correct: false},
    {name_option: 'Spa-Francorchamps' , question_id: 119, correct: false},
    {name_option: 'Losail' , question_id: 119, correct: false},

    {name_option: 'Baku' , question_id: 120, correct: true},
    {name_option: 'Aintree' , question_id: 120, correct: false},
    {name_option: 'Fuji' , question_id: 120, correct: false},
    {name_option: 'Losail' , question_id: 120, correct: false},

    {name_option: 'Singapore' , question_id: 121, correct: true},
    {name_option: 'Monsanto Park' , question_id: 121, correct: false},
    {name_option: 'Monza' , question_id: 121, correct: false},
    {name_option: 'Losail' , question_id: 121, correct: false},

    {name_option: 'Lusail' , question_id: 122, correct: true},
    {name_option: 'Buddh' , question_id: 122, correct: false},
    {name_option: 'Sochi' , question_id: 122, correct: false},
    {name_option: 'Las Vegas Strip' , question_id: 122, correct: false},

    {name_option: 'Yas Marina' , question_id: 123, correct: true},
    {name_option: 'Hermanos Rodriguez' , question_id: 123, correct: false},
    {name_option: 'Jeddah' , question_id: 123, correct: false},
    {name_option: 'Fuji' , question_id: 123, correct: false},

    {name_option: 'Mexico City' , question_id: 124, correct: true},
    {name_option: 'Estambul' , question_id: 124, correct: false},
    {name_option: 'Watkins Glen' , question_id: 124, correct: false},
    {name_option: 'Zeltweg' , question_id: 124, correct: false},

    {name_option: 'Shanghai' , question_id: 125, correct: true},
    {name_option: 'Singapore' , question_id: 125, correct: false},
    {name_option: 'Las Vegas' , question_id: 125, correct: false},
    {name_option: 'Monza' , question_id: 125, correct: false},

    {name_option: 'Hungaroring' , question_id: 126, correct: true},
    {name_option: 'Adelaida' , question_id: 126, correct: false},
    {name_option: 'Algarve' , question_id: 126, correct: false},
    {name_option: 'Buddh' , question_id: 126, correct: false},

    {name_option: 'Red Bull Ring' , question_id: 127, correct: true},
    {name_option: 'Reims-Gueux' , question_id: 127, correct: false},
    {name_option: 'Monaco' , question_id: 127, correct: false},
    {name_option: 'Miami' , question_id: 127, correct: false},

    {name_option: 'Zandvoort' , question_id: 128, correct: true},
    {name_option: 'Suzuka' , question_id: 128, correct: false},
    {name_option: 'Montreal' , question_id: 128, correct: false},
    {name_option: 'Montjuic' , question_id: 128, correct: false},

    {name_option: 'Miami' , question_id: 129, correct: true},
    {name_option: 'Oscar y Juan Galvez' , question_id: 129, correct: false},
    {name_option: 'Spielberg' , question_id: 129, correct: false},
    {name_option: 'Budapest' , question_id: 129, correct: false},

    {name_option: 'Austin' , question_id: 130, correct: true},
    {name_option: 'Bugatti' , question_id: 130, correct: false},
    {name_option: 'Mugello' , question_id: 130, correct: false},
    {name_option: 'Okayama' , question_id: 130, correct: false},

    {name_option: 'Las Vegas Strip' , question_id: 131, correct: true},
    {name_option: 'Kyalami' , question_id: 131, correct: false},
    {name_option: 'Nelson Piquet' , question_id: 131, correct: false},
    {name_option: 'Austin' , question_id: 131, correct: false},

    {name_option: 'Suzuka' , question_id: 132, correct: true},
    {name_option: 'Yas Marina' , question_id: 132, correct: false},
    {name_option: 'Zandvoort' , question_id: 132, correct: false},
    {name_option: 'Mexico City' , question_id: 132, correct: false},

    {name_option: 'Monaco' , question_id: 133, correct: true},
    {name_option: 'Kyalami' , question_id: 133, correct: false},
    {name_option: 'Nelson Piquet' , question_id: 133, correct: false},
    {name_option: 'Austin' , question_id: 133, correct: false},

    {name_option: 'Silverstone' , question_id: 134, correct: true},
    {name_option: 'Oscar y Juan Galvez' , question_id: 134, correct: false},
    {name_option: 'Spielberg' , question_id: 134, correct: false},
    {name_option: 'Budapest' , question_id: 134, correct: false},

    {name_option: 'Monza' , question_id: 135, correct: true},
    {name_option: 'Aintree' , question_id: 135, correct: false},
    {name_option: 'Fuji' , question_id: 135, correct: false},
    {name_option: 'Losail' , question_id: 135, correct: false},

    {name_option: 'Sao Paulo' , question_id: 136, correct: true},
    {name_option: 'Kyalami' , question_id: 136, correct: false},
    {name_option: 'Nelson Piquet' , question_id: 136, correct: false},
    {name_option: 'Austin' , question_id: 136, correct: false},

    {name_option: 'Spa-Francorchamps' , question_id: 137, correct: true},
    {name_option: 'Nordschleife' , question_id: 137, correct: false},
    {name_option: 'Nurburgring' , question_id: 137, correct: false},
    {name_option: 'Pescara' , question_id: 137, correct: false},

    {name_option: 'Barcelona-Cataluna' , question_id: 138, correct: true},
    {name_option: 'Austin' , question_id: 138, correct: false},
    {name_option: 'Sao Paulo' , question_id: 138, correct: false},
    {name_option: 'Silverstone' , question_id: 138, correct: false},

    {name_option: 'Montreal' , question_id: 139, correct: true},
    {name_option: 'Oscar y Juan Galvez' , question_id: 139, correct: false},
    {name_option: 'Spielberg' , question_id: 139, correct: false},
    {name_option: 'Budapest' , question_id: 139, correct: false},

    {name_option: 'Melbourne' , question_id: 140, correct: true},
    {name_option: 'Aintree' , question_id: 140, correct: false},
    {name_option: 'Fuji' , question_id: 140, correct: false},
    {name_option: 'Losail' , question_id: 140, correct: false},


]
options.each do |option|
    existing_option = Option.find_by(name_option: option[:name_option], question_id: option[:question_id])
    Option.create(name_option: option[:name_option], question_id: option[:question_id], correct: option[:correct]) if existing_option.nil?
end
