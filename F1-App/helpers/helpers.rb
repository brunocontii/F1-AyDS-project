# frozen_string_literal: true

# AppHelpers module provides helper methods for managing sessions
# and other utility functions in the application.
module AppHelpers
  def set_message_and_redirect(message, color, redirect_path = '/gamemodes')
    session[:message] = message
    session[:color] = color
    redirect redirect_path
  end

  def set_difficulty_and_message(difficult, message)
    session[:grandprix_mode_difficulty] = difficult
    session[:message] = message
  end
end
