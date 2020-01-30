require 'hexapdf'
class PaperJudgingController < ApplicationController
  include EventApplicationsHelper
  include HexaPDF

  before_action :check_permissions, only: %i[index]

  PAPER_LETTER_SIZE_WIDTH = 792
  PAPER_LETTER_SIZE_HEIGHT = 612
  ONE_INCH_MARGIN = 72
  UNDERLINE = "_______________________________________________________\n"

  def index
  end

  def generate_forms
    @starting_point
    table_number_counter = 1
    projects = Project.order(power: :asc)
    if projects.size.positive?
      doc = HexaPDF::Document.new
      projects.each_with_index do |project, index|
        project.table_id = table_number_counter
        if project.power.nil?
          project.power = false
        end
        project.save
        table_number_counter += 1
        image = "#{Rails.root}/hackathon-config/assets/images/rubric.png"
        unless File.exist?(image)
          image = "#{Rails.root}/app/assets/images/rubric.png"
        end
        canvas = doc.pages.add([0,0,PAPER_LETTER_SIZE_WIDTH,PAPER_LETTER_SIZE_HEIGHT]).canvas

        update_font(canvas, 15, :bold)
        canvas.text("#{HackumassWeb::Application::HACKATHON_NAME} #{HackumassWeb::Application::HACKATHON_VERSION} Judging Sheet\n", at: [80,555])

        update_font(canvas, 11, :bold)
        canvas.text("Project Name:\n", at:[80, 535])
        canvas.text("#{project.title}\n", at:[160, 535])
        canvas.text("#{UNDERLINE}", at:[153, 535])


        # font: 9, perline: 67, lpos: 80, pos-= 10
        update_font(canvas, 10)
        desc = project.description
        pos = 525
        perline = 60
        lpos = 80
        i = 0
        while desc != nil and desc.length > 0
          descline = desc[0..perline]
          canvas.text("#{descline}\n", at:[lpos, pos])
          desc = desc[perline+1..desc.length]
          pos -= 10
        end


        canvas.text("Team Members:\n", at:[80, 470])
        canvas.text("#{proj_users = ""
          project.user.each do |u|
            proj_users << u.first_name + " "
            if u != project.user.last
              proj_users << u.last_name + ", "
            else
              proj_users << u.last_name
            end
          end
          proj_users}\n", at:[170, 470])
        canvas.text("#{UNDERLINE}", at:[165, 470])

        update_font(canvas, 18, :bold)
        canvas.text("Table Number\n", at:[600, 530])
        if project.power
          canvas.text("#{project.table_id} TBL\n", at:[645, 500])
        else
          canvas.text("#{project.table_id}\n", at:[645, 500])
        end


        box = HexaPDF::Layout::Box.new(content_width: 140, content_height: 60)
        box.style.border(width: 1, style: :solid)
        box.draw(canvas, 590, 490)

        canvas.image(image, at: [80,30], width: 650, height: 430)
      end
      FileUtils.mkdir_p("#{Rails.root}/public/judging") unless File.exist?("#{Rails.root}/public/judging")
      doc.write("#{Rails.root}/public/judging/judging.pdf", optimize: true)
      redirect_to "#{Rails.root}/public/judging/judging.pdf?#{Time.now.to_i}"
    end
  end

  private
  def create_judge_form(doc, id, name, team_member)
    @starting_point = PAPER_LETTER_SIZE_HEIGHT-ONE_INCH_MARGIN

    canvas = doc.pages.add([0,0,PAPER_LETTER_SIZE_WIDTH,PAPER_LETTER_SIZE_HEIGHT]).canvas
    update_font(canvas, 22, :bold)

    canvas.text("#{HackumassWeb::Application::HACKATHON_NAME} #{HackumassWeb::Application::HACKATHON_VERSION} Judging Sheet\n", at: [ONE_INCH_MARGIN, @starting_point])

    update_font(canvas, 11, :bold)

    @checkpoint = @starting_point
    canvas.text("Evaluators:\n", at:[ONE_INCH_MARGIN, @starting_point-=40])
    canvas.text("#{UNDERLINE}", at:[ONE_INCH_MARGIN + 67.5, @starting_point-=2.5])

    canvas.text("Team Name:\n", at:[ONE_INCH_MARGIN, @starting_point-=20])
    canvas.text("#{UNDERLINE}", at:[ONE_INCH_MARGIN + 74, @starting_point-=2.5])

    canvas.text("Team Members:\n", at:[ONE_INCH_MARGIN, @starting_point-=20])
    canvas.text("#{UNDERLINE}", at:[ONE_INCH_MARGIN + 94, @starting_point-=2.5])

    canvas.text("Team Number:\n", at:[ONE_INCH_MARGIN, @starting_point-=20])
    canvas.text("#{UNDERLINE}", at:[ONE_INCH_MARGIN + 86.5, @starting_point-=2.5])

    update_font(canvas, 11)
    canvas.text(name, at:[ONE_INCH_MARGIN + 76.5, @checkpoint-=62.5])
    canvas.text(team_member, at:[ONE_INCH_MARGIN + 96.5, @checkpoint-=22.5])
    canvas.text(id.to_s, at:[ONE_INCH_MARGIN + 89, @checkpoint-=22.5])

    update_font(canvas, 11, :bold)
    canvas.text("Scoring Sheet:\n", at:[ONE_INCH_MARGIN, @starting_point-=40])

    create_table(canvas)

    update_font(canvas, 10)
    first_col_left_margin = ONE_INCH_MARGIN + (107 * 0 + 5)
    second_col_left_margin = ONE_INCH_MARGIN + (107 * 1 + 5)
    third_col_left_margin = ONE_INCH_MARGIN + (107 * 2 + 6)
    fourth_col_left_margin = ONE_INCH_MARGIN + (107 * 3 + 7)
    fifth_col_left_margin = ONE_INCH_MARGIN + (107 * 4 + 8)
    sixth_col_left_margin = ONE_INCH_MARGIN + (107 * 5 + 9)

    canvas.text("Scale\n", at:[first_col_left_margin, @starting_point-=37.5])
    canvas.text("1\n", at:[second_col_left_margin, @starting_point])
    canvas.text("2\n", at:[third_col_left_margin, @starting_point])
    canvas.text("3\n", at:[fourth_col_left_margin, @starting_point])
    canvas.text("4\n", at:[fifth_col_left_margin, @starting_point])
    canvas.text("Total\n", at:[sixth_col_left_margin, @starting_point])

    ################################################################################################

    canvas.text("Originality\n", at:[first_col_left_margin, @starting_point-=27.5])

    canvas.text("5pts - Project directly\n", at:[second_col_left_margin, @starting_point])
    canvas.text("replicates an existing\n", at:[second_col_left_margin, @starting_point-12])
    canvas.text("technology.\n", at:[second_col_left_margin, @starting_point-24])

    canvas.text("10pts - Project makes\n", at:[third_col_left_margin, @starting_point])
    canvas.text("minor changes to an\n", at:[third_col_left_margin, @starting_point-12])
    canvas.text("existing technology.\n", at:[third_col_left_margin, @starting_point-24])

    canvas.text("15pts - Project is\n", at:[fourth_col_left_margin, @starting_point])
    canvas.text("original but lacks\n", at:[fourth_col_left_margin, @starting_point-12])
    canvas.text("creativity or a WOW\n", at:[fourth_col_left_margin, @starting_point-24])
    canvas.text("factor.\n", at:[fourth_col_left_margin, @starting_point-36])

    canvas.text("20pts - Project is\n", at:[fifth_col_left_margin, @starting_point])
    canvas.text("original, creative,\n", at:[fifth_col_left_margin, @starting_point-12])
    canvas.text("and has a WOW\n", at:[fifth_col_left_margin, @starting_point-24])
    canvas.text("factor.\n", at:[fifth_col_left_margin, @starting_point-36])

    canvas.text(" / 20 pts\n", at:[sixth_col_left_margin, @starting_point])

    ################################################################################################

    canvas.text("Execution\n", at:[first_col_left_margin, @starting_point-=60])

    canvas.text("12.5pts - Nothing\n", at:[second_col_left_margin, @starting_point])
    canvas.text("in the project works.\n", at:[second_col_left_margin, @starting_point-12])

    canvas.text("25pts - Parts of the\n", at:[third_col_left_margin, @starting_point])
    canvas.text("project work correctly\n", at:[third_col_left_margin, @starting_point-12])
    canvas.text("based on the\n", at:[third_col_left_margin, @starting_point-24])
    canvas.text("objective.\n", at:[third_col_left_margin, @starting_point-36])

    canvas.text("37.5pts - The project\n", at:[fourth_col_left_margin, @starting_point])
    canvas.text("is successful, however\n", at:[fourth_col_left_margin, @starting_point-12])
    canvas.text("minor details don’t\n", at:[fourth_col_left_margin, @starting_point-24])
    canvas.text("work correctly.\n", at:[fourth_col_left_margin, @starting_point-36])

    canvas.text("50 pts - The project is\n", at:[fifth_col_left_margin, @starting_point])
    canvas.text("completely successful\n", at:[fifth_col_left_margin, @starting_point-12])
    canvas.text("and does exactly what\n", at:[fifth_col_left_margin, @starting_point-24])
    canvas.text("it is supposed to do.\n", at:[fifth_col_left_margin, @starting_point-36])

    canvas.text(" / 50 pts\n", at:[sixth_col_left_margin, @starting_point])

    ################################################################################################

    canvas.text("Presentation\n", at:[first_col_left_margin, @starting_point-=60])
    canvas.text("7.5pts - Extremely\n", at:[second_col_left_margin, @starting_point])
    canvas.text("poor communication\n", at:[second_col_left_margin, @starting_point-12])
    canvas.text("between team\n", at:[second_col_left_margin, @starting_point-24])
    canvas.text("members and no\n", at:[second_col_left_margin, @starting_point-36])
    canvas.text("presentation at all.\n", at:[second_col_left_margin, @starting_point-48])

    canvas.text("15pts - The team is\n", at:[third_col_left_margin, @starting_point])
    canvas.text("able to communicate\n", at:[third_col_left_margin, @starting_point-12])
    canvas.text("what their project\n", at:[third_col_left_margin, @starting_point-24])
    canvas.text("does however does\n", at:[third_col_left_margin, @starting_point-36])
    canvas.text("not have a strong.\n", at:[third_col_left_margin, @starting_point-48])
    canvas.text("understanding or\n", at:[third_col_left_margin, @starting_point-60])
    canvas.text("grasp.\n", at:[third_col_left_margin, @starting_point-72])

    canvas.text("22.5pts - The team \n", at:[fourth_col_left_margin, @starting_point])
    canvas.text("has a strong\n", at:[fourth_col_left_margin, @starting_point-12])
    canvas.text("understanding of\n", at:[fourth_col_left_margin, @starting_point-24])
    canvas.text("their project and\n", at:[fourth_col_left_margin, @starting_point-36])
    canvas.text("can explain it well,\n", at:[fourth_col_left_margin, @starting_point-48])
    canvas.text("however they miss\n", at:[fourth_col_left_margin, @starting_point-60])
    canvas.text("minor details.\n", at:[fourth_col_left_margin, @starting_point-72])

    canvas.text("30pts - The team can\n", at:[fifth_col_left_margin, @starting_point])
    canvas.text("effectively and\n", at:[fifth_col_left_margin, @starting_point-12])
    canvas.text("optimally explain what\n", at:[fifth_col_left_margin, @starting_point-24])
    canvas.text("their project entails\n", at:[fifth_col_left_margin, @starting_point-36])
    canvas.text("and how it is\n", at:[fifth_col_left_margin, @starting_point-48])
    canvas.text("implemented in a very\n", at:[fifth_col_left_margin, @starting_point-60])
    canvas.text("clear and concise\n", at:[fifth_col_left_margin, @starting_point-72])
    canvas.text("manner.\n", at:[fifth_col_left_margin, @starting_point-84])

    canvas.text(" / 30 pts\n", at:[sixth_col_left_margin, @starting_point])

    ################################################################################################

    canvas.text("Judges Feeling\n", at:[first_col_left_margin, @starting_point-=121])
    canvas.text("I dislike the project.\n", at:[second_col_left_margin, @starting_point])
    canvas.text("I like the project.\n", at:[third_col_left_margin, @starting_point])
    canvas.text("I love the project.\n", at:[fourth_col_left_margin, @starting_point])
    canvas.text("404 not found.\n", at:[fifth_col_left_margin, @starting_point])
    canvas.text(" / 3 pts\n", at:[sixth_col_left_margin, @starting_point])
  end

  def update_font(canvas, size, variant=nil)
    if variant.nil?
      canvas.font("Helvetica", size: size)
    else
      canvas.font("Helvetica", size: size, variant: variant)
    end
  end

  def create_table(canvas)
    box_border_width = 0.5
    box_border_style = :solid
    box_width = PAPER_LETTER_SIZE_WIDTH - (ONE_INCH_MARGIN * 2)
    box_height = @starting_point - 20 - ONE_INCH_MARGIN
    col_segment =  box_width/6

    box = HexaPDF::Layout::Box.new(content_width: box_width, content_height: box_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN, ONE_INCH_MARGIN)

    box = HexaPDF::Layout::Box.new(content_width: col_segment, content_height: box_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN, ONE_INCH_MARGIN)

    box = HexaPDF::Layout::Box.new(content_width: col_segment, content_height: box_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN + col_segment, ONE_INCH_MARGIN)

    box = HexaPDF::Layout::Box.new(content_width: col_segment, content_height: box_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN + col_segment * 2, ONE_INCH_MARGIN)

    box = HexaPDF::Layout::Box.new(content_width: col_segment, content_height: box_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN + col_segment * 3, ONE_INCH_MARGIN)

    box = HexaPDF::Layout::Box.new(content_width: col_segment, content_height: box_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN + col_segment * 4, ONE_INCH_MARGIN)

    box = HexaPDF::Layout::Box.new(content_width: col_segment, content_height: box_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN + col_segment * 5, ONE_INCH_MARGIN)

    row1_height = box_height / 10
    row2_height = box_height / 5
    row3_height = box_height / 5
    row4_height = box_height / 2.5
    row5_height = box_height / 10

    box = HexaPDF::Layout::Box.new(content_width: box_width, content_height: row1_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN, ONE_INCH_MARGIN + (box_height - row1_height))

    box = HexaPDF::Layout::Box.new(content_width: box_width, content_height: row2_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN, ONE_INCH_MARGIN + (box_height - row1_height - row2_height))

    box = HexaPDF::Layout::Box.new(content_width: box_width, content_height: row3_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN, ONE_INCH_MARGIN + (box_height - row1_height - row2_height - row3_height))

    box = HexaPDF::Layout::Box.new(content_width: box_width, content_height: row4_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN, ONE_INCH_MARGIN + (box_height - row1_height - row2_height - row3_height - row4_height))

    box = HexaPDF::Layout::Box.new(content_width: box_width, content_height: row5_height)
    box.style.border(width: box_border_width, style: box_border_style)
    box.draw(canvas, ONE_INCH_MARGIN, ONE_INCH_MARGIN)
  end

  # Only admins and organizers have the ability to all permission except delete
  def check_permissions
    redirect_to index_path, alert: lack_permission_msg unless admin?
  end

end