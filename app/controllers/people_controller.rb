class PeopleController < ApplicationController
  before_action :authenticate_admin!, except: [:index, :show, :autocomplete, :relationship]
  def index
    @people = Person.all
  end
  
  def new
    @person = Person.new
    @family = Family.new(@person)
  end

  def create
    @person = Person.new(person_params)
    if set_consorts(@person) && @person.save
      redirect_to person_path(@person)
    else
      redirect_to :new_person, notice: @person.errors.full_messages[0]
    end
  end

  def show
    @person = Person.find(params[:id])
    @family = Family.new(@person)
  end

  def edit
    @person = Person.find(params[:id])
    @family = Family.new(@person)
    @suggestions = Person.all
  end

  def update
    @person = Person.find(params[:id])
    if set_consorts(@person) && @person.update(person_params)
      redirect_to person_path(@person)
    else
      redirect_to :edit_person, notice: @person.errors.full_messages[0]
    end
  end

  def destroy
    @person = Person.find(params[:id])
    if @person.destroy
      redirect_to :people, notice: "#{@person.name} succesfully deleted"
    else
      flash[:notice] = @person.errors.messages[:base][0]
      redirect_back(fallback_location: root_url)
    end
  end

  def search
    person_name = params[:person_search][:query]
    @person = SearchService.new(person_name).call[:people][0]
    p "Hey!!!"
    p @person
    if @person
      redirect_to person_path(@person)
    else
      redirect_back(fallback_location: root_url, notice: "No person matches #{person_name}")
    end
  end

  def autocomplete
    results = SearchService.new(params[:query], sex: params[:sex]).call
    render json: results
  end

  def relationship
    relationship = Person.relationship_info(params[:id], params[:relation_id])
    render json: relationship
  end


  private

  def person_params
    params.require(:person)
          .permit(:name, 
                  :sex, 
                  :title, 
                  :birth_date, 
                  :death_date, 
                  :father_id, 
                  :mother_id,
                  :birth_date_approximate,
                  :death_date_approximate
                  )
  end

 

  def consort_params
    params[:person].permit(consorts_attributes: :id)[:consorts_attributes]
  end

  def set_consorts(person)
    person.consort_ids = consort_params.values.map{|consort| consort[:id]} if consort_params
    person.errors.empty?
  end
end
