class CategoriesController < ApplicationController

  def index
    categories = Category.all
    render json: CategoryBlueprint.render(categories)
  end

  def show
    category = Category.find_by(id: params[:id])
    if category
      render json: QuoteBlueprint.render(category.quotes.sample)
    else
      render json: category.errors
    end
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end


end
