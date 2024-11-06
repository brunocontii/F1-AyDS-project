# frozen_string_literal: true

# Modulo que contiene metodos para la logica del modo de juego Free
module FreeLogic
  include AppHelpers

  def next_question
    answered_by_user_ids = Answer.where(user_id: @current_user.id).pluck(:question_id)
    # Preguntas que aún no han sido respondidas en esta dificultad
    unanswered_questions = Question.where(level: session[:free_mode_difficulty], theme: 'free')
                                   .where.not(id: answered_by_user_ids)
                                   .order('RANDOM()')
    # Seleccionar la siguiente pregunta
    if unanswered_questions.exists?
      @question = unanswered_questions.first
    else
      handle_difficulty_progression
    end
  end

  # metodo que maneja las diferentes dificultades
  def handle_difficulty_progression
    @question = Question.where(level: session[:free_mode_difficulty])
                        .order('RANDOM()').first
    advance_difficulty
  end

  # Metodo que maneja lo que pasa cuando el tiempo para responder se acaba
  def handle_free_timeout
    # Restamos 1 vida al usuario
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
    # Verificamos si el usuario puede seguir jugando o no
    if @current_user.cant_life.zero?
      set_message_and_redirect('You have 0 lives. Please wait for lives to regenerate.', 'red')
    else
      set_message("Time's up! Incorrect!", 'red')
    end
  end

  # Metodo que maneja la opcion seleccionada por el usuario
  def handle_free_option_submission
    # Si el usuario selecciono una opcion
    if params[:option_id].to_i.positive?
      handle_free_option_submission_correct
    elsif session[:inmunity]
      # Si el usuario no selecciono una opcion pero tiene la inmundad activada
      set_inmunity_and_message(false, 'Activate inmunity', 'green')
    else
      # Si el usuario no selecciono ninguna opcion
      set_message_and_redirect('Invalid option ID', 'red')
    end
  end

  def handle_free_option_submission_correct
    @option = Option.find(params[:option_id].to_i)
    @question = @option.question
    process_answer
    (session[:answered_free_questions] ||= []) << @question.id
  end

  # Metodo que maneja lo que pasa cuando la respuesta es incorrecta
  def handle_free_incorrect_answer
    # Incrementa la columna 'incorrect' en la pregunta que fue contestada incorrectamente
    @question.increment!(:incorrect)
    # Reseteamos la recha y le restamos 1 vida
    @current_user.update(racha: 1)
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
    # Verificamos que el usuario pueda seguir jugando
    if @current_user.cant_life.zero?
      set_message_and_redirect('You have 0 lives. Please wait for lives to regenerate.', 'red')
    else
      set_message('Incorrect!', 'red')
    end
  end

  private

  def advance_difficulty
    case session[:free_mode_difficulty]
    when 'easy'
      set_difficulty_and_message_free('normal', "You've answered all the easy questions. Now the medium questions.")
    when 'normal'
      set_difficulty_and_message_free('difficult', "You've answered all the medium questions. Now the hard questions.")
    when 'difficult'
      set_difficulty_and_message_free('impossible',
                                      "You've answered all the hard questions. Now the impossible questions.")
    when 'impossible'
      set_difficulty_and_message_free('easy', "Congratulations! You've completed the Free Mode.")
      session[:answered_free_questions] = []
      session[:reset_free_mode] = true
      redirect '/gamemodes'
    end
    redirect '/gamemodes/free'
  end

  def process_answer
    if @option.correct
      Answer.create(question_id: @question.id, user_id: @current_user.id, option_id: @option.id)
      @question.increment!(:correct)
      update_user_stats(10, 50 * @current_user.racha)
      set_message('Correct! Well done.', 'green')
    elsif session[:inmunity]
      set_inmunity_and_message(false, 'Activate inmunity', 'green')
    else
      handle_free_incorrect_answer
    end
  end

  def update_user_stats(coins, points)
    @current_user.increment!(:cant_coins, coins)
    @current_user.increment!(:total_points, points)
    @current_user.increment!(:racha)
  end
end
