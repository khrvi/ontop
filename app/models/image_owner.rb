require 'net/http'
require 'RMagick'

module ImageOwner
  
  def self.upload_pictures obj, picture_field, title
    unless picture_field.blank?
      obj.add_uploaded_picture picture_field, title
    end
  end 
  
  def self.save_pictures obj, picture_field, title, params
    unless picture_field.blank?
      obj.add_uploaded_picture picture_field, title#picture_field
    end
#    obj.delete_pictures params
  end
  
  def add_uploaded_picture picture_field, title 
    add_picture('image/jpeg', picture_field, title)
  end

  def self.delete_picture(id, object)
    Album.delete_all "picture_id = #{id} and owner_id = #{object.id} and owner_type = '#{object.class}'"
  end

#  def add_picture_from_link url, title = ''
#    data = Net::HTTP.get_response(URI.parse(url)).body
#    add_picture 'image/jpeg', data, title
#  end

<<<<<<< .mine
#  def delete_pictures params
#    poly_table.find(:all, :conditions => [fk + '=?', self.id]).each do |m|
#      pid = m.picture_id
#      if params['delete_image_' + pid.to_s] == "1"
#        pic = m.picture
#        unless pic.nil?
#          Picture.delete(pid)
#        end
#        mapping_table_sym.delete_all [fk + '=? and picture_id=?', self.id, pid]
##       m.picture.destroy
##       m.destroy
#      end
#    end
#  end

  def delete_pictire id, object
    Album.delete_all "picture_id = #{id} and owner_id = #{object.id} and owner_type = #{object.class.to_s}"
    render :action => 'edit',:id => id
  end

#  def delete_picture pid
#    Picture.find(pid).destroy
#    mapping_table_sym, fk = table_data
#
#    mapping_table_sym.find(:all, :conditions => ['picture_id=?', pid]).each do |m|
#      pic = Picture.find_by_id(pid)
#      unless pic.nil?
#        pic.destroy
#        m.destroy
#      end
#    end
#  end
  def change_geometry(imgs)
    imgs.change_geometry('640x480') { |cols, rows, img|
=======
  def change_geometry(imgs)
    imgs.change_geometry!('640x480') { |cols, rows, img|
>>>>>>> .r164
      if cols < 640 || rows < 480
        img.resize!(cols, rows)
        bg = Magick::Image.new(640,480){self.background_color = "white"}
        bg.composite(img, Magick::CenterGravity, Magick::OverCompositeOp)
      else
        img.resize!(cols, rows)
      end
    }
<<<<<<< .mine
  end

  private
  def add_picture(type, data, title)
    image = Magick::Image::from_blob(data.read).first
    thumb = image.resize_to_fit(Picture::ThumbWidth, Picture::ThumbHeight)
=======
  end

  private
  def add_picture(type, data, title)
    imgs = Magick::Image::from_blob(data.read).first#}Magick::Image::read(data).first
    thumb = imgs.resize_to_fit(Picture::ThumbWidth, Picture::ThumbHeight)
>>>>>>> .r164
    pic = Picture.create(:title => title,
                         :content_type => type,
                         :icon_data => thumb.to_blob,
                         :data => image.to_blob
                        )
    poly_table.create! :picture_id => pic.id, :owner_id => self.id, :owner_type => self.class.to_s
  end

  def poly_table
    'albums'.classify.constantize
  end
end