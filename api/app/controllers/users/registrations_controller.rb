# I setup authentication following this tutorial: https://sdrmike.medium.com/rails-7-api-only-app-with-devise-and-jwt-for-authentication-1397211fb97c
# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix
  respond_to :json


  # Code taken from: https://sdrmike.medium.com/rails-7-api-only-app-with-devise-and-jwt-for-authentication-1397211fb97c
  private
  def respond_with(current_user, _opts = {})
    # If the user was created successfully
    if resource.persisted?
      render json: {
        status: {code: 200, message: 'Signed up successfully.'},
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }
      
    # If the user couldn't be created 
    else

      error_message = create_error_message current_user.errors.full_messages

      render json: {
        status: {message: "User not created. #{error_message}"}
      }, status: :unprocessable_entity
    end
  end

  # Sometimes the API responds with duplicate error messages (i.e, "Email has already been taken and Email has already been taken").
  # This fixes that and returns the error message to be displayed
  private
  def create_error_message(errors)
    # Removes all duplicate errors in the array
    errors = errors.uniq

    # If there's only one error, just return that string
    if errors.length() == 0
      return errors[0]
    else
      return errors.join(seperator = " and ")
    end
  end
end
