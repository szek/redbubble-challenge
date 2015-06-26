require 'nokogiri'
require_relative 'models/camera_make'
require_relative 'models/camera_model'
require_relative 'models/creative_work'
puts File.dirname(__FILE__)
class WorkParser
  attr_reader :makes, :models, :works, :errors
  MAKE_XML_ATTR = 'exif make'
  MODEL_XML_ATTR = 'exif model'
  WORK_IMAGES_XML_ATTR = 'urls url'
  WORK_XML_ATTRIBUTES = ['id', 'filename', MAKE_XML_ATTR, MODEL_XML_ATTR]
  DATE_XML_ATTRS = ['exif date_time', 'exif date_time_original', 'exif date_time_digitized']

  def initialize(xml)
    @doc = Nokogiri::Slop xml
    @cache = { makes: {}, models: {}, works: [] }
    @errors = []
  end

  def parse
    @doc.works.work.each do |work|
      # Skip works not produced by a camera
      if work.search(MAKE_XML_ATTR).empty?
        @errors << "Skipped Work with id: #{work.id}. Reason: No Make"
        next
      end

      data = {}
      WORK_XML_ATTRIBUTES.each { |attr| data[attr] = work.search(attr).text }

      image_nodes = work.search(WORK_IMAGES_XML_ATTR)
      image_nodes.each do |node|
        image_size = node.attr('type')
        data[image_size] = node.text
      end

      DATE_XML_ATTRS.each do |attr| 
        date_node = work.search(attr)
        unless date_node.empty?
          data[:date] = DateTime.parse date_node.text
          break
        end
      end

      digest data
    end
  end

  def digest(data)
    make = make_for data.delete(MAKE_XML_ATTR)
    model = model_for data.delete(MODEL_XML_ATTR)
    make.add_model model

    work = CreativeWork.new(data)
    @cache[:works] << work
    model.add_work work
  end

  # Getters for data after parsing
  def makes
    @cache[:makes].values
  end

  def models
    @cache[:models].values
  end

  def works
    @cache[:works]
  end

  private
  def make_for(name)
    @cache[:makes][name] ||= CameraMake.new(name)
  end

  def model_for(name)
    @cache[:models][name] ||= CameraModel.new(name)
  end
end