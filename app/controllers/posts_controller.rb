class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    if params[:query].present?
      @posts = Post.search_by_title_and_content(params[:query])
    else
      @posts = Post.all
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(:created_at).reverse
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save!
      redirect_to post_path(@post), notice: "Votre article a été publié avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def my_posts
    @posts = Post.where(user: current_user)
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :url, :photo)
  end
end
