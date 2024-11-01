# frozen_string_literal: true

# Modulo que contiene metodos para la logica del modo de juego Progressive
module ProgressiveLogic
  def handle_timeout
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
    if @current_user.cant_life.zero?
      session[:message] = 'You have 0 lives. Please wait for lives to regenerate.'
      session[:color] = 'red'
      redirect '/gamemodes'
    else
      session[:message] = "Time's up! Incorrect!"
      session[:color] = 'red'
    end
  end

  def handle_option_submission
    if params[:option_id].to_i.positive?
      @option = Option.find(params[:option_id].to_i)
      @question = @option.question
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
        session[:inmunity] = false
        session[:message] = 'Activate inmunity'
        session[:color] = 'green'
      else
        handle_incorrect_answer
      end
      (session[:answered_questions] ||= []) << @question.id
    elsif session[:inmunity]
      session[:inmunity] = false
      session[:message] = 'Activate inmunity'
      session[:color] = 'green'
    else
      session[:message] = 'Invalid option ID'
      session[:color] = 'red'
      redirect '/gamemodes'
    end
  end

  def handle_incorrect_answer
    # Incrementa la columna 'incorrect' en la pregunta que fue contestada incorrectamente
    @question.increment!(:incorrect)
    @current_user.update(racha: 1)
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
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