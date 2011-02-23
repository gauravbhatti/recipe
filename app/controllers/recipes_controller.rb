class RecipesController < ApplicationController
  before_filter :require_user
  
  layout "source"
  
  def index
    @recipes = current_user.recipes.paginate(:all, :order=>"created_at DESC", :page => params[:page], :per_page => 10)
  end
  
  def new
    @recipe = Recipe.new
    render :layout => false
  end
  
  def create
    @recipe = current_user.recipes.new(params[:recipe])
    if @recipe.save
      render :update do |page|
        page.call "Modalbox.hide"
        page.insert_html :top, "recipe_table", :partial => "recipe", :locals=>{:recipe=>@recipe}
      end
    else
      render :update do |page|
        page.replace_html "errors", "#{error_messages_for :recipe}"
        page.call "Modalbox.resizeToContent"
      end
    end
  end
  
  def show
    @recipe = Recipe.find_by_id(params[:id])
    render :layout => "recipe"
  end
  
  def edit
    @recipe = current_user.recipes.find_by_id(params[:id])
    render :layout => "recipe"
  end
  
  def update
    @recipe = current_user.recipes.find_by_id(params[:id])
    if @recipe.update_attributes(params[:recipe])
      flash[:notice] = "Account updated!"
      redirect_to recipe_path(@recipe)
    else
      render :action => :edit, :layout => "recipe"
    end
  end
  
  def destroy
    @recipe = current_user.recipes.find(params[:id])
    @recipe.destroy
    if request.xhr?
      render :update do |page|
        page.remove "recipe_#{params[:id]}"
      end
    end
  end
  
  def rate
    @recipe = Recipe.find(params[:id])
    @recipe.rate(params[:stars], current_user, params[:dimension])
    render :update do |page|
      page.replace_html @recipe.wrapper_dom_id(params), ratings_for(@recipe, params.merge(:wrap => false))
      page.visual_effect :highlight, @recipe.wrapper_dom_id(params)
    end
  end
  
end
