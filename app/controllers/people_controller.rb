class PeopleController < ApplicationController
  
  def index
    @people = Person.all
  end
  
  def new
    @person = Person.new
    @family = @person.family
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
    @family = @person.family
  end

  def edit
    @person = Person.find(params[:id])
    @family = @person.family
    @suggestions = Person.all
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

  def autocomplete
    results = AutocompleteSearchService.new(params[:query], sex: params[:sex]).call
    render json: results
  end

  def relationship
    relationship = Person.relationship_info(params[:id], params[:relation_id])
    render json: relationship
  end


  private

  def person_params
    params.require(:person)
          .permit(:name, :sex, :title, :birth_date, :death_date, :father_id, :mother_id)
  end



end
