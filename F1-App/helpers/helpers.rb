# frozen_string_literal: true

# modulo AppHelpers para manejar las sessiones y redirecciones
module AppHelpers
  def set_message_and_redirect(message, color, redirect_path = '/gamemodes')
    session[:message] = message
    session[:color] = color
    redirect redirect_path
  end

  def set_difficulty_and_message_grandprix(difficult, message)
    session[:grandprix_mode_difficulty] = difficult
    session[:message] = message
  end

  def set_difficulty_and_message_free(difficult, message)
    session[:free_mode_difficulty] = difficult
    session[:message] = message
  end

  def set_message(message, color)
    session[:message] = message
    session[:color] = color
  end

  def set_inmunity_and_message(inmunity, message, color)
    session[:inmunity] = inmunity
    session[:message] = message
    session[:color] = color
  end
end
