class Buttercms::CategoriesController < Buttercms::BaseController
  def show
    @category = ButterCMS::Category.find(cat_params)
    @posts = ButterCMS::Post.all({:page => 1, :page_size => 10, :category_slug => cat_params})
  end

  private

  def cat_params
  	cat=params[:slug]
  end
end