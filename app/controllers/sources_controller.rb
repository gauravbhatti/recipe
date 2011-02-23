class SourcesController < ApplicationController
  before_filter :require_user
  
  layout "source"
  
  def new
    @source = Source.new
    render :layout => false
  end
  
  def index
    @sources = current_user.sources.paginate(:all, :order=>"created_at DESC", :conditions => {:source_type => params[:type]}, 
                                                                                            :page => params[:page], :per_page => 10)
  end
  
  def create
    @source = current_user.sources.new(params[:source])
    @source.source_type = params[:source_type]
    if @source.save
      render :update do |page|
        page.call "Modalbox.hide"
        page.insert_html :top, "source_type_table", :partial => "source_type", :locals=>{:source=>@source}
      end
    else
      render :update do |page|
        page.replace_html "errors", "#{error_messages_for :source}"
        page.call "Modalbox.resizeToContent"
      end
    end
  end
  
  def show
    @source = Source.find_by_id(params[:id])
    render :layout => "recipe"
  end
  
  def edit
    @source = current_user.sources.find_by_id(params[:id])
    render :layout => "recipe"
  end
  
  def update
    @source = current_user.sources.find_by_id(params[:id])
    if @source.update_attributes(params[:source])
      flash[:notice] = "Account updated!"
      redirect_to source_path(@source)
    else
      render :action => :edit, :layout => "recipe"
    end
  end
  
  def destroy
    @source = current_user.sources.find(params[:id])
    @source.destroy
    if request.xhr?
      render :update do |page|
        page.remove "source_#{params[:id]}"
      end
    end
  end
  
  def other_recipes
    source = current_user.sources.find_by_id(params[:id])
    @recipes = source.recipes.find(:all)
    render :update do |page|
      page.replace_html "other_recipes", :partial => "source_recipes", :locals=>{:recipes=>@recipes}
    end
  end
  
end
