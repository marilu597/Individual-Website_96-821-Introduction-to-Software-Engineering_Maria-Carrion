
require 'reports_helper.rb'

class ReportsController < ApplicationController

  before_filter :authenticate_user!, :only => [:edit, :update, :destroy]

  helper_method :can_edit

  # GET /reports
  # GET /reports.json
  def index

    if params[:user_id]
      @reports = User.find(params[:user_id]).reports.order("created_at DESC")
    else

      @reports = Report.order("created_at DESC")
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reports }
      format.xml { render xml: @reports }
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @report }
      format.xml { render xml: @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.json
  def new
    @report = Report.new
    @reports = Report.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @report }
      format.xml { render xml: @report }
    end
  end

  # GET /reports/1/edit
  def edit

    @report = Report.find(params[:id])

     redirect_to root_path, notice: "Sorry, you can't edit this report." unless can_edit(@report.user_id, user_signed_in?, current_user)

  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(params[:report])

    if user_signed_in?
      @report.user_id = current_user.id
    else
      @report.user_id = nil
    end

    @report.date_created = Time.now
    @report.date_updated = Time.now

    respond_to do |format|
      if @report.save
        #format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.html { redirect_to root_path, notice: 'Report was successfully created.' }
        format.json { render json: @report, status: :created, location: @report }
        format.xml { render xml: @report, status: :created, location: @report }
      else
        format.html { render action: "new" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
        format.xml { render xml: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.json
  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(params[:report])
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { head :no_content }
        format.xml { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @report.errors, status: :unprocessable_entity }
        format.xml { render xml: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    redirect_to root_path, notice: "Sorry, you can't delete this report." unless can_edit(@report.user_id, user_signed_in?, current_user)

    respond_to do |format|
      format.html { redirect_to reports_url }
      format.json { head :no_content }
    end
  end

  def filter

    @reports = Report.where("description like ? OR location like ?", "%#{params[:filter][:search]}%", "%#{params[:filter][:search]}%").order("created_at DESC")


    render 'index'


  end



  #private
  def can_edit(user_id, user_signed_in, current_user)

    return false unless user_signed_in

    if current_user.id == user_id || current_user.email == "admin@admin.com"
      return true
    end
  end


  def self.author(report)

    return "Anonymous" unless report.user_id != nil

    report.user.complete_name
  end



end
