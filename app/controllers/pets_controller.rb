class PetsController < ApplicationController
  def index
    # since you dont need to use this outside of method it can be local variable
    pets = Pet.all
    render :json => pets.as_json(only: [:id, :name, :age, :human]), :status => :ok
  end

  # find and find_by have different effects

  def show
    pet = Pet.find_by(id: params[:id])

    if pet
      render :json =>
      pet.as_json(:only => [:id,:name, :age, :human]), :status => :ok
      puts "Found the pet #{pet}"
    else
      render :json => [], :status => :no_content
    end
  end



# http://localhost:3000/pets/search?query=Horsetooth
  def search
    pets = Pet.where(name: params[:query])
    unless pets.empty?
      render :json => pets.as_json(except: [:created_at, :updated_at]), :status => :ok
    else
      render :json => [], :status => :no_content
    end

  end


end
