require 'json'

class ResumeIdentifier
  def initialize json
    @json = json
  end
  
  def attachments
    return @attachments if defined?(@attachments)
    
    @attachments = if data.has_key?('attachments')
      data['attachments'].map do |attachment|
        {
          name: attachment['display_name'],
          url: attachment['url']
        }
      end
    else
      []
    end
  end
  
  def preview_url
    data['preview_url']
  end
  
  def resume_url
    resume = attachments.detect{|a| a[:name] =~ /resum/i}
    cover = attachments.detect{|a| a[:name] =~ /cover/i}
    
    if resume
      resume[:url]
    elsif cover
      (attachments - [cover]).first[:url]
    else
      preview_url
    end
  end
  
  private
  
  def data
    return @data if defined?(@data)
    
    begin
      @data = JSON.parse(@json)
    rescue
      @data = {}
    end
  end
end