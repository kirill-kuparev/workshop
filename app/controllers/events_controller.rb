class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  def index
    @events = Event.draft_is false
  end

  # GET /events/1
  def show
    @free_places = @event.compute_free_places
    @occupied_places = @event.compute_occupied_places
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    @event.draft = (params[:draft] != nil)

    if @event.save
      redirect_to @event, notice: 'Event wurde erstellt.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    attrs = event_params

    @event.draft = (params[:commit] == "draft")

    if @event.update(attrs)
      redirect_to @event, notice: 'Event wurde aktualisiert.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Event wurde gelöscht.'
  end

  # GET /events/1/badges
  def badges
    @event = Event.find(params[:event_id])
    @participants = @event.participants
  end

  # POST /events/1/badges
  def print_badges
    names = badges_name_params

    # pdf document initialization
    pdf = Prawn::Document.new(:page_size => 'A4')
    pdf.stroke_color "000000"

    # divide in pieces of 10 names
    badge_pages = names.each_slice(10).to_a
    badge_pages.each_with_index do | page, index |
      create_badge_page(pdf, page, index)
    end


    send_data pdf.render, filename: "badges.pdf", type: "application/pdf", disposition: "inline"
  end

  # GET /events/1/participants
  def participants
    @event = Event.find(params[:id])
    @participants = @event.participants_by_agreement_letter
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:name, :description, :max_participants, :kind, :organizer, :knowledge_level, date_ranges_attributes: [:start_date, :end_date, :id])
    end

    # Generate all names to print from the query-params
    #
    # @return participant_names as array of strings
    def badges_name_params
      params.select { |key, value| key.include? "_print" }.values
    end

    # Create a name badge in a given pdf
    #
    # @param pdf, is a prawn pdf-object
    # @param name [String] is the name label of the new badge
    # @param x [Integer] is the x-coordinate of the upper left corner of the new badge
    # @param y [Integer] is the y-coordinate of the upper left corner of the new badge
    def create_badge(pdf, name, x, y)
      width = 260
      height = 150

      pdf.stroke_rectangle [x, y], width, height
      pdf.text_box name, :at => [x + width / 2 - 50 , y - 20], :width => width - 100, :height => height - 100, :overflow => :shrink_to_fit
    end

    # Create a page with maximum 10 badges
    #
    # @param pdf, is a prawn pdf-object
    # @param names [Array of Strings] are the name which are printed to the badges
    # @param index [Number] the page number
    def create_badge_page(pdf, names, index)
      # create no pagebreak for first page
      pdf.start_new_page if index > 0

      names.each_slice(2).with_index do |(left, right), row|
        create_badge(pdf, left, 0, 750 - row * 150)
        create_badge(pdf, right, 260, 750 - row * 150) unless right.nil?
      end
    end
end
