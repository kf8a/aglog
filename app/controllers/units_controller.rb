class UnitsController < ApplicationController

  def new
  	@unit = Unit.new
  end

	# GET /units/1;edit
  def edit
  	@unit = Unit.find(params[:id])
  end

	# GET /units/1
	# GET /units/1.xml
  def show
  	@unit = Unit.find(params[:id])
  	
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @unit.to_xml }
    end
  end

	# GET /units
	# GET /units.xml
  def index
  	@units = Unit.find(:all)
  	
  	respond_to do |format|
  		format.html # index.rhtml
  		format.xml  { render :xml => @units.to_xml }
  	end
  end
  
  # POST /units
  # POST /units.xml
  def create
    @unit = Unit.new(params[:unit])
    
    respond_to do |format|
      if @unit.save
        flash[:notice] = 'Unit was successfully created.'
        
        format.html { redirect_to unit_url(@unit) }
        format.xml do
          headers["Location"] = unit_url(@unit)
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @unit.errors.to_xml }
      end
    end
  end

	# PUT /units/1
	# PUT /units/1.xml
	def update
		@unit = Unit.find(params[:id])
	
		respond_to do |format|
			if @unit.update_attributes(params[:unit])
				format.html { redirect_to unit_url(@unit) }
				format.xml	{ render :nothing => true }
			else
				format.html { render :action => "edit" }
				format.xml	{ render :xml => @unit.errors.to_xml }      
      end
    end
  end
  
  # DELETE /units/1
  # DELETE /units/1.xml
  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy
    
    respond_to do |format|
      format.html { redirect_to units_url   }
      format.xml  { render :nothing => true }
    end
  end
  
end