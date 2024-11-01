# frozen_string_literal: true

# Modulo que contiene metodos para la logica del modo de juego Grand Prix
module GrandPrixLogic
  # Metodo que maneja lo que pasa cuando el tiempo para responder se acaba
  def handle_grandprix_timeout
    # Restamos 1 vida al usuario
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
    # Verificamos si el usuario puede seguir jugando o no
    if @current_user.cant_life.zero?
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      redirect '/gamemodes'
    else
      session[:message] = "Time's up! Incorrect!"
      session[:color] = 'red'
    end
  end

  # Metodo que maneja la opcion seleccionada por el usuario
  def handle_grandprix_option_submission
    # Si el usuario selecciono una opcion
    if params[:option_id].to_i.positive?
      # Buscamos la opcion y su pregunta relacionada
      @option = Option.find(params[:option_id].to_i)
      @question = @option.question
      # Si la opcion es correcta
      if @option.correct
        Answer.create(question_id: @question.id, user_id: @current_user.id, option_id: @option.id)
        # Incrementa la columna 'correct' en la pregunta que fue contestada correctamente
        @question.increment!(:correct)
        @current_user.increment!(:cant_coins, 10)
        @current_user.increment!(:total_points, 50 * @current_user.racha)
        @current_user.increment!(:racha)
        session[:message] = 'Correct! Well done.'
        session[:color] = 'green'
      elsif session[:inmunity]
        # Si la opcion es incorrecta pero tiene la inmunidad activada
        session[:inmunity] = false
        session[:message] = 'Activate inmunity'
        session[:color] = 'green'
      else
        # Si la opcion es incorrecta y no tiene la inmunidad activada llamamos
        # al metodo que maneja la respuesta incorrecta
        handle_grandprix_incorrect_answer
      end
      # Guardamos la pregunta respondida asi no vuelve a aparecer
      (session[:answered_grandprix_questions] ||= []) << @question.id
    elsif session[:inmunity]
      # Si el usuario no selecciono una opcion pero tiene la inmundad activada
      session[:inmunity] = false
      session[:message] = 'Activate inmunity'
      session[:color] = 'green'
    else
      # Si el usuario no selecciono ninguna opcion
      session[:message] = 'Invalid option ID'
      session[:color] = 'red'
      redirect '/gamemodes'
    end
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
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      redirect '/gamemodes'
    else
      session[:message] = 'Incorrect!'
      session[:color] = 'red'
    end
  end
end
