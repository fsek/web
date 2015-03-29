cm_roman = 'app/assets/fonts/cmunrm.ttf'
cm_italic = 'app/assets/fonts/cmunti.ttf'
cm_slanted = 'app/assets/fonts/cmunsl.ttf'
helvetica = 'app/assets/fonts/helvetica-bold.ttf'

prawn_document :margin => [ 80, 80, 80, 80 ] do |doc|
  doc.font cm_roman
  doc.font_size 11

  doc.text "Lund, den #{l Date.today, :format => :long}", :align => :right

  doc.move_down 56

  doc.font helvetica
  doc.font_size 20
  doc.text 'Motion'
  doc.text @proposal.title.to_s

  doc.move_down 16
  doc.font cm_roman
  doc.font_size 11
  doc.text @proposal.body.to_s, :align => :justify

  doc.move_down 16
  doc.text 'Jag yrkar därför'
  doc.move_down 16

  @proposal.points.each_with_index do |p, i|
    doc.text "#{i + 1}."
    doc.move_up 13.5

    doc.indent 20 do
      doc.font cm_italic
      doc.text 'att'
      doc.move_up 13.5
    end

    doc.indent 56 do
      doc.font cm_roman
      doc.text p.to_s, :align => :justify
    end

    doc.move_down 16
  end

  doc.indent 20 do
    doc.move_down 32
    doc.text 'Vänligen,'

    doc.move_down 64
    doc.text @proposal.sign_name
    doc.font cm_italic
    doc.text @proposal.sign_title
  end

  doc.font cm_roman

  # Keep this last
  doc.number_pages '<page>', :align => :center, :at => [ 0, -20 ]
end

