require 'fastercsv'

class DataUploadController < ApplicationController

  TEMP_PATH = "#{RAILS_ROOT}/tmp/"
  TEMP_SUBDIR = "#{RAILS_ROOT}/tmp/file_upload/"

  before_filter :check_is_admin_or_datamanager

  def index
    
  end

  def upload
    create_temp_dir
    remove_old_temp_files
    mode = params[:mode]
    data = params[:file]
    
    tmp_file = create_temp_file data
    redirect_to :action => 'preview', :tmp_file => tmp_file, :mode => mode
  end
  
  def preview
  
    @mode      = params[:mode]
    @tmp_file  = params[:tmp_file]
    @data      = []
    @col_count = 0
    @upload_validation_info = UploadValidationInfo.new
    FasterCSV.foreach(@tmp_file, :col_sep => "\t") do |row|
      @col_count = [@col_count, row.length].max
      @data << row
    end
    @cols = Array.new(@col_count)
    @column_mapping = column_mapping_for(params[:mode])
  end
  
  def validate
    @mode      = params[:mode]
    @tmp_file  = params[:tmp_file]
    @col_count = params[:col_count].to_i
    
    @data      = []
    @col_count = 0
    @column_mapping = column_mapping_for(params[:mode])
    
    FasterCSV.foreach(@tmp_file, :col_sep => ",") do |row|
      @col_count = [@col_count, row.length].max
      @data << row
    end

    @cols = []
    0.upto(@col_count - 1) do |i|
      @cols << params[('col_' + i.to_s).to_sym]
    end
    
    @upload_validation_info = validate_data(@mode, @data, @cols)
    
    if @upload_validation_info.missing_info?
      render :action => 'preview'
    else
      save_data
      flash[:notice] = 'Die Daten wurden importiert'.t
      redirect_to :action => 'index'
    end
  end
  
  private
  def save_data
    @data.each do |row|
      new_inst = send 'create_' + @mode + '_from_row', row
      new_inst.save!
    end
  end
  
  protected
  def init_menu
    @menu = [:admin]
  end

  private
  def check_is_admin_or_datamanager
    unless logged_in? && (current_user.has_role?('admin') || current_user.has_role?('datamanager'))
      flash[:error] = 'Für die Admin Funktionen müssen sie als Administrator eingeloggt sein'.t
      redirect_to :controller => '/home', :action => 'index'
      return false
    end
  end
  
  private
  def create_temp_dir
    Dir.mkdir(TEMP_PATH, 0777)   unless File.exist?(TEMP_PATH)
    Dir.mkdir(TEMP_SUBDIR, 0777) unless File.exist?(TEMP_SUBDIR)
  end
  
  private
  def create_temp_file data
    begin
      filename = TEMP_SUBDIR + random_word + '.csv'
    end while File.exist? filename
    
    f = File.new(filename, "wb")
    puts "LOCAL PATH: " + if data.local_path then data.local_path else 'nixda' end
    
    f << data.read
    
    f.close
    filename
  end
  
  private
  def remove_old_temp_files
    begin
      t = 1.hours.ago
      Dir.foreach(TEMP_SUBDIR) do |file_name| 
        file = TEMP_SUBDIR + file_name
        puts "Hello: " + file_name + ": " + File.mtime(file).to_s
        if file_name.length > 3 && File.mtime(file) < t
          file_data = file_name.split('.').first
          File.delete(file)
        end
      end
    rescue
      return nil
    end
  end

  private
  def random_word len=6
    s = ''
    1.upto(len) do
      s << (97 + rand(26)).chr
    end
    s
  end
  
  private
  def column_mapping_for mode
    case mode
      when 'countries'
        %w{city name shortname company_comment acreage yearly_production}
      when 'categories'
        %w{country parent_category name category_comment}
      when 'merchandises'
        %w{name category}
      when 'brands'
        %w{name merchandise}
      when 'wines'
        %w{brand vintage}
    end
  end
  
  private
  def validate_data mode, data, column_mapping
    uvi = UploadValidationInfo.new
    data.each do |row|
      0.upto(column_mapping.length - 1) do |i|
        send 'validate_' + mode, uvi, i, column_mapping[i], row
      end
    end
    uvi
  end

  private
  def validate_countries uvi, col_index, col_field, row
    case col_field
      when 'city'
        city_string = row[col_index]
        if city_string.blank?
          uvi.inc_missing_cities
        else
          c = find_city(city_string)
          if c.nil?
            uvi.add_unknown_city(row[col_index])
          end
        end
      when 'name'
        if row[col_index].blank?
          uvi.inc_missing_country_name
        end
      when 'shortname'
        if row[col_index].blank?
          uvi.inc_missing_country_short_name
        end
      when 'company_comment'
        #ok
      when 'acreage'
        #ok
      when 'yearly_production'
        #ok
      else
        unless col_field.blank?
          raise 'Interner Fehler' + ': ' + col_field.to_s
        end
    end
  end
  
  private
  def validate_categories uvi, col_index, col_field, row
  
  end
  
  private
  def validate_merchandises uvi, col_index, col_field, row
  
  end
  
  private
  def validate_brands uvi, col_index, col_field, row
  
  end
  
  private
  def validate_wines uvi, col_index, col_field, row
  
  end

  private
  def create_countries_from_row row
    total_results, hits = Company.find_id_by_contents(row[@cols.index('name')])
    if hits.length == 0
      c = Company.new
    else
      cid = hits[0][:id]
      c = Company.find_by_id(cid)
    end
    
    1.upto(@cols.length - 1) do |i|
      col = @cols[i]
      unless col.blank?
        val = row[i]
        if col == 'city'
          col = 'city_id'
          puts "**** search " + val
          val = City.find_by_contents(val).first.id
          puts "****"
          puts val
        end
        c.send col + '=', val
      end
    end
    c
  end
  
#  private
#  def create_categories_from_row row
#    total_results, hits = Category.find_id_by_contents(row[@cols.index('name')])
#    if hits.length == 0
#      c = Category.new
#    else
#      cid = hits[0][:id]
#      c = Category.find_by_id(cid)
#    end
#    
#    1.upto(@cols.length - 1) do |i|
#      col = @cols[i]
#      unless col.blank?
#        val = row[i]
#        if col == 'country'
#          col = 'company_id'
#          tmp = val
#          if val.blank?
#            val = nil
#          else
#            res = Company.find_by_contents(val)
#            if res.length == 0
#              val = nil
#            else
#              val = res.first.id
#            end
#          end
#          
#          puts "SEARCHING COUNTRY FOR REGION " + row.to_s
#          puts tmp
#          puts val
#          puts "*****************************************************************"
#        elsif col == 'parent_category'
#          col = 'parent_category_id'
#          if val.blank?
#            val = nil
#          else
#            puts "search_category:" + val.to_s
#            res = Category.find_by_contents(val)
#            if res.length > 0
#              val = res.first.id
#            else
#              val = nil
#            end
#          end
#        end
#        c.send col + '=', val
#      end
#    end
#    c
#  end
  
#  private
#  def find_city txt
#    puts "FIND_CONTINENT"
#    total_results, hits = City.find_id_by_contents(txt)
#    if hits.length == 0
#      nil
#    else
#      cid = hits[0][:id]
#      City.find_by_id(cid)
#    end
#  end
end
