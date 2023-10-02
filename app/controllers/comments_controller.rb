class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    authorize @comment
    @comment.user = current_user
    @post = Post.find(params[:post_id])
    @comment.post = @post
    if @comment.save!
      redirect_to post_path(@post), notice: "Votre commentaire a été publié avec succès"
    else
      render "/posts/#{@post}", status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:rating, :content)
  end
end
