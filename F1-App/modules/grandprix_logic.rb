# frozen_string_literal: true

# Modulo que contiene metodos para la logica del modo de juego Grand Prix
module GrandPrixLogic
  include AppHelpers

  # Metodo que maneja lo que pasa cuando el tiempo para responder se acaba
  def handle_grandprix_timeout
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
  def handle_grandprix_option_submission
    # Si el usuario selecciono una opcion
    if params[:option_id].to_i.positive?
      handle_grandprix_option_submission_correct
    elsif session[:inmunity]
      # Si el usuario no selecciono una opcion pero tiene la inmundad activada
      set_inmunity_and_message(false, 'Activate inmunity', 'green')
    else
      # Si el usuario no selecciono ninguna opcion
      set_message_and_redirect('Invalid option ID', 'red')
    end
  end

  def handle_grandprix_option_submission_correct
    @option = Option.find(params[:option_id].to_i)
    @question = @option.question
    process_answer
    (session[:answered_grandprix_questions] ||= []) << @question.id
  end

  # Metodo que maneja lo que pasa cuando la respuesta es incorrecta
  def handle_grandprix_incorrect_answer
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

  def process_answer
    if @option.correct
      Answer.create(question_id: @question.id, user_id: @current_user.id, option_id: @option.id)
      @question.increment!(:correct)
      update_user_stats(10, 50 * @current_user.racha)
      set_message('Correct! Well done.', 'green')
    elsif session[:inmunity]
      set_inmunity_and_message(false, 'Activate inmunity', 'green')
    else
      handle_grandprix_incorrect_answer
    end
  end

  def update_user_stats(coins, points)
    @current_user.increment!(:cant_coins, coins)
    @current_user.increment!(:total_points, points)
    @current_user.increment!(:racha)
  end
end
