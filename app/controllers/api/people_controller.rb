module Api
  class PeopleController < ApplicationController

    def index
      @people = Person.order("id")
    end

    def create
      @person = Person.new
      save_person
    end

    def update
      @person = Person.find(params[:id])
      save_person
    end

    def destroy
      Person.find_by_id(params[:id]).try(:destroy)
      render nothing: true
    end

    protected

    def save_person
      json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
      @person.attributes = json_params.permit(:first_name, :last_name, :address)
      if @person.save
        render :show
      else
        error_hash = {
          full_messages: @person.errors.full_messages,
          fields: @person.errors.keys
        }
        render json: error_hash, status: 422
      end
    end

  end
end