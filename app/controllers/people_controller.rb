class PeopleController < ApplicationController
  
  def index
    @people = Person.all
  end
  
  def new
    @person = Person.new
  end

  def create
    @person = Person.new(person_params)
    if @person.save
      redirect_to person_path(@person)
    else
      #Something else should be done here
      redirect_to :new_person, notice: @person.errors.full_messages
    end
  end

  def show
    @person = Person.find(params[:id])
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update(person_params)
      redirect_to person_path(@person)
    else
      #Something else should be done here
      redirect_to :edit_person, notice: @person.errors.full_messages
    end
  end

  def destroy
    @person = Person.find(params[:id])
    if @person.destroy
      redirect_to :people
    else
      #Something else should be done here
      redirect_to :back, notice: "Person could not be destroyed"
    end
  end


  private
  def person_params
    params.require(:person).permit(
      :name,
      :sex,
      :birth_date, 
      :death_date, 
      :mother_name, 
      :father_name
    )
  end



end
