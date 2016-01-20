# coding:utf-8
require 'will_paginate/array'

class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index

    if params[:del_post_id]
      Post.find_by_sql("delete from Posts where id = " + params[:del_post_id].to_s)
    end

    @tags = Tag.all

    @all_tag_ids = Post.tag_idcollection
    if params[:tag_id]
      @tag = params[:tag_id]
    else
      @tag = @all_tag_ids
    end
    @posts = Post.where(tag_id: @tag, status_id:[1, 2]).paginate(page: params[:page])

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
    @statuses = Status.all[0, 2]
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to @post
#    respond_to do |format|    
#      if @post.save   
#        format.html { redirect_to @post, notice: 'Post was successfully created.' }   
#        format.json { render :show, status: :created, location: @post }   
#      else    
#        format.html { render :new }   
#        format.json { render json: @post.errors, status: :unprocessable_entity }    
#      end   
#    end
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

  def addcomment
    
    
  end

  def jietie
    if post_id = params[:post_id]
      Post.find_by_sql('update Posts set status_id = 4 where id = ' + post_id.to_s)
      @post = Post.where(id: post_id)
      redirect_to @post[0]
    end
  end

  def juanzeng
    if post_id = params[:post_id]
      Post.find_by_sql('update Posts set status_id = 3 where id = ' + post_id.to_s)
      @post = Post.where(id: post_id)
      if @post
        redirect_to @post[0]
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def delpost
    if params[:post_id]
      Post.find_by_sql('delete from Posts where id = ' + params[:post_id].to_s)
      redirect_to current_user
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
