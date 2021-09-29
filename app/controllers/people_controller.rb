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
      redirect_to :new_person, notice: "Person could not be created"
    end
  end

  def show
    @person = Person.find(params[:id])
    @parents = @person.parents
  end

  def edit
    @person = Person.find(params[:id])
    p @person.parents
    @mother = @person.parents[:female]
    @father = @person.parents[:male]
  end

  def update
    @person = Person.find(params[:id])
    if @person.update(person_params)
      redirect_to person_path(@person)
    else
      redirect_to :edit_person, notice: "Person could not be updated"
    end
  end

  def destroy
    @person = Person.find(params[:id])
    if @person.destroy
      redirect_to :people
    else
      flash[:notice] = @person.errors.messages[:base][0]
      redirect_back(fallback_location: root_url)
    end
  end


  private

  def parent_ids
    ["mother", "father"].reduce({}) do |parent_ids_hash, parent_name|
      parent = Person.find_by(
        name: params[:person]["#{parent_name}_name"], 
        title: params[:person]["#{parent_name}_title"]
      )
      parent_ids_hash["#{parent_name}_id"] = parent.id if parent
      parent_ids_hash
    end
  end

  def person_params
    p parent_ids
    params.require(:person)
          .permit(:name, :sex, :title, :birth_date, :death_date)
          .merge(parent_ids)
  end



end
