class SessionsController < ApplicationController

    def login
        user = User.includes(stories: [:quote]).find_by(email: session_params[:email])
        if(user && user.authenticate(session_params[:password]))
            token = UserManager::FirebaseAuth.generate_token(user)
            render json: {token: token, user: UserBlueprint.render(user, view: :profile)}
        else 
            render json: "Invalid email or password", status: :not_acceptable
        end
    end

    def signup
        user = User.new(session_params)
        if(user.save)
            token = UserManager::FirebaseAuth.generate_token(user)
            dynamodb_response = FaradayClient.new.create_dynamodb_user(user.id)
            if !dynamodb_response.success?
                # @TODO: send request to a background worker for a retry
            end
            render json: {token: token, user: UserBlueprint.render(user, view: :profile)}, status: :created
        else
            render json: user.errors.full_messages.join("; "), status: :not_acceptable
        end
    end

    private
    def session_params
        params.require(:session).permit(:first_name, :last_name, :email, :password)
    end

end