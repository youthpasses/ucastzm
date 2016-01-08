# coding:utf-8
require 'will_paginate/array'

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @tags = Tag.all

    @all_tag_ids = Post.tag_idcollection
    if params[:tag_id]
      @tag = params[:tag_id]
    else
      @tag = @all_tag_ids
    end
    @posts = Post.where(tag_id: @tag).paginate(page: params[:page])

    if params[:keyword]
      #@posts = Post.find(:all, :conditions => ['title like ?', '%#{params[:keyword]}%'])
      #@posts = Post.where(:all, :conditions => { :tag_id => 1..10 }).paginate(page: params[:page])
      #@posts = Post.where('title LIKE ?', '%#{params[:keyword]}%').paginate(page: params[:page])
      @posts = Post.find_by_sql("select * from Posts where title LIKE '%" + params[:keyword] + "%' or content LIKE '%" + params[:keyword] + "%'").paginate(page: params[:page])
    end

  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @comments = Comment.where(post_id: params[:id])
    if logged_in?
      #@like = Like.where(post_id: params[:id], user_id: current_user.id)
      
      if params[:havelike] == '1'
        if params[:like] == '1'
          @like = Like.new(:post_id => params[:id], :user_id => current_user.id)
          @like.save
        else
          Like.find_by_sql("delete from Likes where post_id = " + params[:id] + " and user_id = " + current_user.id.to_s )
        end
      end
      @likes = Like.find_by_sql("select * from Likes where post_id = " + params[:id] + " and user_id = " + current_user.id.to_s )
    end
    
  end

  # GET /posts/new
  def new
    @post = Post.new
    @tags = Tag.all
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.status_id = 1

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def delpost
    @posts = Post.find_by_sql('select * from Post where id = ' + post_id.to_s)
    posts.each do |post|
      post.destroy
    end
    #Post.find_by_sql('delete from Post where id = ' + @post.id.to_s)
    respond_to do |format|
      format.html { redirect_to current_user, notice: '删除成功！' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:user_id, :title, :content, :time, :status_id, :tag_id, :picture)
    end
end
