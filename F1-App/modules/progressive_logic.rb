# frozen_string_literal: true

# Modulo que contiene metodos para la logica del modo de juego Progressive
module ProgressiveLogic
  include AppHelpers

  def handle_timeout
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
    if @current_user.cant_life.zero?
      set_message_and_redirect('You have 0 lives. Please wait for lives to regenerate.', 'red')
    else
      set_message("Time's up! Incorrect!", 'red')
    end
  end

  def handle_option_submission
    if params[:option_id].to_i.positive?
      @option = Option.find(params[:option_id].to_i)
      @question = @option.question
      process_answer
      (session[:answered_questions] ||= []) << @question.id
    elsif session[:inmunity]
      set_inmunity_and_message(false, 'Activate inmunity', 'green')
    else
      set_message_and_redirect('Invalid option ID', 'red')
    end
  end

  def handle_incorrect_answer
    # Incrementa la columna 'incorrect' en la pregunta que fue contestada incorrectamente
    @question.increment!(:incorrect)
    @current_user.update(racha: 1)
    @current_user.update(cant_life: @current_user.cant_life - 1, last_life_lost_at: Time.now)
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
      handle_incorrect_answer
    end
  end

  def update_user_stats(coins, points)
    @current_user.increment!(:cant_coins, coins)
    @current_user.increment!(:total_points, points)
    @current_user.increment!(:racha)
  end
end
